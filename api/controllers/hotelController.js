const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get a hotel by ID or all hotels (with rooms)
exports.getHotel = catchAsync(async (req, res, next) => {
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

// Create a hotel with manager registration
exports.createHotel = catchAsync(async (req, res, next) => {
  const {
    name,
    location,
    openingHours,
    walletAddress,
    managerEmail,
    managerFirstName,
    managerLastName,
    managerPassword,
    managerPhoneNumber,
    managerGender,
  } = req.body;

  // Ensure required fields are provided
  if (
    !name ||
    !location ||
    !openingHours ||
    !managerEmail ||
    !managerPassword
  ) {
    return next(new AppError('Missing required fields.', 400));
  }

  // Check if an image is provided
  if (!req.file) {
    return next(new AppError('Hotel image is required.', 400));
  }

  let hotelImage;

  // Handle hotel image upload
  try {
    hotelImage = await uploadEveryImage(req);
  } catch (uploadErr) {
    return res.status(500).json({
      status: 'error',
      message: 'Image upload failed',
      error: uploadErr.message || uploadErr,
    });
  }

  try {
    // 1. Create the hotel
    const newHotel = await Hotel.create({
      name,
      location,
      openingHours,
      walletAddress,
      hotelImage, // Hotel image is now required
    });

    // 2. Register the manager
    const managerData = {
      firstName: managerFirstName,
      lastName: managerLastName,
      email: managerEmail,
      password: managerPassword,
      phoneNumber: managerPhoneNumber,
      gender: managerGender,
      roles: 'manager', // Assign manager role
      verified: true, // Automatically verify manager
      hasCompletedOnboarding: true,
      handleId: newHotel._id, // Assign the hotel ID to manager's handleId
    };

    const newManager = await User.create(managerData);
    console.log('Manager created:', newManager);

    // 3. Send success response with hotel and manager info
    res.status(201).json({
      status: 'success',
      data: {
        hotel: newHotel,
        manager: newManager,
      },
    });
  } catch (err) {
    console.error('Error creating manager or hotel:', err);
    return next(new AppError('Failed to create manager or hotel.', 500));
  }
});

// Update a hotel and optionally its rooms
exports.updateHotel = catchAsync(async (req, res, next) => {
  const hotelId = req.params.id;
  const updateData = { ...req.body };
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

  // Find the hotel by its ID
  const updatedHotel = await Hotel.findByIdAndUpdate(hotelId, updateData, {
    new: true,
    runValidators: true,
  });

  if (!updatedHotel) {
    return next(new AppError('Hotel not found with this ID.', 404));
  }

  // If rooms are provided and not empty, handle updating or creating rooms
  if (rooms && rooms.length > 0) {
    const existingRoomIds = updatedHotel.rooms.map((room) => room.toString());

    // Update or create new rooms based on provided room data
    for (const room of rooms) {
      if (room._id) {
        // If the room already exists, update it
        if (existingRoomIds.includes(room._id)) {
          await Room.findByIdAndUpdate(room._id, room, { new: true });
        }
      } else {
        // If the room does not exist, create it and add to hotel
        const newRoom = await Room.create({ ...room, hotel: hotelId });
        updatedHotel.rooms.push(newRoom._id);
      }
    }

    // Remove any rooms that are no longer in the updated room list
    const updatedRoomIds = rooms.map((room) => room._id).filter((id) => id); // Filter out new rooms without _id
    const roomsToRemove = existingRoomIds.filter(
      (id) => !updatedRoomIds.includes(id),
    );

    if (roomsToRemove.length > 0) {
      await Room.deleteMany({ _id: { $in: roomsToRemove } });
      updatedHotel.rooms = updatedHotel.rooms.filter(
        (roomId) => !roomsToRemove.includes(roomId.toString()),
      );
    }

    // Save the updated hotel after room changes
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
exports.deleteHotel = catchAsync(async (req, res, next) => {
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
