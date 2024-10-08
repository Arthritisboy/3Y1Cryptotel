const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  tableNumber: {
    type: String,
    required: true,
  },
  restaurantImage: {
    type: String,
  },
  type: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true
  },
  capacity: {
    type: Number,
    required: true
  },
  availability: {
    type: Boolean,
    default: true
  },
  ratings: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Rating'  // Array of ratings
  }]
});

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant;
