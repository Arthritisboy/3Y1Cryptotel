const mongoose = require('mongoose');

const favouriteSchema = new mongoose.Schema({
  favouriteHotel: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Hotel', // References the Hotel model
    }
  ],
  favouriteRestaurant: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Restaurant', // References the Restaurant model
    }
  ]
});

const Favourite = mongoose.model('Favourite', favouriteSchema);
module.exports = Favourite;
