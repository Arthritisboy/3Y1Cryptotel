const express = require('express');
const bookingController = require('../controllers/bookingController');

const router = express.Router();

// Booking routes
router.route('/:userId')
    .get(bookingController.getBookings) // Get all bookings for the user
    .post(bookingController.createBooking); // Create a new booking

router.route('/:bookingId')
    .patch(bookingController.updateBooking) // Update a booking by ID
    .delete(bookingController.deleteBooking); // Delete a booking by ID

// router.route('/bookings/restaurant/:userId')
//     .get(bookingController.getBookings) // Get all bookings for the user
//     .post(bookingController.createBooking); // Create a new booking

// router.route('/bookings/restaurant/:bookingId')
//     .patch(bookingController.updateBooking) // Update a booking by ID
//     .delete(bookingController.deleteBooking); // Delete a booking by ID

module.exports = router;