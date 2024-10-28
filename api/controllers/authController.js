const User = require('../models/User');
const { uploadEveryImage } = require('../middleware/imageUpload');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const { promisify } = require('util');
const jwt = require('jsonwebtoken');
const sendEmail = require('../utils/email');
const crypto = require('crypto');
const TokenBlacklist = require('../database/tokenBlacklist');

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

// ** Register Controller
// ** Register Controller
exports.register = catchAsync(async (req, res, next) => {
  let profile;

  // Handle image upload if provided
  if (req.file) {
    try {
      profile = await uploadEveryImage(req);
    } catch (uploadErr) {
      console.error('Image upload failed:', uploadErr);
      return next(new AppError('Image upload failed. Please try again.', 500));
    }
  }

  // Validate role input
  const validRoles = ['user', 'admin', 'manager'];
  if (!validRoles.includes(req.body.roles)) {
    return next(new AppError('Invalid role provided.', 400));
  }

  // Prepare user data for registration
  const userData = {
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    email: req.body.email,
    password: req.body.password,
    confirmPassword: req.body.confirmPassword,
    gender: req.body.gender,
    phoneNumber: req.body.phoneNumber,
    favoriteId: req.body.roles === 'user' ? null : undefined,
    roles: req.body.roles || 'user',
    profile:
      profile ||
      'https://res.cloudinary.com/djuvg4di0/image/upload/v1728833875/burui8vcrcqrvedo39yt.png',
    hasCompletedOnboarding: req.body.hasCompletedOnboarding || false,
    handleId:
      req.body.roles === 'manager' || req.body.roles === 'admin'
        ? null
        : undefined,
  };

  // Attempt to create the new user
  let newUser;
  try {
    newUser = await User.create(userData);
  } catch (err) {
    // Handle MongoDB duplicate key error (E11000)
    if (err.code === 11000 && err.keyPattern.email) {
      return next(
        new AppError(
          `A user with email ${err.keyValue.email} already exists.`,
          400,
        ),
      );
    }
    console.error('User creation failed:', err); // Log full error for debugging
    return next(new AppError('Registration failed. Please try again.', 500));
  }

  console.warn('New user created:', newUser);

  // Generate verification code
  const verificationCode = newUser.createVerificationCode();
  await newUser.save({ validateBeforeSave: false });

  const message = `Your verification code is: ${verificationCode}. This code is valid for 10 minutes.`;

  // Send verification email
  try {
    await sendEmail({
      email: newUser.email,
      subject: 'Verification Code',
      message,
    });

    res.status(201).json({
      status: 'success',
      message: 'User registered! Verification code sent to email.',
      verificationCode,
    });
  } catch (emailError) {
    console.error('Failed to send email:', emailError);
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

  user.verified = true;
  user.verificationCode = undefined;
  user.codeExpires = undefined;

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
  createSendToken(user, 200, res, {
    userId: user._id,
    hasCompletedOnboarding: user.hasCompletedOnboarding,
    roles: user.roles,
    handleId: user.handleId || 'null',
  });
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

// ** Resend Verification Code Controller
exports.resendCode = catchAsync(async (req, res, next) => {
  const { email } = req.body;

  // 1. Check if the user exists
  const user = await User.findOne({ email });

  if (!user) {
    return next(new AppError('User not found with this email.', 404));
  }

  // 2. Check if the user is already verified
  if (user.verified) {
    return next(new AppError('User is already verified.', 400));
  }

  // 3. Generate a new verification code
  const verificationCode = user.createVerificationCode();
  await user.save({ validateBeforeSave: false });

  // 4. Send the new verification code to the user's email
  try {
    await sendEmail({
      email: user.email,
      subject: 'Your New Verification Code',
      verificationCode: verificationCode,
      type: 'verification',
    });

    // 5. Return success response
    res.status(200).json({
      status: 'success',
      message: 'Verification code resent to email!',
    });
  } catch (err) {
    // If there's an error sending the email, clear the verification code and its expiration
    user.verificationCode = undefined;
    user.codeExpires = undefined;
    await user.save({ validateBeforeSave: false });

    return next(
      new AppError('Error resending verification code. Try again later.', 500),
    );
  }
});

exports.logout = async (req, res) => {
  try {
    // Clear the JWT cookie by setting its expiration to a past date
    res.cookie('jwt', 'loggedOut', {
      expires: new Date(Date.now() + 1000), // Set the cookie expiration to 1 second in the past
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production', // Use secure cookies in production
    });

    // Optional: Blacklist the token
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      const token = req.headers.authorization.split(' ')[1];

      // Verify token and blacklist it
      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const expiresAt = new Date(decoded.exp * 1000); // Convert to Date object

        await TokenBlacklist.create({
          token,
          expiresAt,
        });
      } catch (err) {
        console.error('Token verification failed:', err);
        return res
          .status(401)
          .json({ status: 'fail', message: 'Unauthorized' });
      }
    }

    res.status(200).json({
      status: 'success',
      message: 'Successfully logged out!',
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({
      status: 'fail',
      message: 'Internal Server Error',
    });
  }
};
