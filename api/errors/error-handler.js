const AppError = require("../utils/appError");

const sendErrorDev = (err, res) => {
  res.status(err.statusCode).json({
    status: err.status,
    error: err,
    message: err.message,
    stack: err.stack,
  });
};

const handleCastErrorDB = () => {
  const message = `Invalid ${err.path}: ${err.value}`;
  return new AppError(message, 400);
};

const handleJWTError = (err) =>
  new AppError("Invalid token. Please login in again!", 401);

const handleJWTExpiredError = () =>
  new AppError("Your token has expired! Please log in again.", 401);

const handleDuplicateFieldsDB = (err) => {
  const value = Object.values(err.keyValue)[0];
  const message = `Duplicate field value ${value}, Please use another value!`;
  return new AppError(message, 400);
};

const handleValidationErrorDB = (err) => {
  const error = Object.values(err.errors).map((val) => val.message);
  const message = `Invalid input data. ${error.join(". ")}`;

  return new AppError(message, 400);
};

const sendErrorProd = (err, res) => {
  //! Operational, trusted error: send message to client
  if (err.isOperational) {
    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
    });
    //! Progamming or other unkown error: don't leak error
  } else {
    //! 1) Log error
    console.error("ERROR 💥", err);
    //! 2) Send Generic message
    res.status(500).json({
      status: "error",
      message: "Something went very wrong!",
    });
  }
};

module.exports = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.status = err.status || "error";
  if (process.env.NODE_ENV === "development") {
    sendErrorDev(err, res);
  } else if (process.env.NODE_ENV === "production") {
    let error = JSON.parse(JSON.stringify(err));
    if (error.name === "CastError") error = handleCastErrorDB(error);
    if (error.code === 11000) error = handleDuplicateFieldsDB(error);
    if (error.name === "ValidationError") {
      error = handleValidationErrorDB(error);
    }
    if (error.name === "JsonWebTokenError") error = handleJWTError(error);
    if (error.name === "TokenExpiredError")
      error = handleJWTExpiredError(error);
    sendErrorProd(error, res);
  }
};
