const express = require('express');
const authController = require('../controllers/authController');
const { upload } = require('../middleware/imageUpload');

const router = express.Router();

router.route('/signup').post(upload.single('image'), authController.register);
// ** Sign up route
// //router.route('/signup').post(authController.register);

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
