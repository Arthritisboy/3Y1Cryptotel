const express = require('express');
const favoriteController = require('../controllers/favoriteController');
const authController = require('../controllers/authController');

const router = express.Router();

router.use(authController.protect); // Uncomment this line to enforce authentication

router.post('/add/:userId', favoriteController.addToFavorites);

router.delete('/remove/:userId', favoriteController.removeFromFavorites); // Use DELETE method

router.get('/:userId', favoriteController.getFavorites);

module.exports = router;
