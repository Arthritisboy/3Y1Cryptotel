const express = require('express');
const restaurantController = require('../controllers/restaurantController');
const authController = require('../controllers/authController');
const ratingRestaurantController = require('../controllers/ratingRestaurantController');
const { upload } = require('../middleware/imageUpload');

const router = express.Router();

// Restaurant routes
router
  .route('/:userId')
  .get(authController.protect, restaurantController.getRestaurant)
  .post(upload.single('image'), restaurantController.createRestaurant);

router
  .route('/:id')
  .get(authController.protect, restaurantController.getRestaurant)
  .patch(upload.single('image'),restaurantController.updateRestaurant)
  .delete(restaurantController.deleteRestaurant);

  
// Rating routes
router.route('/ratings/:restaurantId').post(ratingRestaurantController.createRating);

router
  .route('/ratings/:id')
  .get(ratingRestaurantController.getRating)
  .patch(ratingRestaurantController.updateRating)
  .delete(ratingRestaurantController.deleteRating);
module.exports = router;
