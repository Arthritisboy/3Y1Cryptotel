const express = require('express');
const bookingController = require('../controllers/bookingController');

const router = express.Router();

router.get('/getBooking', bookingController.getBooking);

router.route('/createBooking').post(bookingController.createBooking);

router.patch('/editBooking', bookingController.updateBooking);

router.delete('/deleteBooking', bookingController.deleteBooking);

module.exports = router;
