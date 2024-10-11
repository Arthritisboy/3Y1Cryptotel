const User = require('../models/User');
const Restaurant = require('../models/Restaurant');
const RestaurantRating = require('../models/RestaurantRating'); // Updated import
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a specific rating by ID
exports.getRating = catchAsync(async (req, res, next) => {
    const rating = await RestaurantRating.findById(req.params.id).populate('userId restaurantId');

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

// Create a new rating for a restaurant
exports.createRating = catchAsync(async (req, res, next) => {
    const { rating, message, userId } = req.body;
    const { restaurantId } = req.params;

    // Log received data
    console.log('Received rating data:', { rating, message, restaurantId });
    console.log('User ID:', userId);

    // Validate restaurantId
    if (!restaurantId) {
        console.log('Restaurant ID missing in request');
        return next(new AppError('Restaurant ID is required to create a rating.', 400));
    }

    // Check if the restaurant exists
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
        console.log('Restaurant not found with ID:', restaurantId);
        return next(new AppError('Restaurant not found with this ID.', 404));
    }

    // Log that restaurant exists
    console.log('Restaurant found:', restaurant);

    // Create the rating
    const newRating = await RestaurantRating.create({ // Updated to use RestaurantRating
        rating,
        message,
        userId,
        restaurantId,
    });

    // Log that the rating was created
    console.log('New rating created:', newRating);

    // Push the new rating ID into the Restaurant's ratings array
    restaurant.ratings.push(newRating._id);
    await restaurant.save();

    // Log that the restaurant was updated with the new rating
    console.log('Restaurant updated with new rating:', restaurant);

    // Respond with the new rating
    res.status(201).json({
        status: 'success',
        data: {
            rating: newRating,
        },
    });

    // Log final success response
    console.log('Rating creation successful:', newRating);
});

// Update a specific rating by ID
exports.updateRating = catchAsync(async (req, res, next) => {
    const { rating, message } = req.body;

    const updatedRating = await RestaurantRating.findByIdAndUpdate(req.params.id, { rating, message }, { new: true, runValidators: true }); // Updated to use RestaurantRating

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
    const rating = await RestaurantRating.findByIdAndDelete(req.params.id); // Updated to use RestaurantRating

    if (!rating) {
        return next(new AppError('Rating not found', 404));
    }

    // Optional: Remove the rating ID from the Restaurant's ratings array
    await Restaurant.findByIdAndUpdate(rating.restaurantId, { $pull: { ratings: rating._id } });

    res.status(204).json({
        status: 'success',
        data: null,
    });

    // Log final success response
    console.log('Rating deletion successful.');
});
