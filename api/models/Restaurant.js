const mongoose = require('mongoose');

const restaurant = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  restaurantImage: {
    type: String,
  },
  averageRating: {
    type: Number,
    default: 0, // Automatic
  },
  price: {
    type: Number,
    required: true,
  },
  //test
  location: {
    type: String,
    required: true,
  },
  openingHours: {
    type: String,
    required: true,
  },
  capacity: {
    type: Number,
    required: true,
  },
  availability: {
    type: Boolean,
    default: true,
  },
  walletAddress: {
    type: String,
    required: true,
  },
  ratings: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'RestaurantRating', // Array of ratings
    },
  ],
});

const Restaurant = mongoose.model('Restaurant', restaurant);

module.exports = Restaurant;
