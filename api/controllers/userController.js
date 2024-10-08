const User = require('../models/User');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const { uploadProfileImage } = require('../middleware/imageUpload');

const filterObj = (obj, ...notAllowedFields) => {
  const newObj = {};
  Object.keys(obj).forEach((el) => {
    if (!notAllowedFields.includes(el)) newObj[el] = obj[el];
  });
  return newObj;
};
exports.getAllUsers = catchAsync(async (req, res) => {
  const users = await User.find();

  // SEND RESPONSE
  res.status(200).json({
    status: 'success',
    results: users.length,
    data: {
      users,
    },
  });
});

exports.getUser = catchAsync(async (req, res, next) => {
  const user = await User.findById(req.params.id);
  if (!user) {
    return next(new AppError('No student has found with that ID', 404));
  }
  res.status(200).json({
    status: 'success',
    data: {
      user,
    },
  });
});

exports.deleteUser = catchAsync(async (req, res, next) => {
  const users = await User.findByIdAndDelete(req.params.id);
  if (!users) {
    return next(new AppError('No user has found with that ID', 404));
  }
  res.status(204).json({
    status: 'success',
    data: null,
  });
});

exports.updateMe = catchAsync(async (req, res, next) => {
  let profile;

  // Upload image if provided
  if (req.file) {
    try {
      profile = await uploadProfileImage(req);
    } catch (uploadErr) {
      return res.status(500).json({
        status: 'error',
        message: 'Image upload failed',
        error: uploadErr.message,
      });
    }
  }

  // Filter out unwanted fields
  const filteredBody = filterObj(req.body, 'roles');

  if (profile) {
    filteredBody.profile = profile; // Add profile image URL
  }

  // Update user document
  const updateUser = await User.findByIdAndUpdate(req.user.id, filteredBody, {
    new: true,
    runValidators: true,
  });

  // Send the updated user data in response
  res.status(200).json({
    status: 'success',
    data: {
      user: updateUser, // Ensure this includes the profile URL
    },
  });
});

exports.deleteMe = catchAsync(async (req, res, next) => {
  await User.findByIdAndUpdate(req.user.id, { active: false });

  res.status(204).json({
    status: 'success',
    data: null,
  });
});

exports.updateHasCompletedOnboarding = catchAsync(async (req, res, next) => {
  await User.findByIdAndUpdate(
    req.user.id,
    { hasCompletedOnboarding: true },
    { new: true, runValidators: true },
  );

  if (!User) {
    return next(new AppError('No user found with that ID', 404));
  }

  res.status(200).json({
    status: 'success',
    data: {
      User,
    },
  });
});
