const express = require('express');
const router = express.Router();
const testController = require('../controllers/profileController');

router.get("/test", testController.test);
router.get('/profile/:id', testController.getProfile);
router.post('/profile', testController.postProfile);

module.exports = router;
