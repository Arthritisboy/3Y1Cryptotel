const express = require('express');
const favouriteController = require('../controllers/favouriteController');
const authController = require('../controllers/authController');

const router = express.Router();

// Protect all routes, ensuring only logged-in users can access them
router.use(authController.protect); // Uncomment this line to enforce authentication

// Route to add to favourites (for both hotel and restaurant)
router.post('/add/:userId', favouriteController.addToFavourites);

// Route to remove from favourites (for both hotel and restaurant)
router.delete('/remove/:userId', favouriteController.removeFromFavourites); // Use DELETE method

// Route to get all favourites for the logged-in user
router.get('/:userId', favouriteController.getFavourites);

module.exports = router;
