const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Restaurant = require('../models/Restaurant');
const Booking = require('../models/Booking');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const sendEmail = require('../utils/email');

// Get all bookings for a user
exports.getBookings = catchAsync(async (req, res, next) => {
  try {
    const bookings = await Booking.find({ userId: req.params.userId }).populate(
      'hotelId roomId restaurantId',
    );

    res.status(200).json({
      status: 'success',
      data: {
        bookings,
      },
    });
  } catch (error) {
    return next(
      new AppError('Error in getting bookings. Please try again.', 500),
    );
  }
});

// Create a new booking
exports.createBooking = catchAsync(async (req, res, next) => {
  try {
    console.log('Booking request body:', req.body);
    console.log('User ID from params:', req.params.userId);

    const {
      bookingType,
      hotelId,
      roomId,
      restaurantId,
      checkInDate,
      checkOutDate,
      tableNumber,
      fullName,
      email,
      phoneNumber,
      address,
      adult,
      children,
      timeOfArrival,
      timeOfDeparture,
    } = req.body;

    const userId = req.params.userId;

    // Validate checkInDate and checkOutDate
    const checkIn = new Date(checkInDate);
    const checkOut = new Date(checkOutDate);

    if (checkOut <= checkIn) {
      console.log('Check-out date must be after check-in date');
      return next(
        new AppError('Check-out date must be after check-in date', 400),
      );
    }

    let totalPrice;

    if (bookingType === 'HotelBooking') {
      const room = await Room.findById(roomId);
      const hotel = await Hotel.findById(hotelId);

      if (!room || !hotel) {
        console.log('Room or Hotel not found');
        return next(new AppError('Room or Hotel not found', 404));
      }

      const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
      totalPrice = room.price * nights;

      // Set room availability to false
      room.availability = false;
      await room.save();
    } else if (bookingType === 'RestaurantBooking') {
      const restaurant = await Restaurant.findById(restaurantId);
      if (!restaurant) {
        console.log('Restaurant not found');
        return next(new AppError('Restaurant not found', 404));
      }

      const existingBooking = await Booking.findOne({
        restaurantId,
        tableNumber,
        checkInDate: { $lte: checkOut },
        checkOutDate: { $gte: checkIn },
      });

      if (existingBooking) {
        console.log('Table number is already booked for the selected time.');
        return next(
          new AppError(
            'Table number is already booked for the selected time.',
            400,
          ),
        );
      }

      const currentBookingsCount = await Booking.countDocuments({
        restaurantId,
        checkInDate: { $lte: checkOut },
        checkOutDate: { $gte: checkIn },
      });

      if (currentBookingsCount >= restaurant.capacity) {
        console.log('The restaurant is fully booked for the selected time.');
        return next(
          new AppError(
            'The restaurant is fully booked for the selected time.',
            400,
          ),
        );
      }

      const pricePerPerson = restaurant.pricePerPerson;
      totalPrice = pricePerPerson * (adult + children);
    } else {
      console.log('Invalid booking type');
      return next(new AppError('Invalid booking type', 400));
    }

    // Create a new booking
    const newBooking = await Booking.create({
      userId,
      bookingType,
      hotelId,
      roomId,
      restaurantId,
      fullName,
      email,
      phoneNumber,
      address,
      tableNumber,
      checkInDate,
      checkOutDate,
      timeOfArrival,
      timeOfDeparture,
      adult,
      children,
      totalPrice,
    });

    console.log('Booking created successfully:', newBooking);

    // Send email to the user after the booking is created
    await sendEmail({
      email: email, // User's email address
      subject: 'Booking Confirmation - Your booking is being processed',
      type: 'booking', // Define this in the email utility
      bookingDetails: {
        fullName,
        hotelId,
        roomId,
        checkInDate,
        checkOutDate,
        totalPrice,
      },
    });

    res.status(201).json({
      status: 'success',
      data: {
        booking: newBooking,
      },
    });
  } catch (error) {
    console.error('Booking creation error:', error);
    return next(
      new AppError('Error in creating booking. Please try again.', 500),
    );
  }
});

// Update an existing booking (e.g., change dates)
exports.updateBooking = catchAsync(async (req, res, next) => {
  try {
    const {
      bookingId,
      checkInDate,
      checkOutDate,
      timeOfArrival,
      timeOfDeparture,
    } = req.body;

    // Find the booking and update the details
    const updatedBooking = await Booking.findByIdAndUpdate(
      bookingId,
      { checkInDate, checkOutDate, timeOfArrival, timeOfDeparture },
      { new: true, runValidators: true },
    );

    if (!updatedBooking) {
      return next(new AppError('Booking not found', 404));
    }

    res.status(200).json({
      status: 'success',
      data: {
        updatedBooking,
      },
    });
  } catch (error) {
    return next(
      new AppError('Error in updating booking. Please try again.', 500),
    );
  }
});

// Delete a booking
exports.deleteBooking = catchAsync(async (req, res, next) => {
  try {
    const { bookingId } = req.params;

    // Find and delete the booking
    const deletedBooking = await Booking.findByIdAndDelete(bookingId);

    if (!deletedBooking) {
      return next(new AppError('Booking not found', 404));
    }

    // Update availability based on booking type
    if (deletedBooking.bookingType === 'HotelBooking') {
      if (deletedBooking.roomId) {
        const room = await Room.findById(deletedBooking.roomId);
        if (room) {
          room.availability = true;
          await room.save();
        }
      }
    } else if (deletedBooking.bookingType === 'RestaurantBooking') {
      if (deletedBooking.restaurantId) {
        const restaurant = await Restaurant.findById(
          deletedBooking.restaurantId,
        );
        if (restaurant) {
          restaurant.availability = true;
          await restaurant.save();
        }
      }
    }

    res.status(204).json({
      status: 'success',
      data: null,
    });
  } catch (error) {
    return next(
      new AppError('Error in deleting booking. Please try again.', 500),
    );
  }
});
