const User = require('../models/User');
const Favourite = require('../models/Favourite');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Add to favourites (dynamic for hotels or restaurants)
exports.addToFavourites = catchAsync(async (req, res, next) => {
    const { type, id } = req.body; // 'type' determines if it's a hotel or restaurant, 'id' is hotelId or restaurantId
    const userId = req.params.userId; // Get userId from params

    // Validate type
    if (!['hotel', 'restaurant'].includes(type)) {
        return next(new AppError('Invalid type. Type must be either hotel or restaurant.', 400));
    }

    // Find the user
    const user = await User.findById(userId);
    if (!user) {
        return next(new AppError('User not found', 404));
    }

    // Check if the user has a favouriteId
    let favourite = await Favourite.findById(user.favouriteId);

    if (!favourite) {
        // Create a new favourite entry if the user doesn't have one yet
        const newFavourite = type === 'hotel' ? { hotels: [id], restaurants: [] } : { hotels: [], restaurants: [id] };
        favourite = await Favourite.create(newFavourite);
        user.favouriteId = favourite._id; // Set the user's favouriteId to the new favourite's ID
        await user.save(); // Save the user with the new favouriteId
    } else {
        // Check if the favourite already contains the item
        if (type === 'hotel' && !favourite.hotels.includes(id)) {
            favourite.hotels.push(id);
        } else if (type === 'restaurant' && !favourite.restaurants.includes(id)) {
            favourite.restaurants.push(id);
        } else {
            return next(new AppError(`${type.charAt(0).toUpperCase() + type.slice(1)} already in favourites`, 400));
        }
        await favourite.save(); // Save the updated favourites
    }

    res.status(200).json({ status: 'success', data: { favourite } });
});

// Remove from favourites (dynamic for hotels or restaurants)
exports.removeFromFavourites = catchAsync(async (req, res, next) => {
    const { type, id } = req.body; // 'type' determines if it's a hotel or restaurant
    const userId = req.params.userId; // Get userId from params

    // Validate type
    if (!['hotel', 'restaurant'].includes(type)) {
        return next(new AppError('Invalid type. Type must be either hotel or restaurant.', 400));
    }

    const user = await User.findById(userId);
    if (!user || !user.favouriteId) {
        return next(new AppError('Favourites not found', 404));
    }

    const favourite = await Favourite.findById(user.favouriteId);
    if (type === 'hotel') {
        favourite.hotels = favourite.hotels.filter(hotelId => hotelId.toString() !== id);
    } else if (type === 'restaurant') {
        favourite.restaurants = favourite.restaurants.filter(restaurantId => restaurantId.toString() !== id);
    }

    await favourite.save(); // Save the updated favourites

    res.status(200).json({ status: 'success', data: { favourite } });
});

// Get all favourites for a user
exports.getFavourites = catchAsync(async (req, res, next) => {
    const userId = req.params.userId; // Get userId from params

    const user = await User.findById(userId).populate('favouriteId');
    if (!user || !user.favouriteId) {
        return next(new AppError('No favourites found for this user', 404));
    }

    const favourite = await Favourite.findById(user.favouriteId);
    res.status(200).json({ status: 'success', data: { favourite } });
});
