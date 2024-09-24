const express = require('express');
const authController = require('../controllers/auth');

const router = express.Router();

router
  .route('/SignUp')
  .post(authController.register);

router
  .route('/Login')
  .post(authController.login);

module.exports = router;
