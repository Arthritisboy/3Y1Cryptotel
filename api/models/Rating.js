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
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',  // User who submitted the rating
        required: true
    },
    roomId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room',
        required: false  // Room being rated (optional, since we now support restaurantId too)
    },
    restaurantId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Restaurant',
        required: false  // Restaurant being rated (optional)
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

// Custom validation to ensure either roomId or restaurantId is provided
ratingSchema.pre('validate', function(next) {
    if (!this.roomId && !this.restaurantId) {
        return next(new Error('Either roomId or restaurantId must be provided.'));
    }
    next();
});

const Rating = mongoose.model('Rating', ratingSchema);
module.exports = Rating;
