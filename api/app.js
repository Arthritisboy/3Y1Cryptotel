const express = require('express');
const morgan = require('morgan');
const dotenv = require('dotenv');
const cors = require('cors');
// const { NotFoundError } = require('./errors');
//! connectDB
const connectToDatabase = require('./database/connection');

//! Security
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
// const mongoSanitize = require('express-mongo-sanitize');
// const xss = require('xss-clean');

// // Authentication
// const authenticateUser = require('./middleware/userAuthentication');

//! Routers
const authRouter = require('./routes/authRoute');
const homeRouter = require('./routes/homeRoute');
const userRoute = require('./routes/userRoute');
// const web3Router = require('./routes/web3');

//!Error Handler
const AppError = require('./utils/appError');
const globalErrorHandler = require('./errors/error-handler.js');
// const notFoundMiddleware = require('./middleware/not-found');
// const errorHandlerMiddleware = require('./middleware/error-handler');

//! Load environment variables from the config file
dotenv.config({ path: './config.env' });

//! Create the Express app
const app = express();

//! Security Middlewares

// ** It means 100 request per hour
const limiter = rateLimit({
  max: 100,
  windowMs: 60 * 60 * 1000,
  message: 'Too many request from this IP, please try again in an hour!',
});
app.use('/api', limiter);
app.use(helmet());

//! Middlewares
app.use(cors());
app.use(express.json());
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

//! Custom middlewares to log requests and add request time
app.use((req, res, next) => {
  console.log('Hello from the server 👋');
  next();
});

app.use((req, res, next) => {
  req.requestTime = new Date().toISOString();
  next();
});

//! Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/users', userRoute);
// app.use('/api/v1/web3', web3Router);

//! Handle all undefined routes
app.all('*', (req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server`, 404));
});

// Global error handling middleware
// app.use(notFoundMiddleware);
// app.use(errorHandlerMiddleware);
app.use(globalErrorHandler);

//! Start the server
const port = process.env.PORT || 3000;

const start = async () => {
  try {
    await connectToDatabase();
    app.listen(port, () =>
      console.log(`Server is listening on port ${port}...`),
    );
  } catch (error) {
    console.log(error);
  }
};
start();
