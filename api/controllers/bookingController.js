const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Booking = require('../models/Booking');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get all bookings for a user
exports.getBookings = catchAsync(async (req, res, next) => {
    try {
        const bookings = await Booking.find({ user: req.user.id }).populate('hotel room');

        res.status(200).json({
            status: 'success',
            data: {
                bookings
            }
        });
    } catch (error) {
        return next(new AppError('Error in getting bookings. Please try again.', 500));
    }
});

// Create a new booking
exports.createBooking = catchAsync(async (req, res, next) => {
    try {
        const { hotelId, roomId, checkInDate, checkOutDate } = req.body;
        const userId = req.user.id;

        // Find the room and hotel
        const room = await Room.findById(roomId);
        const hotel = await Hotel.findById(hotelId);
        if (!room || !hotel) {
            return next(new AppError('Room or hotel not found', 404));
        }

        // Calculate total price (e.g., price per night * number of nights)
        const nights = (new Date(checkOutDate) - new Date(checkInDate)) / (1000 * 60 * 60 * 24);
        const totalPrice = room.price * nights;

        // Create a booking
        const newBooking = await Booking.create({
            user: userId,
            hotel: hotelId,
            room: roomId,
            checkInDate,
            checkOutDate,
            totalPrice
        });

        res.status(201).json({
            status: 'success',
            data: {
                newBooking
            }
        });
    } catch (error) {
        return next(new AppError('Error in creating booking. Please try again.', 500));
    }
});

// Update an existing booking (e.g., change dates)
exports.updateBooking = catchAsync(async (req, res, next) => {
    try {
        const { bookingId, checkInDate, checkOutDate } = req.body;

        // Find the booking and update the dates
        const updatedBooking = await Booking.findByIdAndUpdate(
            bookingId,
            { checkInDate, checkOutDate },
            { new: true, runValidators: true }
        );

        if (!updatedBooking) {
            return next(new AppError('Booking not found', 404));
        }

        res.status(200).json({
            status: 'success',
            data: {
                updatedBooking
            }
        });
    } catch (error) {
        return next(new AppError('Error in updating booking. Please try again.', 500));
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

        res.status(204).json({
            status: 'success',
            data: null
        });
    } catch (error) {
        return next(new AppError('Error in deleting booking. Please try again.', 500));
    }
});