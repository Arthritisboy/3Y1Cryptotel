const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Restaurant = require('../models/Restaurant');
const Room = require('../models/Room');
const Rating = require('../models/Rating');
const { calculateAverageRating, updateAllHotelsAverage } = require('../middleware/averageCalculator');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a specific rating by ID
exports.getRating = catchAsync(async (req, res, next) => {
    const rating = await Rating.findById(req.params.id).populate('userId roomId restaurantId');

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

// Create a rating for a room or restaurant
exports.createRating = catchAsync(async (req, res, next) => {
    const { rating, message, userId } = req.body; // Get rating data from the body
    const { id } = req.params; // Get the id from the params

    // Validate that rating, message, and userId are provided
    if (!rating || !message || !userId) {
        return next(new AppError('Rating, message, and userId must be provided.', 400));
    }

    // Check if the id corresponds to a Room or Restaurant
    let targetEntity;
    targetEntity = await Room.findById(id);
    if (!targetEntity) {
        targetEntity = await Restaurant.findById(id);
        if (!targetEntity) {
            return next(new AppError('Neither Room nor Restaurant found with this ID.', 404));
        }
    }

    // Create the rating
    const newRating = await Rating.create({
        rating,
        message,
        userId, // Use userId from the body
        roomId: targetEntity instanceof Room ? targetEntity._id : undefined, // Set roomId if it's a Room
        restaurantId: targetEntity instanceof Restaurant ? targetEntity._id : undefined, // Set restaurantId if it's a Restaurant
    });

    // Add the rating to the corresponding entity's ratings array
    targetEntity.ratings.push(newRating._id);
    await targetEntity.save();

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

    // Recalculate average rating after update, but only for rooms
    if (updatedRating.roomId) {
        // await calculateAverageRating(updatedRating.roomId);  // For rooms only
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

    // Remove the rating from the Room or Restaurant's ratings array
    if (rating.roomId) {
        await Room.findByIdAndUpdate(rating.roomId, { $pull: { ratings: rating._id } });
        // await calculateAverageRating(rating.roomId);  // For rooms only
    } else if (rating.restaurantId) {
        await Restaurant.findByIdAndUpdate(rating.restaurantId, { $pull: { ratings: rating._id } });
        // No average calculation for restaurant ratings
    }

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
