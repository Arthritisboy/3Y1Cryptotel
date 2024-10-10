const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadEveryImage } = require('../middleware/imageUpload');
const { calculateAveragePrice } = require('../middleware/averageCalculator');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// // Helper function to calculate the average price
// const calculateAveragePrice = async (hotelId) => {
//     const hotel = await Hotel.findById(hotelId).populate('rooms');

//     if (!hotel || hotel.rooms.length === 0) {
//         hotel.averagePrice = 0; // No rooms, set average price to 0
//         await hotel.save();
//         return 0; 
//     }

//     const totalPrice = hotel.rooms.reduce((sum, room) => sum + room.price, 0);
//     const averagePrice = totalPrice / hotel.rooms.length;

//     hotel.averagePrice = averagePrice; // Update average price in hotel
//     await hotel.save(); // Save the hotel with the updated average price

//     return averagePrice; // Return the average price
// };

// Get a room by ID or all rooms
exports.getRoom = catchAsync(async(req, res, next) => {
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
exports.createRoom = catchAsync(async(req, res, next) => {
    const { roomNumber, type, price, capacity, ratingId } = req.body;
    const { hotelId } = req.params; // Get hotelId from the route parameters

    console.log('Creating room with data:', { roomNumber, type, price, capacity, ratingId, hotelId });

    let roomImage = undefined;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadEveryImage(req);
            console.log('Image uploaded successfully:', roomImage);
        } catch (uploadErr) {
            console.error('Image upload error:', uploadErr);
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    } else {
        console.log('No image file provided for the room.');
    }

    // Validate hotelId
    if (!hotelId) {
        console.log('Hotel ID is missing.');
        return next(new AppError('Hotel ID is required to create a room.', 400));
    }

    // Check if the hotel exists
    const hotel = await Hotel.findById(hotelId);
    if (!hotel) {
        console.log('No hotel found with the provided ID:', hotelId);
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    console.log('Found hotel:', hotel.name);

    // Create the room with multiple ratingIds (if provided, otherwise null)
    const newRoom = await Room.create({
        roomNumber,
        roomImage: roomImage || undefined, // Assign image if available
        type,
        price,
        capacity,
        ratings: ratingId && ratingId.length ? ratingId : [], // Assign multiple ratingIds or an empty array
    });

    console.log('New room created:', newRoom);

    // Add the new room to the hotel's room list
    hotel.rooms.push(newRoom._id);
    await hotel.save();
    console.log('Updated hotel with new room. Current rooms:', hotel.rooms);

    // Calculate and update the average price of the hotel
    const averagePrice = await calculateAveragePrice(hotelId);
    console.log('Updated average price for hotel:', hotel.averagePrice);

    // Respond with the new room data and the updated average price
    res.status(201).json({
        status: 'success',
        data: {
            room: newRoom,
            averagePrice: hotel.averagePrice, // Return the average price from the hotel instance
        },
    });

    console.log('Response sent with new room data and average price.');
});

// Update a room by ID
exports.updateRoom = catchAsync(async(req, res, next) => {
    const roomId = req.params.id;

    // Check if the room exists
    const room = await Room.findById(roomId);
    if (!room) {
        return next(new AppError('Room not found with this ID.', 404));
    }

    let roomImage = undefined;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadEveryImage(req);
            console.log('Room image updated:', roomImage);
            req.body.roomImage = roomImage; // Add image to update body
        } catch (uploadErr) {
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    }

    // Update the room
    const updatedRoom = await Room.findByIdAndUpdate(roomId, req.body, {
        new: true,
        runValidators: true,
    });

    if (!updatedRoom) {
        return next(new AppError('Room not found with this ID.', 404));
    }

    // Update the average price of the associated hotel
    const hotel = await Hotel.findById(room.hotel); // Fetch the associated hotel
    if (hotel) {
        const averagePrice = await calculateAveragePrice(hotel._id);
        hotel.averagePrice = averagePrice; // Update average price in the hotel
        await hotel.save();
        console.log('Updated hotel average price:', hotel.averagePrice);
    }

    res.status(200).json({
        status: 'success',
        data: {
            room: updatedRoom,
        },
    });
});

// Delete a room by ID
exports.deleteRoom = catchAsync(async(req, res, next) => {
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

    // Update average price for the hotel after room deletion
    if (hotel) {
        await calculateAveragePrice(hotel._id); // Recalculate average price
        console.log('Updated average price after room deletion:', hotel.averagePrice);
    }

    res.status(204).json({
        status: 'success',
        data: null,
    });
});