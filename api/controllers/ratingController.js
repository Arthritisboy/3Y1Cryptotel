const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Rating = require('../models/Rating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Helper function to calculate and update the average rating of a hotel
const calculateAverageRating = async (roomId) => {
  // Find the hotel associated with the room
  const hotel = await Hotel.findOne({ rooms: roomId }).populate({
    path: 'rooms',
    populate: {
      path: 'ratings', // Populate ratings for each room
    },
  });

  if (!hotel) {
    throw new AppError('No hotel found for this room.', 404);
  }

  // Calculate the total ratings and reviews
  let totalRating = 0;
  let totalReviews = 0;

  hotel.rooms.forEach((room) => {
    room.ratings.forEach((rating) => {
      totalRating += rating.rating;
      totalReviews++;
    });
  });

  // Log the average rating before update
  console.log('Average rating before update:', hotel.averageRating);

  // Update hotel's average rating
  hotel.averageRating =
    totalReviews > 0 ? parseFloat((totalRating / totalReviews).toFixed(1)) : 0;
  await hotel.save();

  // Log the average rating after update
  console.log('Average rating after update:', hotel.averageRating);

  return hotel;
};

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
  const { roomId } = req.params;
  console.log('ROOM');
  // Log received data
  console.log('Received rating data:', { rating, message, roomId });
  console.log('User ID:', userId);

  // Validate roomId
  if (!roomId) {
    console.log('Room ID missing in request');
    return next(new AppError('Room ID is required to create a rating.', 400));
  }

  // Check if the room exists
  const room = await Room.findById(roomId);
  if (!room) {
    console.log('Room not found with ID:', roomId);
    return next(new AppError('Room not found with this ID.', 404));
  }

  // Log that room exists
  console.log('Room found:', room);

  // Create the rating
  const newRating = await Rating.create({
    rating,
    message,
    userId,
    roomId,
  });

  // Log that the rating was created
  console.log('New rating created:', newRating);

  // Push the new rating ID into the Room's ratings array
  room.ratings.push(newRating._id);
  await room.save();

  // Log that the room was updated with the new rating
  console.log('Room updated with new rating:', room);

  // Update hotel's average rating using the helper function
  await calculateAverageRating(roomId);

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

  const updatedRating = await Rating.findByIdAndUpdate(
    req.params.id,
    { rating, message },
    { new: true, runValidators: true },
  );

  if (!updatedRating) {
    return next(new AppError('Rating not found', 404));
  }

  // Update hotel's average rating using the helper function
  await calculateAverageRating(updatedRating.roomId);

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

  // Log that the rating was deleted
  console.log('Deleted rating:', rating);

  // Optional: Remove the rating ID from the Room's ratings array
  await Room.findByIdAndUpdate(rating.roomId, {
    $pull: { ratings: rating._id },
  });

  // Recalculate hotel's average rating using the helper function
  await calculateAverageRating(rating.roomId);

  res.status(204).json({
    status: 'success',
    data: null,
  });

  // Log final success response
  console.log('Rating deletion successful.');
});
