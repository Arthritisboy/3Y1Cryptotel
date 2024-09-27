const User = require("../models/User");
const { StatusCodes } = require("http-status-codes");
const { BadRequestError, UnauthenticatedError } = require("../errors");

const signToken = (id) => {
  return jwt.sign({ id: id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const register = async (req, res) => {
  const newUser = await User.create({ ...req.body });
  const token = signToken(newUser.id);
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

  const token = user.createJWT();
  res.status(StatusCodes.OK).json({ user: { name: user.userName }, token });
};

module.exports = {
  register,
  login,
};
