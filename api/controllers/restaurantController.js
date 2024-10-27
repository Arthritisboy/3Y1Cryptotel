const User = require('../models/User');
const Restaurant = require('../models/Restaurant');
const RestaurantRating = require('../models/RestaurantRating');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const mongoose = require('mongoose');

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
  const {
    name,
    location,
    price,
    openingHours,
    walletAddress,
    managerEmail,
    managerFirstName,
    managerLastName,
    managerPassword,
    managerPhoneNumber,
    managerConfirmPassword,
    managerGender,
    capacity,
  } = req.body;

  // Validate required fields
  if (
    !name ||
    !location ||
    !openingHours ||
    !managerEmail ||
    !managerPassword ||
    !managerConfirmPassword
  ) {
    return next(new AppError('Missing required fields.', 400));
  }

  if (!req.file) {
    return next(new AppError('Restaurant image is required.', 400));
  }

  let restaurantImage;

  try {
    restaurantImage = await uploadEveryImage(req, 'restaurant'); // Upload restaurant image
  } catch (uploadErr) {
    return res.status(500).json({
      status: 'error',
      message: 'Image upload failed',
      error: uploadErr.message || uploadErr,
    });
  }

  const session = await mongoose.startSession(); // Start a new session for the transaction
  session.startTransaction();

  try {
    // Convert capacity and price to integers
    const parsedCapacity = parseInt(capacity);
    const parsedPrice = parseInt(price);

    if (isNaN(parsedCapacity) || isNaN(parsedPrice)) {
      return next(
        new AppError('Capacity and price must be valid integers.', 400),
      );
    }

    // 1. Create the restaurant inside the transaction
    const newRestaurant = await Restaurant.create(
      [
        {
          name,
          location,
          openingHours,
          walletAddress,
          capacity: parsedCapacity,
          price: parsedPrice,
          restaurantImage,
        },
      ],
      { session },
    );

    // 2. Register the manager linked to the restaurant
    const managerData = {
      firstName: managerFirstName,
      lastName: managerLastName,
      email: managerEmail,
      password: managerPassword,
      confirmPassword: managerConfirmPassword,
      phoneNumber: managerPhoneNumber,
      gender: managerGender,
      roles: 'manager',
      verified: true,
      hasCompletedOnboarding: true,
      handleId: newRestaurant[0]._id, // Reference the restaurant ID
    };

    const newManager = await User.create([managerData], { session });
    console.log('Manager created:', newManager);

    // 3. Commit the transaction if everything succeeds
    await session.commitTransaction();
    session.endSession();

    // Send success response with restaurant and manager info
    res.status(201).json({
      status: 'success',
      data: {
        restaurant: newRestaurant[0],
        manager: newManager[0],
      },
    });
  } catch (err) {
    await session.abortTransaction(); // Rollback the transaction on error
    session.endSession();

    // Handle MongoDB duplicate key errors (E11000)
    if (err.code === 11000) {
      let message = 'Duplicate field error.';

      // Check which field caused the error
      if (err.keyPattern?.name) {
        message = `A restaurant with the name "${err.keyValue.name}" already exists. Please use a different name.`;
      } else if (err.keyPattern?.location) {
        message = `A restaurant at the location "${err.keyValue.location}" already exists. Please use a different location.`;
      } else if (err.keyPattern?.email) {
        message = `A user with the email "${err.keyValue.email}" already exists. Please use a different email.`;
      } else if (err.keyPattern?.restaurantImage) {
        message = `The image "${err.keyValue.restaurantImage}" has already been used for another restaurant. Please upload a different image.`;
      }

      return next(new AppError(message, 400));
    }

    console.error('Error creating manager or restaurant:', err);
    return next(new AppError('Failed to create manager or restaurant.', 500));
  }
});

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
      restaurantImage = await uploadEveryImage(req, 'restaurant');
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

  // Convert capacity and price to integers if provided
  if (req.body.capacity) {
    req.body.capacity = parseInt(req.body.capacity);
    if (isNaN(req.body.capacity)) {
      return next(new AppError('Capacity must be a valid integer.', 400));
    }
  }

  if (req.body.price) {
    req.body.price = parseInt(req.body.price);
    if (isNaN(req.body.price)) {
      return next(new AppError('Price must be a valid integer.', 400));
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
