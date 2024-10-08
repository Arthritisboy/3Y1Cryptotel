const Restaurant = require('../models/Restaurant');
const HotelRating = require('../models/hotelRating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const { uploadHotelRoomRestaurantImage } = require('../middleware/imageUpload');
const chalk = require('chalk'); // Import chalk for colored logging

// Function to calculate the average rating of the restaurant
const calculateAverageRating = async (restaurantId) => {
    const restaurant = await Restaurant.findById(restaurantId).populate('ratings');
    if (!restaurant) {
        throw new AppError('Restaurant not found with this ID.', 404);
    }

    if (restaurant.ratings.length === 0) {
        restaurant.averageRating = 0.0; // Set to 0 if no ratings are available
        console.log(chalk.yellow(`No ratings found for restaurant ID ${restaurantId}. Average rating set to 0.0.`));
    } else {
        const totalRating = restaurant.ratings.reduce((sum, rating) => sum + rating.rating, 0);
        restaurant.averageRating = parseFloat((totalRating / restaurant.ratings.length).toFixed(1)); // Round to 1 decimal place
        console.log(chalk.blue(`Calculated average rating for restaurant ID ${restaurantId}: ${restaurant.averageRating}`));
    }

    await restaurant.save(); // Save the updated average rating in the restaurant
};

// Function to calculate the average price of the restaurant
const calculateAveragePrice = async (restaurantId) => {
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
        throw new AppError('Restaurant not found with this ID.', 404);
    }

    // Assuming the price is directly related to the restaurant; modify if needed based on your schema
    const totalPrice = restaurant.price; // This example assumes there's a single price for simplicity
    restaurant.averagePrice = totalPrice; // Set average price based on available logic

    await restaurant.save(); // Save the updated average price in the restaurant
};

// Get a restaurant by ID or all restaurants
exports.getRestaurant = catchAsync(async (req, res, next) => {
    const restaurantId = req.params.id;
    let restaurant;

    if (restaurantId) {
        restaurant = await Restaurant.findById(restaurantId).populate('ratings');
        if (!restaurant) {
            return next(new AppError('Restaurant not found with this ID.', 404));
        }
        console.log(chalk.blue(`Retrieved restaurant details: ${restaurant}`));
    } else {
        restaurant = await Restaurant.find(); // Get all restaurants if no ID is provided
        console.log(chalk.blue(`Retrieved all restaurants: ${restaurant.length} restaurants found.`));
    }

    res.status(200).json({
        status: 'success',
        data: {
            restaurant,
        },
    });
});

// Create a restaurant
exports.createRestaurant = catchAsync(async (req, res, next) => {
    const { tableNumber, type, price, capacity, ratingId } = req.body;

    console.log(chalk.green('Creating restaurant with data:'), { tableNumber, type, price, capacity, ratingId });

    let restaurantImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            restaurantImage = await uploadRestaurantImage(req);
            console.log(chalk.green('Image uploaded successfully:'), restaurantImage);
        } catch (uploadErr) {
            console.error(chalk.red('Image upload error:'), uploadErr);
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    } else {
        console.log(chalk.yellow('No image file provided for the restaurant.'));
    }

    // Create the restaurant with multiple ratingIds (if provided, otherwise null)
    const newRestaurant = await Restaurant.create({
        tableNumber,
        restaurantImage: restaurantImage || undefined, // Assign image if available
        type,
        price,
        capacity,
        ratings: ratingId && ratingId.length ? ratingId : [], // Assign multiple ratingIds or an empty array
    });

    console.log(chalk.green('New restaurant created:'), newRestaurant);

    // Automatically calculate the average rating and price for the restaurant after creation
    await calculateAverageRating(newRestaurant._id);
    await calculateAveragePrice(newRestaurant._id);

    res.status(201).json({
        status: 'success',
        data: {
            restaurant: newRestaurant,
            averageRating: newRestaurant.averageRating, // Return the average rating from the restaurant instance
            averagePrice: newRestaurant.averagePrice, // Return the average price from the restaurant instance
        },
    });

    console.log(chalk.green('Response sent with new restaurant data, average rating, and average price.'));
});

// Update a restaurant by ID
exports.updateRestaurant = catchAsync(async (req, res, next) => {
    const restaurantId = req.params.id;

    // Check if the restaurant exists
    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
        return next(new AppError('Restaurant not found with this ID.', 404));
    }

    console.log(chalk.blue(`Updating restaurant with ID ${restaurantId}. Current details: ${restaurant}`));

    let restaurantImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            restaurantImage = await uploadRestaurantImage(req);
            console.log(chalk.green('Restaurant image updated:'), restaurantImage);
            req.body.restaurantImage = restaurantImage; // Add image to update body
        } catch (uploadErr) {
            console.error(chalk.red('Image upload error:'), uploadErr);
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    }

    // Update the restaurant
    const updatedRestaurant = await Restaurant.findByIdAndUpdate(restaurantId, req.body, {
        new: true,
        runValidators: true,
    });

    if (!updatedRestaurant) {
        return next(new AppError('Restaurant not found with this ID.', 404));
    }

    console.log(chalk.green(`Restaurant updated successfully:`), updatedRestaurant);

    // Automatically call the calculateAverageRating and calculateAveragePrice functions after updating
    await calculateAverageRating(restaurantId); // Use the restaurant's ID to recalculate average rating
    await calculateAveragePrice(restaurantId); // Recalculate average price

    res.status(200).json({
        status: 'success',
        data: {
            restaurant: updatedRestaurant,
        },
    });
});

// Delete a restaurant by ID
exports.deleteRestaurant = catchAsync(async (req, res, next) => {
    const restaurantId = req.params.id;

    const restaurant = await Restaurant.findById(restaurantId);
    if (!restaurant) {
        return next(new AppError('Restaurant not found with this ID.', 404));
    }

    console.log(chalk.red(`Deleting restaurant with ID ${restaurantId}. Restaurant details: ${restaurant}`));

    await Restaurant.findByIdAndDelete(restaurantId);

    // Automatically call the calculateAverageRating function after restaurant deletion
    await calculateAverageRating(restaurantId); // Recalculate average rating
    await calculateAveragePrice(restaurantId); // Recalculate average price

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
