const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const mongoose = require('mongoose'); // Import mongoose for transactions

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
    managerConfirmPassword,
    managerGender,
  } = req.body;

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
    return next(new AppError('Hotel image is required.', 400));
  }

  let hotelImage;

  try {
    hotelImage = await uploadEveryImage(req, 'hotel');
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
    // 1. Create the hotel inside the transaction
    const newHotel = await Hotel.create(
      [
        {
          name,
          location,
          openingHours,
          walletAddress,
          hotelImage,
        },
      ],
      { session },
    );

    // 2. Register the manager linked to the hotel
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
      codeExpires: undefined,
      hasCompletedOnboarding: true,
      handleId: newHotel[0]._id, // Reference the created hotel ID
    };

    const newManager = await User.create([managerData], { session });
    console.log('Manager created:', newManager);

    // 3. Commit the transaction if everything succeeds
    await session.commitTransaction();
    session.endSession();

    // Send success response with hotel and manager info
    res.status(201).json({
      status: 'success',
      data: {
        hotel: newHotel[0],
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
        message = `A hotel with the name "${err.keyValue.name}" already exists. Please use a different name.`;
      } else if (err.keyPattern?.location) {
        message = `A hotel at the location "${err.keyValue.location}" already exists. Please use a different location.`;
      } else if (err.keyPattern?.email) {
        message = `A user with the email "${err.keyValue.email}" already exists. Please use a different email.`;
      } else if (err.keyPattern?.hotelImage) {
        message = `The image "${err.keyValue.hotelImage}" has already been used for another hotel. Please upload a different image.`;
      }

      return next(new AppError(message, 400));
    }

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
