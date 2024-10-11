const express = require('express');
const ratingController = require('../controllers/ratingController');
const { updateAllHotelsAverage } = require('../middleware/averageCalculator');
const router = express.Router();

router.post('/:id', ratingController.createRating); 

router
    .route('/:ratingId') 
    .get(ratingController.getRating)       
    .put(ratingController.updateRating)     
    .delete(ratingController.deleteRating); 

module.exports = router;
