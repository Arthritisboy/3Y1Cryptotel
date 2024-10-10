const mongoose = require('mongoose');

const raitingSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  restaurantImage: {
    type: String,
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
  ratings: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'RestaurantRating', // Array of ratings
    },
  ],
});

const Restaurant = mongoose.model('Restaurant', raitingSchema);

module.exports = Restaurant;
