const express = require('express');
const userController = require('../controllers/userController');
const authController = require('../controllers/authController');
const { upload } = require('../middleware/imageUpload');

const router = express.Router();

router.route('/').get(authController.protect, userController.getAllUsers);
router.put(
  '/updateMe',
  authController.protect,
  upload.single('image'),
  userController.updateMe,
);
router.delete('/deleteMe', authController.protect, userController.deleteMe);
router.put(
  '/updateHasCompletedOnboarding',
  authController.protect,
  userController.updateHasCompletedOnboarding,
);

router
  .route('/:id')
  .get(authController.protect, userController.getUser)
  .delete(
    authController.protect,
    authController.restrictTo('admin'),
    userController.deleteUser,
  );

module.exports = router;
