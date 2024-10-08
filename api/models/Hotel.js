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
        type: Number,
        default: 0 // Automatic
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
    // contactNumber: { will add this later I kida forgot to git pull
    //   type: String,
    //   required: true,
    // },
    // email: {
    //   type: String,
    //   required: true,
    // },
    // cryptoWalletAddress: {
    //   type: String,
    //   required: true,
    // },



    rooms: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room'
    }],
});


const Hotel = mongoose.model('Hotel', hotelSchema);
module.exports = Hotel;
