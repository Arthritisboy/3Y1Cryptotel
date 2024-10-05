const mongoose = require('mongoose');

const hotelSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    required: true,
  },
  hotelName: {
    type: String,
    required: true,
  },
  imagePath: {
    type: String,
  },
  rating: {
    type: Number,
    default: 0,
  },
  price: {
    type: Number,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  contactNumber: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  cryptoWalletAddress: {
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
