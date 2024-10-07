const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
    roomNumber: {
        type: String,
        required: true
    },
    roomImage: {
        type: String,
    },
    type: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    capacity: {
        type: Number,
        required: true
    },
    availability: {
        type: Boolean,
        default: true
    },
    ratings: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Rating'  // Array of ratings
    }]
});

// const Room = mongoose.model('Room', roomSchema); forgot git pull mb

//   roomId: {
//     type: String,
//     required: true,
//   },
//   imagePath: {
//     type: String,
//   },
//   roomType: {
//     type: String,
//     required: true,
//   },
//   pricePerNight: {
//     type: Number,
//     required: true,
//   },
//   availability: {
//     type: Boolean,
//     required: true,
//     default: true,
//   },
//   amenities: {
//     type: [String],
//     required: true,
//   },
//   maxOccupancy: {
//     type: Number,
//     required: true,
//   },
// });

const Room = mongoose.model('Room', roomSchema);
module.exports = Room;