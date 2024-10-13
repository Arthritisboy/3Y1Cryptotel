const User = require('../models/User')
const Restaurant = require('../models/Restaurant');
const RestaurantRating = require('../models/RestaurantRating');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a restaurant by ID or all restaurants (with ratings)
exports.getRestaurant = catchAsync(async (req, res, next) => {
  const restaurantId = req.params.id;
  let restaurant;

  if (restaurantId) {
    // Fetch a specific restaurant by ID and populate ratings
    restaurant = await Restaurant.findById(restaurantId).populate('ratings');
    if (!restaurant) {
      return next(new AppError('Restaurant not found with this ID.', 404));
    }
  } else {
    // Get all restaurants if no ID is provided and populate ratings
    restaurant = await Restaurant.find().populate('ratings');
  }

  res.status(200).json({
    status: 'success',
    data: {
      restaurant,
    },
  });
});

exports.createRestaurant = catchAsync(async (req, res, next) => {
  const userId = req.params.userId; // Get userId from params
  console.log('User ID from params:', userId);

  // Ensure userId is provided
  if (!userId) {
    return next(new AppError('User ID is required.', 400));
  }

  const user = await User.findById(userId);
  if (!user) {
    return next(new AppError('User not found.', 404));
  }
  console.log(user);
  if (!user.roles === 'admin') {
    return next(new AppError('User is not an Admin,', 400))
  }
  // Check if the user already has a handleId
  if (user.handleId) {
    return next(new AppError('User already is already assigned.', 400));
  }

  // // Optionally, Check if the user is authenticated
  // if (!req.user) {
  //     return next(new AppError('User not authenticated', 401));
  // }

  console.log('Authenticated User:', req.user); // Log the authenticated user

  // Destructure data from request body
  const {
    tableNumber,
    name,
    price,
    capacity,
    ratingId,
    location,
    openingHours,
  } = req.body;

  let restaurantImage;

  // Handle image upload if a file is provided
  if (req.file) {
    try {
      restaurantImage = await uploadEveryImage(req); // Upload the image
    } catch (uploadErr) {
      return res.status(500).json({
        status: 'error',
        message: 'Image upload failed',
        error: uploadErr.message || uploadErr,
      });
    }
  }

  // Create new restaurant
  const newRestaurant = await Restaurant.create({
    tableNumber,
    restaurantImage: restaurantImage || undefined,
    name,
    price,
    capacity,
    location,
    openingHours,
    ratings: ratingId && ratingId.length ? ratingId : [],
  });

  const updatedUser = await User.findByIdAndUpdate(
    userId, 
    { handleId: newRestaurant._id }, 
    { new: true, runValidators: true }
  );

  if (!updatedUser) {
    console.log('User not found for handleId update.');
    return next(new AppError('User not found.', 404));
  }

  console.log('User handleId updated with new restaurant ID:', newRestaurant._id);


  // Respond with the new restaurant data
  res.status(201).json({
    status: 'success',
    data: {
      restaurant: newRestaurant,
    },
  });
});


// Update a restaurant by ID
exports.updateRestaurant = catchAsync(async (req, res, next) => {
  const restaurantId = req.params.id;

  console.log(`Updating restaurant with ID: ${restaurantId}`);

  // Check if the restaurant exists
  const restaurant = await Restaurant.findById(restaurantId);
  if (!restaurant) {
    console.log('Restaurant not found for update.');
    return next(new AppError('Restaurant not found with this ID.', 404));
  }

  let restaurantImage = undefined;

  // Handle image upload if a file is provided
  if (req.file) {
    try {
      restaurantImage = await uploadEveryImage(req);
      console.log('Restaurant image updated:', restaurantImage);
      req.body.restaurantImage = restaurantImage; // Add image to update body
    } catch (uploadErr) {
      console.error('Image upload error:', uploadErr);
      return res.status(500).json({
        status: 'error',
        message: 'Image upload failed',
        error: uploadErr.message || uploadErr,
      });
    }
  }

  // Update the restaurant
  const updatedRestaurant = await Restaurant.findByIdAndUpdate(
    restaurantId,
    req.body,
    {
      new: true,
      runValidators: true,
    },
  );

  if (!updatedRestaurant) {
    console.log('Failed to update restaurant. Not found.');
    return next(new AppError('Restaurant not found with this ID.', 404));
  }

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

  console.log(`Deleting restaurant with ID: ${restaurantId}`);

  const restaurant = await Restaurant.findById(restaurantId);
  if (!restaurant) {
    console.log('Restaurant not found for deletion.');
    return next(new AppError('Restaurant not found with this ID.', 404));
  }

  await Restaurant.findByIdAndDelete(restaurantId);
  console.log('Restaurant deleted successfully.');

  res.status(204).json({
    status: 'success',
    data: null,
  });
});
