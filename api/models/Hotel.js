const mongoose = require('mongoose');
const Room = require('./Room');
const Rating = require('./Rating');

const hotelSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
  },
  averageRating: {
    type: Number,
    default: 0, // Automatic
  },
  averagePrice: {
    type: Number,
    default: 0, // Automatic
  },
  location: {
    type: String,
    required: true,
  },
  openingHours: {
    type: String,
    required: true,
  },
  hotelImage: {
    type: String,
    required: true,
  },
  // contactNumber: { will add this later I kinda forgot to git pull
  //   type: String,
  //   required: true,
  // },
  // email: {
  //   type: String,
  //   required: true,
  // },
  walletAddress: {
    type: String,
    required: true,
  },

  rooms: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Room',
    },
  ],
});

const Hotel = mongoose.model('Hotel', hotelSchema);
module.exports = Hotel;
