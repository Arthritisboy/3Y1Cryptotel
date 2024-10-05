const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
  roomId: {
    type: String,
    required: true,
  },
  imagePath: {
    type: String,
  },
  roomType: {
    type: String,
    required: true,
  },
  pricePerNight: {
    type: Number,
    required: true,
  },
  availability: {
    type: Boolean,
    required: true,
    default: true,
  },
  amenities: {
    type: [String],
    required: true,
  },
  maxOccupancy: {
    type: Number,
    required: true,
  },
});

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;
