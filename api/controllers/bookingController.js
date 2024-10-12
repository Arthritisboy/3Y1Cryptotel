const User = require('../models/User');
const Hotel = require('../models/Hotel');
const Room = require('../models/Room');
const Restaurant = require('../models/Restaurant');
const Booking = require('../models/Booking');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const sendEmail = require('../utils/email');

// ** Get all bookings for a user
exports.getBookings = catchAsync(async(req, res, next) => {
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

// ** Create a new booking
exports.createBooking = catchAsync(async(req, res, next) => {
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
        let hotelName = '';
        let roomName = '';
        let restaurantName = ''; // For restaurant bookings

        let numAdults = parseInt(adult, 10);
        let numChildren = parseInt(children, 10);

        if (bookingType === 'HotelBooking') {
            const room = await Room.findById(roomId);
            const hotel = await Hotel.findById(hotelId);

            if (!room || !hotel) {
                return next(new AppError('Room or Hotel not found', 404));
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
                return next(new AppError('Restaurant not found', 404));
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

// ** Update an existing booking (e.g., change dates)
exports.updateBooking = catchAsync(async(req, res, next) => {
    const id = req.params.bookingId;
    try {
        const {
            checkInDate,
            checkOutDate,
            status,
            timeOfArrival,
            timeOfDeparture,
        } = req.body;

        // Find the booking and update the details
        const updatedBooking = await Booking.findByIdAndUpdate(
            id, { checkInDate, checkOutDate, timeOfArrival, timeOfDeparture, status }, { new: true, runValidators: true },
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