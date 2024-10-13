const express = require('express');
const favoriteController = require('../controllers/favoriteController');
const authController = require('../controllers/authController');

const router = express.Router();

// Route to add to favorites (for both hotel and restaurant)
router.post(
  '/add/:userId',
  authController.protect,
  favoriteController.addToFavorites,
);

// Route to remove from favorites (for both hotel and restaurant)
router.delete(
  '/remove/:userId',
  authController.protect,
  favoriteController.removeFromFavorites,
); // Use DELETE method

// Route to get all favorites for the logged-in user
router.get('/:userId', authController.protect, favoriteController.getFavorites);

module.exports = router;
