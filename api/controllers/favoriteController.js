const User = require('../models/User');
const Favorite = require('../models/Favorite');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Add to favorites (dynamic for hotels or restaurants)
exports.addToFavorites = catchAsync(async (req, res, next) => {
  // Changed to 'addToFavorites'
  const { type, id } = req.body; // 'type' determines if it's a hotel or restaurant, 'id' is hotelId or restaurantId
  const userId = req.params.userId; // Get userId from params

  // Validate type
  if (!['hotel', 'restaurant'].includes(type)) {
    return next(
      new AppError(
        'Invalid type. Type must be either hotel or restaurant.',
        400,
      ),
    );
  }

  // Find the user
  const user = await User.findById(userId);
  if (!user) {
    return next(new AppError('User not found', 404));
  }

  // Check if the user has a favoriteId
  let favorite = await Favorite.findById(user.favoriteId); // Changed to 'Favorite'

  if (!favorite) {
    // Create a new favorite entry if the user doesn't have one yet
    const newFavorite =
      type === 'hotel'
        ? { hotels: [id], restaurants: [] }
        : { hotels: [], restaurants: [id] };
    favorite = await Favorite.create(newFavorite); // Changed to 'Favorite'
    user.favoriteId = favorite._id; // Set the user's favoriteId to the new favorite's ID
    await user.save(); // Save the user with the new favoriteId
  } else {
    // Check if the favorite already contains the item
    if (type === 'hotel' && !favorite.hotels.includes(id)) {
      favorite.hotels.push(id);
    } else if (type === 'restaurant' && !favorite.restaurants.includes(id)) {
      favorite.restaurants.push(id);
    } else {
      return next(
        new AppError(
          `${type.charAt(0).toUpperCase() + type.slice(1)} already in favorites`,
          400,
        ),
      );
    }
    await favorite.save(); // Save the updated favorites
  }

  res.status(200).json({ status: 'success', data: { favorite } });
});

// Remove from favorites (dynamic for hotels or restaurants)
exports.removeFromFavorites = catchAsync(async (req, res, next) => {
  // Changed to 'removeFromFavorites'
  const { type, id } = req.body; // 'type' determines if it's a hotel or restaurant
  const userId = req.params.userId; // Get userId from params

  // Validate type
  if (!['hotel', 'restaurant'].includes(type)) {
    return next(
      new AppError(
        'Invalid type. Type must be either hotel or restaurant.',
        400,
      ),
    );
  }

  const user = await User.findById(userId);
  if (!user || !user.favoriteId) {
    return next(new AppError('Favorites not found', 404)); // Changed to 'Favorites'
  }

  const favorite = await Favorite.findById(user.favoriteId); // Changed to 'Favorite'
  if (type === 'hotel') {
    favorite.hotels = favorite.hotels.filter(
      (hotelId) => hotelId.toString() !== id,
    );
  } else if (type === 'restaurant') {
    favorite.restaurants = favorite.restaurants.filter(
      (restaurantId) => restaurantId.toString() !== id,
    );
  }

  await favorite.save(); // Save the updated favorites

  res.status(200).json({ status: 'success', data: { favorite } });
});

// Get all favorites for a user
exports.getFavorites = catchAsync(async (req, res, next) => {
  // Changed to 'getFavorites'
  const userId = req.params.userId; // Get userId from params

  const user = await User.findById(userId).populate('favoriteId');
  if (!user || !user.favoriteId) {
    return next(new AppError('No favorites found for this user', 404)); // Changed to 'favorites'
  }

  const favorite = await Favorite.findById(user.favoriteId); // Changed to 'Favorite'
  res.status(200).json({ status: 'success', data: { favorite } });
});
