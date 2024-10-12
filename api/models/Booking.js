const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    bookingType: {
        type: String,
        required: true,
        enum: ['HotelBooking', 'RestaurantBooking'], // Specify allowed types
    },
    restaurantName: {
        type: String,
    },
    hotelName: {
        type: String,
    },
    roomName: {
        type: String,
    },
    userId: {
        type: String,
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
    fullName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
    },
    phoneNumber: {
        type: String,
        required: true,
    },
    address: {
        type: String,
        required: true,
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
    timeOfArrival: {
        type: Date,
        required: true,
    },
    timeOfDeparture: {
        type: Date,
    },
    totalPrice: {
        type: Number,
    },
    adult: {
        type: Number,
        required: true,
    },
    children: {
        type: Number,
        required: true,
    },
    status: {
        type: String,
        enum: ['pending', 'accepted', 'cancelled', 'rejected'],
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