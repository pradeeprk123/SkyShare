const mongoose = require('mongoose');

const baggageSchema = new mongoose.Schema({
    weight: { type: Number, required: true },
    description: { type: String, required: true },
    flightNumber: { type: String, required: true }, 
    pictures: [String],
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

module.exports = mongoose.model('Baggage', baggageSchema);
