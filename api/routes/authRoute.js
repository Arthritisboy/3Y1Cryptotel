const express = require('express');
const authController = require('../controllers/authController');

const router = express.Router();

// ** Sign up route
router.route('/signup').post(authController.register);

// ** Send verification route
router.post('/sendVerificationCode', authController.sendVerificationCode);

// ** Verify route
router.post('/verifyCode', authController.verifyCode);

// ** Login route
router.route('/login').post(authController.login);

// ** Forgot Password route
router.post('/forgotPassword', authController.forgotPassword);

// ** Reset Password route
router.patch('/resetPassword/:token', authController.resetPassword);

// * Update Password route
router.patch(
  '/updateMyPassword',
  authController.protect,
  authController.updatePassword,
);

module.exports = router;
