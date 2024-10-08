const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const HotelRating = require('../models/hotelRating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const chalk = require('chalk'); // Import chalk for colored logging

const calculateAverageRating = async (roomId) => {
    try {
        console.log(`Calculating average rating for room ID: ${roomId}`);
        const room = await Room.findById(roomId).populate('ratings');

        if (!room) {
            console.log(chalk.red(`Room not found for ID: ${roomId}`));
            throw new AppError('Room not found', 404);
        }

        const ratings = room.ratings; // Ensure this is populated correctly
        if (ratings.length === 0) {
            console.log(chalk.yellow(`No ratings found for room ID: ${roomId}. Returning 0.0`));
            return 0.0; // Return 0.0 if no ratings
        }

        const totalRating = ratings.reduce((sum, rating) => sum + rating.rating, 0);
        const average = parseFloat((totalRating / ratings.length).toFixed(1));
        console.log(chalk.blue(`Calculated average rating for room ID ${roomId}: ${average}`));
        return average; // Return rounded average with one decimal place
    } catch (error) {
        console.error(chalk.red(`Error calculating average rating for room ID ${roomId}: ${error.message}`));
        throw new AppError('Error calculating average rating', 500); // Rethrow the error to handle it at a higher level
    }
};


// Get a specific rating by ID
exports.getRating = catchAsync(async (req, res, next) => {
    try {
        console.log(chalk.green(`Getting rating with ID: ${req.params.id}`)); // Debug statement
        const rating = await HotelRating.findById(req.params.id).populate('userId roomId');

        if (!rating) {
            return next(new AppError('Rating not found', 404));
        }

        res.status(200).json({
            status: 'success',
            data: {
                rating,
            },
        });
    } catch (error) {
        console.error(chalk.red(`Error retrieving rating: ${error.message}`)); // Log error
        return next(new AppError('Failed to retrieve rating', 500)); // Respond with error
    }
});

// Create a new rating
exports.createRating = catchAsync(async (req, res, next) => {
    try {
        const { rating, message, userId } = req.body;
        const { roomId } = req.params;
        console.log(chalk.green("Creating rating...")); // Debug statement

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
        const newRating = await HotelRating.create({
            rating,
            message,
            userId,
            roomId,
        });
        console.log("Line 77")
        console.log(chalk.green(`New rating created with ID: ${newRating._id}`)); // Debug statement

        // Push the new rating ID into the Room's ratings array
        room.ratings.push(newRating._id);
        await room.save();
        console.log(chalk.green(`Added rating ID: ${newRating._id} to room ID: ${roomId}`)); // Debug statement
        console.log("84")
        // Calculate and update average rating for the hotel associated with the room
        const averageRating = await calculateAverageRating(roomId);
        console.log("87")
        const hotel = await Hotel.findOne({ rooms: roomId });
        if (hotel) {
            hotel.averageRating = averageRating; // Update hotel average rating
            await hotel.save();
            console.log(chalk.green(`Updated hotel average rating for hotel ID: ${hotel._id} to ${averageRating}`));
        }
        console.log("93")
        // Respond with the new rating
        res.status(201).json({
            status: 'success',
            data: {
                rating: newRating,
            },
        });
    } catch (error) {
        console.error(chalk.red(`Error creating rating: ${error.message}`)); // Log error
        return next(new AppError('Failed to create rating', 500)); // Respond with error
    }
});

// Update a specific rating by ID
exports.updateRating = catchAsync(async (req, res, next) => {
    try {
        console.log(chalk.green(`Updating rating with ID: ${req.params.id}`)); // Debug statement
        const { rating, message } = req.body;

        const updatedRating = await HotelRating.findByIdAndUpdate(req.params.id, { rating, message }, { new: true, runValidators: true });

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
    } catch (error) {
        console.error(chalk.red(`Error updating rating: ${error.message}`)); // Log error
        return next(new AppError('Failed to update rating', 500)); // Respond with error
    }
});

// Delete a specific rating by ID
exports.deleteRating = catchAsync(async (req, res, next) => {
    try {
        console.log(chalk.green(`Deleting rating with ID: ${req.params.id}`)); // Debug statement
        const rating = await HotelRating.findByIdAndDelete(req.params.id);

        if (!rating) {
            console.log(chalk.red(`Rating not found with ID: ${req.params.id}`));
            return next(new AppError('Rating not found', 404));
        }

        // Remove the rating ID from the Room's ratings array
        await Room.findByIdAndUpdate(rating.roomId, { $pull: { ratings: rating._id } });
        console.log(chalk.green(`Removed rating ID: ${rating._id} from room ID: ${rating.roomId}`)); // Debug statement

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
    } catch (error) {
        console.error(chalk.red(`Error deleting rating: ${error.message}`)); // Log error
        return next(new AppError('Failed to delete rating', 500)); // Respond with error
    }
});
