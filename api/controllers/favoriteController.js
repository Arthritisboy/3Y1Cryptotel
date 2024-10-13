const User = require('../models/User');
const Favorite = require('../models/Favorite');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

exports.addToFavorites = catchAsync(async (req, res, next) => {
    const { type, id } = req.body; 
    const userId = req.params.userId; 

    if (!['hotel', 'restaurant'].includes(type)) {
        return next(new AppError('Invalid type. Type must be either hotel or restaurant.', 400));
    }

    const user = await User.findById(userId);
    if (!user) {
        return next(new AppError('User not found', 404));
    }
 console.log(user)
    let favorite = await Favorite.findById(user.favoriteId);

    if (!favorite) {
        const newFavorite = type === 'hotel' ? { hotels: [id], restaurants: [] } : { hotels: [], restaurants: [id] };
        favorite = await Favorite.create(newFavorite);
        user.favoriteId = favorite._id;
        await user.save(); 
    } else {
        if (type === 'hotel' && !favorite.hotels.includes(id)) {
            favorite.hotels.push(id);
        } else if (type === 'restaurant' && !favorite.restaurants.includes(id)) {
            favorite.restaurants.push(id);
        } else {
            return next(new AppError(`${type.charAt(0).toUpperCase() + type.slice(1)} already in favorites`, 400));
        }
        await favorite.save(); 
    }

    res.status(200).json({ status: 'success', data: { favorite } });
});

exports.removeFromFavorites = catchAsync(async (req, res, next) => {
    const { type, id } = req.body; // 'type' determines if it's a hotel or restaurant
    const userId = req.params.userId; // Get userId from params

    // Validate type
    if (!['hotel', 'restaurant'].includes(type)) {
        return next(new AppError('Invalid type. Type must be either hotel or restaurant.', 400));
    }

    const user = await User.findById(userId);
    if (!user || !user.favoriteId) {
        return next(new AppError('Favorites not found', 404));
    }

    const favorite = await Favorite.findById(user.favoriteId);
    if (type === 'hotel') {
        favorite.hotels = favorite.hotels.filter(hotelId => hotelId.toString() !== id);
    } else if (type === 'restaurant') {
        favorite.restaurants = favorite.restaurants.filter(restaurantId => restaurantId.toString() !== id);
    }

    await favorite.save(); 

    res.status(200).json({ status: 'success', data: { favorite } });
});

exports.getFavorites = catchAsync(async (req, res, next) => {
    const userId = req.params.userId; // Get userId from params

    const user = await User.findById(userId).populate('favoriteId');
    if (!user || !user.favoriteId) {
        return next(new AppError('No favorites found for this user', 404));
    }

    const favorite = await Favorite.findById(user.favoriteId);
    res.status(200).json({ status: 'success', data: { favorite } });
});
