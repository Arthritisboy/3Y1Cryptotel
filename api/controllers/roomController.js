const chalk = require('chalk'); // Import chalk for logging
const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Helper function to calculate and update the average price of a hotel
const calculateAveragePrice = async (hotelId) => {
    console.log(chalk.blue('Calculating average price for hotel ID:', hotelId));
    const hotel = await Hotel.findById(hotelId).populate('rooms');

    if (!hotel) {
        console.log(chalk.red('Error: No hotel found.'));
        throw new AppError('No hotel found.', 404);
    }

    if (hotel.rooms.length === 0) {
        hotel.averagePrice = 0; // No rooms, set average price to 0
    } else {
        const totalPrice = hotel.rooms.reduce((sum, room) => sum + room.price, 0);
        hotel.averagePrice = parseFloat((totalPrice / hotel.rooms.length).toFixed(1)); // One decimal
    }

    await hotel.save(); // Save the hotel with the updated average price
    console.log(chalk.green('Updated average price for hotel:', hotel.averagePrice));
    return hotel.averagePrice; // Return the average price
};

// Get a room by ID or all rooms
exports.getRoom = catchAsync(async (req, res, next) => {
    const roomId = req.params.id;
    let room;

    if (roomId) {
        console.log(chalk.yellow('Fetching room with ID:', roomId));
        room = await Room.findById(roomId).populate('ratings');
        if (!room) {
            console.log(chalk.red('Error: Room not found.'));
            return next(new AppError('Room not found with this ID.', 404));
        }
        console.log(chalk.green('Room found:', room));
    } else {
        console.log(chalk.yellow('Fetching all rooms.'));
        room = await Room.find(); // Get all rooms if no ID is provided
    }

    res.status(200).json({
        status: 'success',
        data: {
            room: roomId ? room : room, // Adjust for consistency
        },
    });
});

// Create a room
exports.createRoom = catchAsync(async (req, res, next) => {
    const { roomNumber, type, price, capacity, ratingId } = req.body;
    const { hotelId } = req.params; // Get hotelId from the route parameters

    console.log(chalk.blue('Creating room with data:', { roomNumber, type, price, capacity, ratingId, hotelId }));

    let roomImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadEveryImage(req);
            console.log(chalk.green('Image uploaded successfully:', roomImage));
        } catch (uploadErr) {
            console.error(chalk.red('Image upload error:', uploadErr));
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    }

    // Validate hotelId
    if (!hotelId) {
        console.log(chalk.red('Error: Hotel ID is required to create a room.'));
        return next(new AppError('Hotel ID is required to create a room.', 400));
    }

    // Check if the hotel exists
    const hotel = await Hotel.findById(hotelId);
    if (!hotel) {
        console.log(chalk.red('Error: No hotel found with the provided ID:', hotelId));
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    console.log(chalk.green('Found hotel:', hotel.name));

    // Create the room with multiple ratingIds (if provided, otherwise an empty array)
    const newRoom = await Room.create({
        roomNumber,
        roomImage: roomImage || undefined, // Assign image if available
        type,
        price,
        capacity,
        ratings: ratingId && ratingId.length ? ratingId : [], // Assign multiple ratingIds or an empty array
    });

    console.log(chalk.green('New room created:', newRoom));

    // Add the new room to the hotel's room list
    hotel.rooms.push(newRoom._id);
    await hotel.save();
    console.log(chalk.green('Updated hotel with new room. Current rooms:', hotel.rooms));

    // Calculate and update the average price of the hotel
    const averagePrice = await calculateAveragePrice(hotelId); // Uncomment to recalculate average price
    console.log(chalk.green('Updated average price for hotel:', averagePrice));

    // Respond with the new room data and the updated average price
    res.status(201).json({
        status: 'success',
        data: {
            room: newRoom,
            averagePrice, // Return the newly calculated average price
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
        console.log(chalk.red('Error: Room not found with this ID.'));
        return next(new AppError('Room not found with this ID.', 404));
    }

    let roomImage;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            roomImage = await uploadEveryImage(req);
            console.log(chalk.green('Room image updated:', roomImage));
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
        console.log(chalk.red('Error: Room not found with this ID.'));
        return next(new AppError('Room not found with this ID.', 404));
    }

    // Update the average price of the associated hotel
    const hotel = await Hotel.findOne({ rooms: roomId }); // Fetch the associated hotel
    if (hotel) {
        const averagePrice = await calculateAveragePrice(hotel._id);
        hotel.averagePrice = averagePrice; // Update average price in the hotel
        await hotel.save();
        console.log(chalk.green('Updated hotel average price:', hotel.averagePrice));
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
        console.log(chalk.red('Error: Room not found with this ID.'));
        return next(new AppError('Room not found with this ID.', 404));
    }

    // Remove room from hotel rooms array
    const hotel = await Hotel.findOne({ rooms: roomId });
    if (hotel) {
        hotel.rooms.pull(roomId);
        await hotel.save();
        console.log(chalk.green('Removed room from hotel:', hotel.name));
    }

    await Room.findByIdAndDelete(roomId);
    console.log(chalk.green('Deleted room with ID:', roomId));

    // Update average price for the hotel after room deletion
    if (hotel) {
        await calculateAveragePrice(hotel._id); // Recalculate average price
        console.log(chalk.green('Updated average price after room deletion:', hotel.averagePrice));
    }

    res.status(204).json({
        status: 'success',
        data: null,
    });
});
