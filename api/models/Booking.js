const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  bookingType: {
    type: String,
    required: true,
    enum: ['HotelBooking', 'RestaurantBooking'], // Allowed booking types
  },
  restaurantName: String,
  hotelName: String,
  roomName: String,
  hotelImage: String,
  restaurantImage: String,
  userId: {
    type: String,
    required: true,
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
      validator: function (value) {
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
    validate: {
      validator: function (value) {
        return value > this.checkInDate;
      },
      message: 'Check-out date must be later than check-in date.',
    },
  },
  timeOfArrival: {
    type: Date,
    required: true,
  },
  timeOfDeparture: {
    type: Date,
    required: true,
  },
  totalPrice: Number,
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
    enum: ['pending', 'accepted', 'cancelled', 'rejected', 'done'],
    default: 'pending',
  },
  availability: {
    type: Boolean,
    default: false, // Default to false
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// ** Pre-save hook to set availability based on conditional logic **
bookingSchema.pre('save', function (next) {
  // Check both date and time conditions
  if (
    this.checkOutDate > this.checkInDate &&
    this.timeOfArrival < this.timeOfDeparture
  ) {
    this.availability = true;
  } else {
    this.availability = false;
  }
  next();
});

// Create the Booking model
const Booking = mongoose.model('Booking', bookingSchema);

module.exports = Booking;
