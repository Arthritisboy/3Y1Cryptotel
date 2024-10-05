const express = require('express');
const bookingController = require('../controllers/bookingController');

const router = express.Router();

// Get all bookings for the current user
router.get('/bookings', bookingController.getBookings);

// Create a new booking
router.post('/bookings', bookingController.createBooking);

// Update a booking by ID
router.patch('/bookings/:bookingId', bookingController.updateBooking);

// Delete a booking by ID
router.delete('/bookings/:bookingId', bookingController.deleteBooking);

module.exports = router;
