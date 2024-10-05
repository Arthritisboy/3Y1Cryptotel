const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
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
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',  // User who submitted the rating
        required: true
    },
    room: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room',  // Room being rated
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

const Rating = mongoose.model('Rating', ratingSchema);
module.exports = Rating;
