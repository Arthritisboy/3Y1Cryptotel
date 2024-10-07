const mongoose = require('mongoose');
const Room = require('./Room');
const Rating = require('./Rating');

const hotelSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    averageRating: {
        type: Number,
        default: 0  // Automatic
    },
    averagePrice: {
        type: String, // Automatic
    },
    location: {
        type: String,
        required: true,
    },
    openingHours: {
        type: String,
        required: true // example "7:30 Am to 4:30 Pm" I make it simpler rather than using complicated type: Date
    },
    hotelImage: {
        type: String, // similar user profile
    },
    rooms: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room'
    }],
});

// Method to calculate the average rating from all rooms' ratings
hotelSchema.methods.calculateAverageRating = async function() {
    await this.populate('rooms');  // Ensure rooms are populated
    let totalRating = 0;
    let totalReviews = 0;

    for (const room of this.rooms) {
        await room.populate('ratings');  // Populate the ratings for each room
        const roomRatings = room.ratings;

        roomRatings.forEach((rating) => {
            totalRating += rating.rating;
            totalReviews++;
        });
    }

    return totalReviews > 0 ? totalRating / totalReviews : 0;
};

// Method to calculate the price range of rooms in the hotel
hotelSchema.methods.calculatePriceRange = async function() {
    await this.populate('rooms');  // Ensure rooms are populated

    const roomPrices = this.rooms.map(room => room.price);

    if (roomPrices.length === 0) {
        return 'No rooms available';
    }

    const minPrice = Math.min(...roomPrices);
    const maxPrice = Math.max(...roomPrices);

    return `$${minPrice} - $${maxPrice}`;
};

// Pre-save hook to update hotel rating before saving
hotelSchema.pre('save', async function(next) {
    this.averageRating = await this.calculateAverageRating();
    next();
});

const Hotel = mongoose.model('Hotel', hotelSchema);
=======

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
