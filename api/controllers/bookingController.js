const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Restaurant = require('../models/Restaurant');
const Booking = require('../models/Booking');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

// Get all bookings for a user
exports.getBookings = catchAsync(async(req, res, next) => {
    try {
        const bookings = await Booking.find({ userId: req.params.userId }).populate('hotelId roomId restaurantId');

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
exports.createBooking = catchAsync(async(req, res, next) => {
    try {
        const { bookingType, hotelId, roomId, restaurantId, checkInDate, checkOutDate } = req.body;
        const userId = req.params.userId; // Getting userId from params

        console.log("Received booking data:", {
            userId,
            bookingType,
            hotelId,
            roomId,
            restaurantId,
            checkInDate,
            checkOutDate
        });

        // Validate checkInDate and checkOutDate
        const checkIn = new Date(checkInDate);
        const checkOut = new Date(checkOutDate);

        if (checkOut <= checkIn) {
            return next(new AppError('Check-out date must be after check-in date', 400));
        }

        let totalPrice;

        // Check booking type and find the corresponding hotel and room or restaurant
        if (bookingType === 'HotelBooking') {
            const room = await Room.findById(roomId);
            const hotel = await Hotel.findById(hotelId);

            if (!room || !hotel) {
                return next(new AppError('Room or Hotel not found', 404));
            }

            // Calculate total price for hotel booking
            if (typeof room.price !== 'number' || room.price <= 0) {
                return next(new AppError('Invalid room price', 400));
            }
            const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
            totalPrice = room.price * nights;

            // Set room availability to false
            room.availability = false;
            await room.save(); // Save the updated room status

        } else if (bookingType === 'RestaurantBooking') {
            const restaurant = await Restaurant.findById(restaurantId);

            if (!restaurant) {
                return next(new AppError('Restaurant not found', 404));
            }

            // Example static price for restaurant booking
            totalPrice = 50;

            // Set restaurant availability to false
            restaurant.availability = false;
            await restaurant.save(); // Save the updated restaurant status

        } else {
            return next(new AppError('Invalid booking type', 400));
        }

        // Create a new booking
        const newBooking = await Booking.create({
            userId,
            bookingType,
            hotelId,
            roomId,
            restaurantId,
            checkInDate,
            checkOutDate,
            totalPrice
        });

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
exports.updateBooking = catchAsync(async(req, res, next) => {
    try {
        const { bookingId, checkInDate, checkOutDate } = req.body;

        // Find the booking and update the dates
        const updatedBooking = await Booking.findByIdAndUpdate(
            bookingId, { checkInDate, checkOutDate }, { new: true, runValidators: true }
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
exports.deleteBooking = catchAsync(async(req, res, next) => {
    try {
        const { bookingId } = req.params;

        // Find and delete the booking
        const deletedBooking = await Booking.findByIdAndDelete(bookingId);

        if (!deletedBooking) {
            return next(new AppError('Booking not found', 404));
        }

        // Update availability based on booking type
        if (deletedBooking.bookingType === 'HotelBooking') {
            // Set room availability back to true
            if (deletedBooking.roomId) {
                const room = await Room.findById(deletedBooking.roomId);
                if (room) {
                    room.availability = true;
                    await room.save(); // Save the updated room status
                }
            }
        } else if (deletedBooking.bookingType === 'RestaurantBooking') {
            // Set restaurant availability back to true
            if (deletedBooking.restaurantId) {
                const restaurant = await Restaurant.findById(deletedBooking.restaurantId);
                if (restaurant) {
                    restaurant.availability = true;
                    await restaurant.save(); // Save the updated restaurant status
                }
            }
        }

        res.status(204).json({
            status: 'success',
            data: null
        });
    } catch (error) {
        return next(new AppError('Error in deleting booking. Please try again.', 500));
    }
});