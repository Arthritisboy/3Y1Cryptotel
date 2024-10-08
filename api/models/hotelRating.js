const mongoose = require('mongoose');

const hotelRatingSchema = new mongoose.Schema({
    rating: {
        type: Number,
        min: 1,
        max: 5,
        required: true
    },
    message: {
        type: String,
        maxlength: 500  // Optional review message
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',  // User who submitted the rating
        required: true
    },
    roomId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room',  // Room being rated
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

const HotelRating = mongoose.model('hotelRating', hotelRatingSchema); // Use consistent naming
module.exports = HotelRating;
