const express = require('express');
const hotelController = require('../controllers/hotelController');
const roomController = require('../controllers/roomController');
const ratingController = require('../controllers/ratingController');
const authController = require('../controllers/authController');
const restaurantController = require('../controllers/restaurantController');
const { upload } = require('../middleware/imageUpload');
const { updateAllHotelsAverage } = require('../middleware/averageCalculator');

const router = express.Router();

router.route('/update-all-averages').patch(updateAllHotelsAverage);

// Hotel routes
router
  .route('/')
  .get(authController.protect, hotelController.getHotel)
  .post(
    upload.single('image'),
    authController.protect,
    authController.restrictTo('admin'),
    hotelController.createHotel,
  );

router
  .route('/:id')
  .get(authController.protect, hotelController.getHotel)
  .patch(upload.single('image'), hotelController.updateHotel)
  .delete(hotelController.deleteHotel);

// Room routes
router
  .route('/rooms/:hotelId')
  .post(upload.single('image'), roomController.createRoom);

router
  .route('/rooms/:id')
  .get(authController.protect, roomController.getRoom)
  .patch(upload.single('image'), roomController.updateRoom)
  .delete(roomController.deleteRoom);

// Rating routes
router.route('/ratings/:roomId').post(ratingController.createRating);

router
  .route('/ratings/:id')
  .get(ratingController.getRating)
  .patch(ratingController.updateRating)
  .delete(ratingController.deleteRating);

module.exports = router;
