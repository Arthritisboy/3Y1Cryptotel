const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const userSchema = new mongoose.Schema(
  {
    firstName: {
      type: String,
      required: [true, 'Please provide first name'],
      minLength: 3,
      maxLength: 50,
    },
    lastName: {
      type: String,
      required: [true, 'Please provide last name'],
      minLength: 3,
      maxLength: 50,
    },
    email: {
      type: String,
      required: [true, 'Please provide email'],
      match: [
        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
        'Please provide a valid email',
      ],
      unique: true,
    },
    phoneNumber: {
      type: String,
      required: [true, 'Please provide a phone number'],
    },
    gender: {
      type: String,
      enum: ['male', 'female', 'other'],
      required: [true, 'Please specify your gender'],
    },
    password: {
      type: String,
      required: [true, 'Please provide password'],
      minlength: 8,
      select: false,
    },
    confirmPassword: {
      type: String,
      validate: {
        validator: function (val) {
          return val === this.password;
        },
        message: `Passwords are not the same!`,
      },
    },
    verificationCode: {
      type: String,
    },
    codeExpires: {
      type: Date,
    },
    verified: {
      type: Boolean,
      default: false,
    },
    roles: {
      type: String,
      enum: ['user', 'admin'],
      default: 'user',
    },
    passwordChangedAt: {
      type: Date,
    },
    passwordResetToken: {
      type: String,
    },
    passwordResetExpires: {
      type: Date,
    },
    active: {
      type: Boolean,
      default: true,
      select: false,
    },
    profile: {
      type: String,
    },
    hasCompletedOnboarding: {
      type: Boolean,
      default: false,
    },
    favoriteId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Favorite',
    },
  },
  { timestamps: true },
);

// Pre-save middleware to hash the password if it's modified
userSchema.pre('save', async function (next) {
  // Only run this function if password was actually modified or the document is new
  if (!this.isModified('password')) return next();

  // Hash the password with cost of 12
  this.password = await bcrypt.hash(this.password, 12);

  // Delete confirmPassword field after validation
  this.confirmPassword = undefined;

  next();
});

// Pre-save middleware to set passwordChangedAt for new passwords
userSchema.pre('save', function (next) {
  // Only set passwordChangedAt if the password was modified and the document is not new
  if (!this.isModified('password') || this.isNew) return next();

  this.passwordChangedAt = Date.now() - 1000; // Set to just before token is issued
  next();
});

// Pre-query middleware to exclude inactive users
userSchema.pre(/^find/, function (next) {
  this.find({ active: { $ne: false } });
  next();
});

// Instance method to create JWT
userSchema.methods.createJWT = function () {
  return jwt.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_LIFETIME,
  });
};

// Check if the password is correct
userSchema.methods.correctPassword = async function (
  candidatePassword,
  userPassword,
) {
  return await bcrypt.compare(candidatePassword, userPassword);
};

// Check if the password was changed after the JWT was issued
userSchema.methods.changedPasswordAfter = function (JWTTimestamp) {
  if (this.passwordChangedAt) {
    const changedTimestamp = parseInt(
      this.passwordChangedAt.getTime() / 1000,
      10,
    );
    return JWTTimestamp < changedTimestamp;
  }

  // False means the password has NOT been changed
  return false;
};

// Generate password reset token
userSchema.methods.createPasswordResetToken = function () {
  const resetToken = crypto.randomBytes(3).toString('hex');

  this.passwordResetToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');

  this.passwordResetExpires = Date.now() + 10 * 60 * 1000; // 10 minutes

  return resetToken;
};

// Generate email verification code
userSchema.methods.createVerificationCode = function () {
  const verificationCode = crypto.randomBytes(3).toString('hex');

  this.verificationCode = crypto
    .createHash('sha256')
    .update(verificationCode)
    .digest('hex');

  this.codeExpires = Date.now() + 10 * 60 * 1000; // 10 minutes

  return verificationCode;
};

module.exports = mongoose.model('User', userSchema);
