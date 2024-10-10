const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a hotel by ID or all hotels (with rooms)
exports.getHotel = catchAsync(async(req, res, next) => {
    const hotelId = req.params.id;
    let hotel;

    if (hotelId) {
        hotel = await Hotel.findById(hotelId).populate({
            path: 'rooms',
            populate: {
                path: 'ratings',
            },
        });
        if (!hotel) {
            return next(new AppError('Hotel not found with this ID.', 404));
        }
    } else {
        hotel = await Hotel.find().populate({
            path: 'rooms',
            populate: {
                path: 'ratings',
            },
        }); // Get all hotels if no ID is provided
    }

    res.status(200).json({
        status: 'success',
        data: {
            hotel,
        },
    });
});

// Create a hotel with optional rooms
exports.createHotel = catchAsync(async(req, res, next) => {
    const { name, location, openingHours, rooms } = req.body;

    let hotelImage = undefined;

    // Handle image upload if a file is provided
    if (req.file) {
        try {
            hotelImage = await uploadEveryImage(req);
        } catch (uploadErr) {
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    }

    if (!name || !location || !openingHours) {
        return next(new AppError('Name, location, and opening hours are required.', 400));
    }

    // Create new hotel
    const newHotel = await Hotel.create({
        name,
        location,
        openingHours,
        hotelImage: hotelImage || undefined,
    });

    // If rooms are provided and not empty, create them and associate them with the hotel
    if (rooms && rooms.length > 0) {
        const roomDocs = await Room.insertMany(
            rooms.map(room => ({
                ...room,
                hotel: newHotel._id,
            }))
        );

        // Add room IDs to the hotel's rooms field
        newHotel.rooms.push(...roomDocs.map(room => room._id));
        await newHotel.save();
    }

    res.status(201).json({
        status: 'success',
        data: {
            hotel: newHotel,
        },
    });
});

// Update a hotel and optionally its rooms
exports.updateHotel = catchAsync(async(req, res, next) => {
    const hotelId = req.params.id;
    let updateData = {...req.body };
    const { rooms } = req.body;

    // Handle image upload if a file is provided during update
    if (req.file) {
        try {
            const hotelImage = await uploadEveryImage(req);
            updateData.hotelImage = hotelImage;
        } catch (uploadErr) {
            return res.status(500).json({
                status: 'error',
                message: 'Image upload failed',
                error: uploadErr.message || uploadErr,
            });
        }
    }

    const updatedHotel = await Hotel.findByIdAndUpdate(hotelId, updateData, {
        new: true,
        runValidators: true,
    });

    if (!updatedHotel) {
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    // If rooms are provided and not empty, update/create rooms associated with the hotel
    if (rooms && rooms.length > 0) {
        // Delete existing rooms associated with this hotel
        await Room.deleteMany({ hotel: hotelId });

        // Insert new rooms and associate them with the hotel
        const roomDocs = await Room.insertMany(
            rooms.map(room => ({
                ...room,
                hotel: updatedHotel._id,
            }))
        );

        // Update hotel's rooms array
        updatedHotel.rooms = roomDocs.map(room => room._id);
        await updatedHotel.save();
    }

    res.status(200).json({
        status: 'success',
        data: {
            hotel: updatedHotel,
        },
    });
});

// Delete a hotel by ID
exports.deleteHotel = catchAsync(async(req, res, next) => {
    const hotelId = req.params.id;

    const hotel = await Hotel.findById(hotelId);
    if (!hotel) {
        return next(new AppError('Hotel not found with this ID.', 404));
    }

    // Delete rooms related to this hotel
    await Room.deleteMany({ _id: { $in: hotel.rooms } });

    await Hotel.findByIdAndDelete(hotelId);

    res.status(204).json({
        status: 'success',
        data: null,
    });
});