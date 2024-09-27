const User = require("../models/User");
const { StatusCodes } = require("http-status-codes");
const { BadRequestError, UnauthenticatedError } = require("../errors");

//! Function
const signToken = (id) => {
  return jwt.sign({ id: id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const register = async (req, res) => {
  const newUser = await User.create({ ...req.body });
  //! Creation of token
  const token = signToken(newUser.id);

  //! Response
  res
    .status(StatusCodes.CREATED)
    .json({ user: { name: newUser.userName }, token });
};

const login = async (req, res) => {
  const { email, password } = req.body;

  //! 1) Check if email and password exist
  if (!email || !password) {
    throw new BadRequestError("Please provide email and password");
  }

  //! 2) Check if user exists && password is correct
  const user = await User.findOne({ email });

  if (!user || (await user.correctPassword(password, user.password))) {
    throw new UnauthenticatedError("Incorrect email or password");
  }

  //! 3) If everything is ok, send the token to the client
  const token = signToken(user._id);
  res.status(StatusCodes.OK).json({ user: { name: user.userName }, token });
};

module.exports = {
  register,
  login,
};

exports.protect = catchAsync(async (req, res, next) => {
  //! 1) Getting token and check of it's there
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }

  if (!token) {
    return next(
      new AppError("You are not logged in!, Please login in to get access", 401)
    );
  }
  //! 2) Verification token
  const decoded = await promisify(jwt.verify)(token, process.env.JWT_SECRET);

  //! 3) Check if user still exists
  const currentUser = await User.findById(decoded.id);

  if (!currentUser) {
    return next(
      new AppError("The token belonging to this user is no longer exists", 401)
    );
  }
  //! 4) Check if user changed password after the JWT was issued
  if (currentUser.changedPasswordAfter(decoded.iat)) {
    return next(
      new AppError("User recently changed password!, Please login again", 401)
    );
  }

  // ** GRANT ACCESS TO THE USER ROUTE
  req.user = currentUser;
  next();
});
