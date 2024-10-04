const mongoose = require('mongoose');

const testSchema = new mongoose.Schema(
    {
        profile: {
            type: String,
            required: null
        }
    }
)
module.exports = mongoose.model('Test', testSchema);