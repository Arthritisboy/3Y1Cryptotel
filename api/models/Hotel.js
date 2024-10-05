const mongoose = require('mongoose');
const Room = require('./Room');
const Rating = require('./Rating');

const hotelSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    rooms: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room'
    }],
    rating: {
        type: Number,
        default: 0  // Store the calculated average of ratings
    }
});

// Virtual to calculate average rating from all rooms' ratings
hotelSchema.virtual('averageRating').get(async function() {
    await this.populate('rooms');  // Make sure rooms are populated
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
});

// Pre-save hook to update hotel rating before saving
hotelSchema.pre('save', async function(next) {
    this.rating = await this.averageRating;
    next();
});

const Hotel = mongoose.model('Hotel', hotelSchema);
module.exports = Hotel;
