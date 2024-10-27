const mongoose = require('mongoose');

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
    unique: true,
  },
  openingHours: {
    type: String,
    required: true,
  },
  hotelImage: {
    type: String,
    required: true,
    unique: true,
  },
  walletAddress: {
    type: String,
    required: true,
    default: '0xc818CfdA6B36b5569E6e681277b2866956863fAd',
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
