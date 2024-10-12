const express = require('express');
const bookingController = require('../controllers/bookingController');
const authController = require('../controllers/authController');
const router = express.Router();

// Booking routes
router
  .route('/:userId')
  .get(authController.protect, bookingController.getBookings) // Get all bookings for the user
  .post(authController.protect, bookingController.createBooking); // Create a new booking

router
  .route('/:bookingId')
  .patch(authController.protect, bookingController.updateBooking) // Update a booking by ID
  .delete(authController.protect, bookingController.deleteBooking); // Delete a booking by ID

// router.route('/bookings/restaurant/:userId')
//     .get(bookingController.getBookings) // Get all bookings for the user
//     .post(bookingController.createBooking); // Create a new booking

// router.route('/bookings/restaurant/:bookingId')
//     .patch(bookingController.updateBooking) // Update a booking by ID
//     .delete(bookingController.deleteBooking); // Delete a booking by ID

module.exports = router;
