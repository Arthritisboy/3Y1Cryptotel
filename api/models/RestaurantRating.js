const mongoose = require('mongoose');

const restaurantRatingSchema = new mongoose.Schema({
  rating: {
    type: Number,
    min: 1,
    max: 5,
    required: true,
  },
  message: {
    type: String,
    maxlength: 500,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  restaurantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Restaurant',
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const RestaurantRating = mongoose.model('RestaurantRating', restaurantRatingSchema);
module.exports = RestaurantRating;
