const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    bookingType: {
        type: String,
        required: true,
        enum: ['HotelBooking', 'RestaurantBooking'], // Specify allowed types
    },
    hotelId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Hotel',
    },
    roomId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Room',
    },
    restaurantId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Restaurant',
    },
    tableNumber: {
        type: Number,
        validate: {
            validator: function(value) {
                // Only validate if bookingType is 'RestaurantBooking'
                return this.bookingType === 'RestaurantBooking' ? value != null : true;
            },
            message: 'Table number is required for Restaurant Booking.',
        },
    },
    checkInDate: {
        type: Date,
        required: true,
    },
    checkOutDate: {
        type: Date,
        required: true,
    },
    totalPrice: {
        type: Number,
    },
    status: {
        type: String,
        enum: ['pending', 'confirmed', 'cancelled', 'rejected'],
        default: 'pending',
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

// Create the Booking model
const Booking = mongoose.model('Booking', bookingSchema);
module.exports = Booking;
