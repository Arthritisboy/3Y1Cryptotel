// const mongoose = require('mongoose');
// const { StatusCodes } = require('http-status-codes');
// const { NotFoundError } = require('../errors');

// const connectDB = (url) => {
//   if (!url) {
//     throw new NotFoundError('No Database URL Found');
//   }
//   return url.replace('<db_password>', process.env.MONGO_PASSWORD);
// };

// const connectToDatabase = async () => {
//   const dbURL = connectDB(process.env.MONGO_EMAIL);

//   try {
//     mongoose
//       .connect(dbURL, {
//         useNewUrlParser: true,
//         useUnifiedTopology: true,
//       })
//       .then(() => console.log('Database connection is successful'));
//   } catch (error) {
//     res
//       .status(StatusCodes.INTERNAL_SERVER_ERROR)
//       .json({ message: error.message });
//   }
// };

// module.exports = connectToDatabase;
