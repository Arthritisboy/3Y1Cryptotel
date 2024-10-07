const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadHotelRoomImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a room by ID or all rooms
exports.getRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;
    let room;

    if (roomId) {
        room = await Room.findById(roomId).populate('ratings');
        if (!room) {
            return next(new AppError('Room not found with this ID.', 404));
        }
    } else {
        room = await Room.find(); // Get all rooms if no ID is provided
    }

    res.status(200).json({
        status: 'success',
        data: {
            room,
        },
    });
});

// Create a room
exports.createRoom = catchAsync(async (req, res, next) => {
    const { roomNumber, type, price, capacity, ratingId } = req.body;
    const { hotelId } = req.params; // Get hotelId from the route parameters

    let roomImage = undefined;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadHotelRoomImage(req);
        } catch (uploadErr) {
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr
            });
        }
    }

    // Validate hotelId
    if (!hotelId) {
        return next(new AppError('Hotel ID is required to create a room.', 400));
    }

    // Check if the hotel exists
    const hotel = await Hotel.findById(hotelId);
    if (!hotel) {
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    // Create the room with multiple ratingIds (if provided, otherwise null)
    const newRoom = await Room.create({
        roomNumber,
        roomImage: roomImage || undefined, // Assign image if available
        type,
        price,
        capacity,
        ratings: ratingId && ratingId.length ? ratingId : [] // Assign multiple ratingIds or an empty array
    });

    // Add the new room to the hotel's room list
    hotel.rooms.push(newRoom._id);
    await hotel.save();

    // Respond with the new room data
    res.status(201).json({
        status: 'success',
        data: {
            room: newRoom,
        },
    });
});


// Update a room by ID
exports.updateRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;
    const updatedRoom = await Room.findByIdAndUpdate(roomId, req.body, {
        new: true,
        runValidators: true,
    });

    if (!updatedRoom) {
        return next(new AppError('Room not found with this ID.', 404));
    }

    res.status(200).json({
        status: 'success',
        data: {
            room: updatedRoom,
        },
    });
});

// Delete a room by ID
exports.deleteRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;

    const room = await Room.findById(roomId);
    if (!room) {
        return next(new AppError('Room not found with this ID.', 404));
    }

    // Remove room from hotel rooms array
    const hotel = await Hotel.findOne({ rooms: roomId });
    if (hotel) {
        hotel.rooms.pull(roomId);
        await hotel.save();
    }

    await Room.findByIdAndDelete(roomId);

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
