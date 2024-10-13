const mongoose = require('mongoose');

const favouriteSchema = new mongoose.Schema({
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

module.exports = mongoose.model('Favourite', favouriteSchema);
