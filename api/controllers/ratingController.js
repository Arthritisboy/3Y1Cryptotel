const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Rating = require('../models/Rating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const chalk = require('chalk'); // Import chalk for colored logging

// Function to calculate average rating
const calculateAverageRating = async (roomId) => {
    const room = await Room.findById(roomId).populate('ratings');

    if (!room) {
        throw new AppError('Room not found', 404);
    }

    const ratings = room.ratings; // This should be populated with actual rating objects
    if (ratings.length === 0) return 0.0; // Return 0.0 if no ratings

    const totalRating = ratings.reduce((sum, rating) => sum + rating.rating, 0);
    const average = parseFloat((totalRating / ratings.length).toFixed(1));
    console.log(chalk.blue(`Calculated average rating for room ID ${roomId}: ${average}`)); // Log average rating
    return average; // Return rounded average with one decimal place
};

// Get a specific rating by ID
exports.getRating = catchAsync(async (req, res, next) => {
    const rating = await Rating.findById(req.params.id).populate('userId roomId');

    if (!rating) {
        return next(new AppError('Rating not found', 404));
    }

    res.status(200).json({
        status: 'success',
        data: {
            rating,
        },
    });
});

// Create a new rating
exports.createRating = catchAsync(async (req, res, next) => {
    const { rating, message, userId } = req.body;
    const { roomId } = req.params;

    // Validate roomId
    if (!roomId) {
        console.log(chalk.red('Room ID is required to create a rating.'));
        return next(new AppError('Room ID is required to create a rating.', 400));
    }

    // Check if the room exists
    const room = await Room.findById(roomId);
    if (!room) {
        console.log(chalk.red(`Room not found with ID: ${roomId}`));
        return next(new AppError('Room not found with this ID.', 404));
    }

    // Create the rating
    const newRating = await Rating.create({
        rating,
        message,
        userId,
        roomId,
    });

    // Push the new rating ID into the Room's ratings array
    room.ratings.push(newRating._id);
    await room.save();

    // Calculate and update average rating for the hotel associated with the room
    const averageRating = await calculateAverageRating(roomId);
    const hotel = await Hotel.findOne({ rooms: roomId });
    if (hotel) {
        hotel.averageRating = averageRating; // Update hotel average rating
        await hotel.save();
        console.log(chalk.green(`Updated hotel average rating for hotel ID: ${hotel._id} to ${averageRating}`));
    }

    // Respond with the new rating
    res.status(201).json({
        status: 'success',
        data: {
            rating: newRating,
        },
    });
});

// Update a specific rating by ID
exports.updateRating = catchAsync(async (req, res, next) => {
    const { rating, message } = req.body;

    const updatedRating = await Rating.findByIdAndUpdate(req.params.id, { rating, message }, { new: true, runValidators: true });

    if (!updatedRating) {
        console.log(chalk.red(`Rating not found with ID: ${req.params.id}`));
        return next(new AppError('Rating not found', 404));
    }

    // Automatically calculate average rating after updating
    const roomId = updatedRating.roomId; // Get roomId from the updated rating
    const averageRating = await calculateAverageRating(roomId);
    const hotel = await Hotel.findOne({ rooms: roomId });
    if (hotel) {
        hotel.averageRating = averageRating; // Update hotel average rating
        await hotel.save();
        console.log(chalk.green(`Updated hotel average rating for hotel ID: ${hotel._id} to ${averageRating}`));
    }

    res.status(200).json({
        status: 'success',
        data: {
            rating: updatedRating,
        },
    });
});

// Delete a specific rating by ID
exports.deleteRating = catchAsync(async (req, res, next) => {
    const rating = await Rating.findByIdAndDelete(req.params.id);

    if (!rating) {
        console.log(chalk.red(`Rating not found with ID: ${req.params.id}`));
        return next(new AppError('Rating not found', 404));
    }

    // Remove the rating ID from the Room's ratings array
    await Room.findByIdAndUpdate(rating.roomId, { $pull: { ratings: rating._id } });

    // Calculate and update average rating for the hotel associated with the room
    const averageRating = await calculateAverageRating(rating.roomId);
    const hotel = await Hotel.findOne({ rooms: rating.roomId });
    if (hotel) {
        hotel.averageRating = averageRating; // Update hotel average rating
        await hotel.save();
        console.log(chalk.green(`Updated hotel average rating for hotel ID: ${hotel._id} to ${averageRating}`));
    }

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
