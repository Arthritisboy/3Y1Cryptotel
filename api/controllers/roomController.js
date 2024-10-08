const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadHotelRoomImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const chalk = require('chalk'); // Import chalk for colored logging

// Function to calculate the average price of the rooms in a hotel
const calculateAveragePrice = async (hotelId) => {
    const hotel = await Hotel.findById(hotelId).populate('rooms');
    if (!hotel) {
        throw new AppError('Hotel not found with this ID.', 404);
    }

    if (hotel.rooms.length === 0) {
        hotel.averagePrice = 0.0; // Set to 0 if no rooms are available
        console.log(chalk.yellow(`No rooms found for hotel ID ${hotelId}. Average price set to 0.0.`));
    } else {
        const totalPrice = hotel.rooms.reduce((sum, room) => sum + room.price, 0);
        hotel.averagePrice = parseFloat((totalPrice / hotel.rooms.length).toFixed(1)); // Round to 1 decimal place
        console.log(chalk.blue(`Calculated average price for hotel ID ${hotelId}: ${hotel.averagePrice}`));
    }

    await hotel.save(); // Save the updated average price in the hotel
};

// Get a room by ID or all rooms
exports.getRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;
    let room;

    if (roomId) {
        room = await Room.findById(roomId).populate('ratings');
        if (!room) {
            return next(new AppError('Room not found with this ID.', 404));
        }
        console.log(chalk.blue(`Retrieved room details: ${room}`));
    } else {
        room = await Room.find(); // Get all rooms if no ID is provided
        console.log(chalk.blue(`Retrieved all rooms: ${room.length} rooms found.`));
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

    console.log(chalk.green('Creating room with data:'), { roomNumber, type, price, capacity, ratingId, hotelId });

    let roomImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadHotelRoomImage(req);
            console.log(chalk.green('Image uploaded successfully:'), roomImage);
        } catch (uploadErr) {
            console.error(chalk.red('Image upload error:'), uploadErr);
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    } else {
        console.log(chalk.yellow('No image file provided for the room.'));
    }

    // Validate hotelId
    if (!hotelId) {
        console.log(chalk.red('Hotel ID is missing.'));
        return next(new AppError('Hotel ID is required to create a room.', 400));
    }

    // Check if the hotel exists
    const hotel = await Hotel.findById(hotelId);
    if (!hotel) {
        console.log(chalk.red(`No hotel found with the provided ID: ${hotelId}`));
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    console.log(chalk.green('Found hotel:'), hotel.name);

    // Create the room with multiple ratingIds (if provided, otherwise null)
    const newRoom = await Room.create({
        roomNumber,
        roomImage: roomImage || undefined, // Assign image if available
        type,
        price,
        capacity,
        ratings: ratingId && ratingId.length ? ratingId : [], // Assign multiple ratingIds or an empty array
    });

    console.log(chalk.green('New room created:'), newRoom);

    // Add the new room to the hotel's room list
    hotel.rooms.push(newRoom._id);
    await hotel.save();
    console.log(chalk.green('Updated hotel with new room. Current rooms:'), hotel.rooms);

    // Calculate and update the average price for the hotel
    await calculateAveragePrice(hotelId);

    // Respond with the new room data and the updated average price
    res.status(201).json({
        status: 'success',
        data: {
            room: newRoom,
            averagePrice: hotel.averagePrice, // Return the average price from the hotel instance
        },
    });

    console.log(chalk.green('Response sent with new room data and average price.'));
});

// Update a room by ID
exports.updateRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;

    // Check if the room exists
    const room = await Room.findById(roomId);
    if (!room) {
        return next(new AppError('Room not found with this ID.', 404));
    }

    console.log(chalk.blue(`Updating room with ID ${roomId}. Current details: ${room}`));

    let roomImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadHotelRoomImage(req);
            console.log(chalk.green('Room image updated:'), roomImage);
            req.body.roomImage = roomImage; // Add image to update body
        } catch (uploadErr) {
            console.error(chalk.red('Image upload error:'), uploadErr);
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

    console.log(chalk.green(`Room updated successfully:`), updatedRoom);

    // Automatically call the calculateAveragePrice function after updating
    await calculateAveragePrice(updatedRoom.hotel); // Use the hotel's ID to recalculate average price

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

    console.log(chalk.red(`Deleting room with ID ${roomId}. Room details: ${room}`));

    // Remove room from hotel rooms array
    const hotel = await Hotel.findOne({ rooms: roomId });
    if (hotel) {
        hotel.rooms.pull(roomId);
        await hotel.save();
        console.log(chalk.green(`Removed room from hotel ID ${hotel._id}. Current rooms:`), hotel.rooms);
    }

    await Room.findByIdAndDelete(roomId);

    // Automatically call the calculateAveragePrice function after room deletion
    if (hotel) {
        await calculateAveragePrice(hotel._id); // Recalculate average price
        console.log(chalk.blue('Updated average price after room deletion:'), hotel.averagePrice);
    }

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
