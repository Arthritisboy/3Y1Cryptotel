const mongoose = require('mongoose');

const favoriteSchema = new mongoose.Schema({
  hotels: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Hotel',
    },
  ],
  restaurants: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Restaurant',
    },
  ],
});

module.exports = mongoose.model('favorite', favoriteSchema);
