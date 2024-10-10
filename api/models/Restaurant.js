const mongoose = require('mongoose');

const raitingSchema = new mongoose.Schema({
    tableNumber: {
        type: String,
        required: true,
    },
    restaurantImage: {
        type: String,
    },
    name: {
        type: String,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    capacity: {
        type: Number,
        required: true,
    },
    availability: {
        type: Boolean,
        default: true,
    },
    ratings: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'RestaurantRating', // Array of ratings
    }, ],
});

const Restaurant = mongoose.model('Restaurant', raitingSchema);

module.exports = Restaurant;