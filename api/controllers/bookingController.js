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
        const userId = req.params.userId; // Assuming userId is now coming from params

        console.log("Received booking data:", {
            userId,
            hotelId,
            roomId,
            checkInDate,
            checkOutDate
        });

        // Validate checkInDate and checkOutDate
        const checkIn = new Date(checkInDate);
        const checkOut = new Date(checkOutDate);

        console.log("Parsed check-in date:", checkIn);
        console.log("Parsed check-out date:", checkOut);

        if (checkOut <= checkIn) {
            console.error("Check-out date is not after check-in date");
            return next(new AppError('Check-out date must be after check-in date', 400));
        }

        // Find the room and hotel
        const room = await Room.findById(roomId);
        const hotel = await Hotel.findById(hotelId);

        console.log("Found room:", room);
        console.log("Found hotel:", hotel);

        if (!room) {
            console.error("Room not found for roomId:", roomId);
            return next(new AppError('Room not found', 404));
        }
        if (!hotel) {
            console.error("Hotel not found for hotelId:", hotelId);
            return next(new AppError('Hotel not found', 404));
        }

        // Check if room price is valid
        console.log("Room price:", room.price);
        if (typeof room.price !== 'number' || room.price <= 0) {
            console.error("Invalid room price:", room.price);
            return next(new AppError('Invalid room price', 400));
        }

        // Calculate total price
        const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
        const totalPrice = room.price * nights;

        console.log("Number of nights:", nights);
        console.log("Calculated total price:", totalPrice);

        // Create a new booking with the calculated total price
        const newBooking = await Booking.create({
            userId,
            hotelId,
            roomId,
            checkInDate,
            checkOutDate,
            totalPrice
        });

        console.log("New booking created:", newBooking);

        res.status(201).json({
            status: 'success',
            data: {
                booking: newBooking
            }
        });
    } catch (error) {
        console.error("Booking creation error:", error);
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