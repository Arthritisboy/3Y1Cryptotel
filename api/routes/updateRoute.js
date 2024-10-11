const express = require('express');
const { updateAllHotelsAverage } = require('../middleware/averageCalculator'); // Adjust the import based on your directory structure
const router = express.Router();

router
    .route('/')
    .patch(updateAllHotelsAverage);

module.exports = router;
