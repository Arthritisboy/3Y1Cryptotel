const express = require('express');
const restaurantController = require('../controllers/restaurantController');
const authController = require('../controllers/authController');
const { upload } = require('../middleware/imageUpload');

const router = express.Router();

// Restaurant routes
router
  .route('/')
  .get(authController.protect, restaurantController.getRestaurant)
  .post(upload.single('image'), restaurantController.createRestaurant);

router
  .route('/:id')
  .get(authController.protect, restaurantController.getRestaurant)
  .patch(upload.single('image'),restaurantController.updateRestaurant)
  .delete(restaurantController.deleteRestaurant);

module.exports = router;
