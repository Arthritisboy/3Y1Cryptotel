const User = require("../models/User");
const catchAsync = require("../utils/catchAsync");
const AppError = require("../utils/appError");

exports.getAllUsers = catchAsync(async (req, res) => {
  const users = await User.find();

  // SEND RESPONSE
  res.status(200).json({
    status: "success",
    results: users.length,
    data: {
      users,
    },
  });
});

exports.deleteUser = catchAsync(async (req, res, next) => {
  const users = await User.findByIdAndDelete(req.params.id);
  if (!users) {
    return next(new AppError("No user has found with that ID", 404));
  }
  res.status(204).json({
    status: "success",
    data: null,
  });
});
