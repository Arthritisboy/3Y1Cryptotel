const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Rating = require('../models/Rating');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Helper function to find the hotel by room ID
const findHotelByRoomId = async (roomId) => {
    const room = await Room.findById(roomId);
    if (!room) {
        throw new AppError('Room not found', 404);
    }
    const hotel = await Hotel.findOne({ rooms: room._id });
    if (!hotel) {
        throw new AppError('No hotel found for this room ID.', 404);
    }
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

exports.createRating = catchAsync(async (req, res, next) => {
    const { rating, message, userId } = req.body;
    const { roomId } = req.params;

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

    // Find the hotel that contains this room
    const hotel = await findHotelByRoomId(roomId);

    console.log('Hotel found:', hotel);

    // Update hotel average rating manually
    let totalRating = 0;
    let totalReviews = 0;

    // Populate all rooms within the hotel
    await hotel.populate({
        path: 'rooms',
        populate: {
            path: 'ratings', // Populate ratings for each room
        }
    });

    console.log('Populated hotel with rooms:', hotel.rooms);

    // Calculate the total ratings and reviews
    for (const room of hotel.rooms) {
        const roomRatings = room.ratings;
        roomRatings.forEach((rating) => {
            totalRating += rating.rating;
            totalReviews++;
        });
    }

    // Update hotel's average rating
    hotel.averageRating = totalReviews > 0 ? totalRating / totalReviews : 0; // Avoid division by zero
    await hotel.save();

    // Log the updated average rating
    console.log('Updated hotel average rating:', hotel.averageRating);

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

    const updatedRating = await Rating.findByIdAndUpdate(req.params.id, { rating, message }, { new: true, runValidators: true });

    if (!updatedRating) {
        return next(new AppError('Rating not found', 404));
    }

    // Update hotel average rating manually
    const hotel = await findHotelByRoomId(updatedRating.roomId); // Use the helper function

    let totalRating = 0;
    let totalReviews = 0;

    await hotel.populate('rooms'); // Populate rooms in the hotel

    for (const room of hotel.rooms) {
        await room.populate('ratings');  // Populate the ratings for each room
        const roomRatings = room.ratings;

        roomRatings.forEach((rating) => {
            totalRating += rating.rating;
            totalReviews++;
        });
    }

    hotel.averageRating = totalReviews > 0 ? totalRating / totalReviews : 0; // Avoid division by zero
    await hotel.save();

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

    // Find the hotel that contains this room
    const hotel = await findHotelByRoomId(rating.roomId); // Use the helper function

    // Recalculate the hotel's average rating
    let totalRating = 0;
    let totalReviews = 0;

    // Populate all rooms within the hotel
    await hotel.populate({
        path: 'rooms',
        populate: {
            path: 'ratings', // Populate ratings for each room
        }
    });

    console.log('Populated hotel with rooms:', hotel.rooms);

    // Calculate the total ratings and reviews
    for (const room of hotel.rooms) {
        const roomRatings = room.ratings;
        roomRatings.forEach((rating) => {
            totalRating += rating.rating;
            totalReviews++;
        });
    }

    // Update hotel's average rating
    hotel.averageRating = totalReviews > 0 ? totalRating / totalReviews : 0; // Avoid division by zero
    await hotel.save();

    res.status(204).json({
        status: 'success',
        data: null,
    });

    // Log final success response
    console.log('Rating deletion successful. Hotel average rating updated:', hotel.averageRating);
});
