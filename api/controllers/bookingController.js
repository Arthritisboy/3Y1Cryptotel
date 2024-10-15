const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Restaurant = require('../models/Restaurant');
const Booking = require('../models/Booking');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const sendEmail = require('../utils/email');

// ** Get bookings by userId, hotelId, or restaurantId
exports.getBookings = catchAsync(async (req, res, next) => {
  try {
    const { userId } = req.params;

    // Attempt to find bookings by userId
    let bookings = await Booking.find({ userId: userId }).populate(
      'hotelId roomId restaurantId',
    );

    // If not found by userId, attempt to find by hotelId
    if (!bookings || bookings.length === 0) {
      bookings = await Booking.find({ hotelId: userId }).populate(
        'hotelId roomId restaurantId',
      );
    }

    // If not found by hotelId, attempt to find by restaurantId
    if (!bookings || bookings.length === 0) {
      bookings = await Booking.find({ restaurantId: userId }).populate(
        'hotelId roomId restaurantId',
      );
    }

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

// ** Create a new booking
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

    // Validate check-in and check-out dates
    const checkIn = new Date(checkInDate);
    const checkOut = new Date(checkOutDate);
    const now = new Date();

    console.log(`Current Time: ${now}`);
    console.log(`Check-in Date: ${checkIn}`);
    console.log(`Check-out Date: ${checkOut}`);

    // Ensure check-in date is not in the past
    if (checkIn < now) {
      console.log('Check-in date cannot be in the past.');
      return next(new AppError('Check-in date cannot be in the past.', 400));
    }

    // Ensure the check-in and check-out dates are at least 12 hours apart
    const hoursDifference = (checkIn - now) / (1000 * 60 * 60); // Convert ms to hours
    console.log(
      `Hours difference between now and check-in: ${hoursDifference}`,
    );

    if (hoursDifference < 12) {
      console.log(
        'Same-day bookings must be made at least 12 hours in advance.',
      );
      return next(
        new AppError(
          'Same-day bookings must be made at least 12 hours in advance.',
          400,
        ),
      );
    }

    // Ensure at least one adult is present
    const numAdults = parseInt(adult, 10) || 0;
    const numChildren = parseInt(children, 10) || 0;

    if (numAdults === 0) {
      console.log('At least one adult is required to make a booking.');
      return next(
        new AppError('At least one adult is required to make a booking.', 400),
      );
    }

    let totalPrice;
    let hotelName = '';
    let roomName = '';
    let restaurantName = '';

    if (bookingType === 'HotelBooking') {
      const room = await Room.findById(roomId);
      const hotel = await Hotel.findById(hotelId);

      if (!room || !hotel) {
        return next(new AppError('Room or Hotel not found.', 404));
      }

      hotelName = hotel.name;
      roomName = room.type;

      const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
      totalPrice = room.price * nights;

      room.availability = false;
      await room.save();
    } else if (bookingType === 'RestaurantBooking') {
      const restaurant = await Restaurant.findById(restaurantId);
      if (!restaurant) {
        return next(new AppError('Restaurant not found.', 404));
      }

      restaurantName = restaurant.name;

      const pricePerPerson = restaurant.pricePerPerson || 0;
      totalPrice = pricePerPerson * (numAdults + numChildren);
    }

    const newBooking = await Booking.create({
      userId,
      bookingType,
      hotelName,
      roomName,
      restaurantName,
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
      adult: numAdults,
      children: numChildren,
      totalPrice,
      status: 'pending',
    });

    await sendEmail({
      email: email,
      subject: 'Booking Confirmation - Your booking is being processed',
      type: 'booking',
      bookingDetails: {
        bookingType,
        fullName,
        hotelName,
        roomName,
        restaurantName,
        tableNumber,
        checkInDate,
        checkOutDate,
        totalPrice,
        status: 'pending',
      },
    });

    res.status(201).json({
      status: 'success',
      data: {
        booking: newBooking,
      },
    });
  } catch (error) {
    return next(
      new AppError('Error in creating booking. Please try again.', 500),
    );
  }
});

// ** Update an existing booking (e.g., change dates or status)
exports.updateBooking = catchAsync(async (req, res, next) => {
  try {
    const { bookingId } = req.params;

    const {
      checkInDate,
      checkOutDate,
      timeOfArrival,
      timeOfDeparture,
      status,
    } = req.body;

    // Find the booking and update the details
    const updatedBooking = await Booking.findByIdAndUpdate(
      bookingId,
      { checkInDate, checkOutDate, timeOfArrival, timeOfDeparture, status },
      { new: true, runValidators: true },
    );

    if (!updatedBooking) {
      return next(new AppError('Booking not found', 404));
    }

    // Send an email after successfully updating the booking
    await sendEmail({
      email: updatedBooking.email,
      subject: `Booking Status Updated - ${updatedBooking.status.toUpperCase()}`,
      type: 'booking',
      bookingDetails: {
        bookingType: updatedBooking.bookingType,
        fullName: updatedBooking.fullName,
        hotelName: updatedBooking.hotelName,
        roomName: updatedBooking.roomName,
        restaurantName: updatedBooking.restaurantName,
        tableNumber: updatedBooking.tableNumber,
        checkInDate: updatedBooking.checkInDate,
        checkOutDate: updatedBooking.checkOutDate,
        totalPrice: updatedBooking.totalPrice,
        status: updatedBooking.status,
      },
    });

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
