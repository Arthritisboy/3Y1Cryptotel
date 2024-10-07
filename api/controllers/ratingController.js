const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Rating = require('../models/Rating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

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
    const { roomId } = req.params; // Get roomId from the route parameters

    // Validate roomId
    if (!roomId) {
        return next(new AppError('Room ID is required to create a rating.', 400));
    }

    // Check if the room exists
    const room = await Room.findById(roomId);
    if (!room) {
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
        return next(new AppError('Rating not found', 404));
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
        return next(new AppError('Rating not found', 404));
    }

    // Optional: Remove the rating ID from the Room's ratings array
    await Room.findByIdAndUpdate(rating.roomId, { $pull: { ratings: rating._id } });

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
