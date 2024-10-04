const User = require('../models/User');
const { uploadProfileImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const { promisify } = require('util');
const jwt = require('jsonwebtoken');
const sendEmail = require('../utils/email');
const crypto = require('crypto');

const createSendToken = (user, statusCode, res, additionalData = {}) => {
  const token = user.createJWT();
  const cookieOptions = {
    expires: new Date(
      Date.now() + process.env.JWT_COOKIE_EXPIRES_IN * 24 * 60 * 60 * 1000,
    ),
    secure: true,
    httpOnly: true,
  };
  if (process.env.NODE_ENV === 'production') cookieOptions.secure = true;

  //! Send the token and additional data to the client
  res.cookie('jwt', token, cookieOptions);
  res.status(statusCode).json({
    status: 'success',
    token,
    ...additionalData,
  });
};

// ** Register controller
exports.register = catchAsync(async (req, res) => {
  let profile = undefined;

  if (req.file) {
    try {
      profile = await uploadProfileImage(req); 
    } catch (uploadErr) {
      return res.status(500).json({
        status: 'error',
        message: 'Image upload failed',
        error: uploadErr
      });
    }
  }

  const newUser = await User.create({
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    email: req.body.email,
    password: req.body.password,
    confirmPassword: req.body.confirmPassword,
    profile: profile || undefined  ,
    hasOnboardingCompleted: req.body.hasOnboardingCompleted,
  });

  console.warn("New user created:", newUser);

  // Send a token and user data as a response
  // createSendToken(newUser, 201, res);

  //! Send verification code after signup
  const verificationCode = newUser.createVerificationCode();
  await newUser.save({ validateBeforeSave: false });

  const message = `Your verification code is: ${verificationCode}. This code is valid for 10 minutes.`;

  try {
    await sendEmail({
      email: newUser.email,
      subject: 'Verification Code',
      message,
    });
    res.status(201).json({
      status: 'success',
      message: 'User registered! Verification code sent to email.',
    });
  } catch (error) {
    newUser.verificationCode = undefined;
    newUser.codeExpires = undefined;
    await newUser.save({ validateBeforeSave: false });

    return next(
      new AppError('Error sending verification code. Please try again.', 500),
    );
  }
});

exports.sendVerificationCode = catchAsync(async (req, res, next) => {
  const user = await User.findOne({ email: req.body.email });

  if (!user) {
    return next(new AppError('User not found with this email.', 404));
  }

  const verificationCode = user.createVerificationCode();
  await user.save({ validateBeforeSave: false });

  try {
    await sendEmail({
      email: user.email,
      subject: 'Your Verification Code',
      verificationCode: verificationCode,
      type: 'verification',
    });
    res.status(200).json({
      status: 'success',
      message: 'Verification code sent to email!',
    });
  } catch (err) {
    user.verificationCode = undefined;
    user.codeExpires = undefined;
    await user.save({ validateBeforeSave: false });

    return next(
      new AppError('Error sending verification code. Try again later.', 500),
    );
  }
});
// ** Verify code controller
exports.verifyCode = catchAsync(async (req, res, next) => {
  const { email, code } = req.body;

  const hashedCode = crypto.createHash('sha256').update(code).digest('hex');

  // Find user by email and verification code, ensuring code has not expired
  const user = await User.findOne({
    email,
    verificationCode: hashedCode,
    codeExpires: { $gt: Date.now() }, // Ensure the code has not expired
  });

  if (!user) {
    return next(new AppError('Invalid or expired verification code.', 400));
  }

  // Mark user as verified and clear verificationCode and codeExpires fields
  user.verified = true;
  user.verificationCode = undefined;
  user.codeExpires = undefined;

  // Use { validateBeforeSave: false } to prevent Mongoose from trying to validate confirmPassword
  await user.save({ validateBeforeSave: false });

  res.status(200).json({
    status: 'success',
    message: 'User successfully verified!',
  });
});

// ** Login Controller
exports.login = catchAsync(async (req, res, next) => {
  const { email, password } = req.body;

  //! Check if email and password exist
  if (!email || !password) {
    return next(new AppError('Please provide email and password', 400));
  }

  //! Check if user exists && password is correct
  const user = await User.findOne({ email: email }).select('+password');

  if (!user || !(await user.correctPassword(password, user.password))) {
    return next(new AppError('Incorrect email or password', 401));
  }

  if (!user.verified) {
    return next(
      new AppError('Please verify your email before logging in.', 401),
    );
  }

  console.log('User has completed onboarding:', user.hasCompletedOnboarding);

  //! Send the token and user id in the response only for login
  createSendToken(user, 200, res, { userId: user._id, hasCompletedOnboarding: user.hasCompletedOnBoarding });
});

// ** Protected Controller
exports.protect = catchAsync(async (req, res, next) => {
  //! 1) Getting token and check of it's there
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    token = req.headers.authorization.split(' ')[1];
  }
  if (!token) {
    return next(
      new AppError(
        'You are not logged in!, Please login in to get access',
        401,
      ),
    );
  }
  //! 2) Verification token
  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);
  //! 3) Check if user still exists
  const currentUser = await User.findById(decoded.id);
  if (!currentUser) {
    return next(
      new AppError(
        'The token belonging to this user is no longer exists.',
        401,
      ),
    );
  }

  //! 4) Check if user changed password after the JWT was issued
  if (currentUser.changedPasswordAfter(decoded.iat)) {
    return next(
      new AppError('User recently changed password!, Please login again', 401),
    );
  }

  // !! GRANT ACCESS TO THE USER ROUTE
  req.user = currentUser;
  next();
});

// ** Restring the access Controller
exports.restrictTo = (...roles) => {
  return (req, res, next) => {
    console.log(req.user);
    if (!roles.includes(req.user.roles)) {
      return next(
        new AppError('You do not have permission to perform this action', 403),
      );
    }
    next();
  };
};

// ** Forgot Password Controller
exports.forgotPassword = catchAsync(async (req, res, next) => {
  //! 1) Get user based on resetToken
  const user = await User.findOne({ email: req.body.email });
  if (!user) next(new AppError('There is no user with email address'), 404);

  //! 2) Generate the random reset token
  const resetToken = user.createPasswordResetToken();
  await user.save({ validateBeforeSave: false });

  // Node Emailer
  //! 3) Send it to the user's email

  try {
    await sendEmail({
      email: user.email,
      subject: 'Your password reset token (valid for 10min)',
      resetToken: resetToken,
      type: 'reset',
    });
    res.status(200).json({
      status: 'success',
      message: 'Token sent to email!',
    });
  } catch (err) {
    user.passwordResetToken = undefined;
    user.passwordResetExpires = undefined;
    await user.save({ validateBeforeSave: false });

    return next(
      new AppError(
        'There was an error sending the email. Try again later!',
        500,
      ),
    );
  }
});

// ** Reset Password Controller
exports.resetPassword = catchAsync(async (req, res, next) => {
  //! 1) Get user based on the token
  const hashedToken = crypto
    .createHash('sha256')
    .update(req.params.token)
    .digest('hex');

  const user = await User.findOne({
    passwordResetToken: hashedToken,
    passwordResetExpires: { $gt: Date.now() },
  });

  //! 2) If token has not expired, and there is user, set the new password
  if (!user) {
    return next(new AppError('Token is invalid or has expired', 400));
  }
  user.password = req.body.password;
  user.confirmPassword = req.body.confirmPassword;
  user.passwordResetToken = undefined;
  user.passwordResetExpires = undefined;
  await user.save();

  //! 3) Update changePasswordAt property for the user
  //! 4) Log the user in, send JWT
  createSendToken(user, 200, res);
});

// ** Update Password Controller
exports.updatePassword = catchAsync(async (req, res, next) => {
  //! 1) Get user from collection
  const user = await User.findById(req.user.id).select('+password');

  //! 2) Check if POSTED current password is correct
  if (!(await user.correctPassword(req.body.passwordCurrent, user.password))) {
    return next(new AppError('Your current password is wrong.', 401));
  }

  //! 3) If so, update password
  user.password = req.body.password;
  user.confirmPassword = req.body.confirmPassword;
  await user.save();

  //! 4) Log user in, send JWT
  createSendToken(user, 200, res);
});
