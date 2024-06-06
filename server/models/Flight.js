const mongoose = require('mongoose');

const flightSchema = new mongoose.Schema({
    flightNumber: String,
    airline: String,
    origin: String,
    destination: String,
    departureDate: Date,
    departureTime: Date,
    arrivalDate: Date,
    arrivalTime: Date,
    passengers: [{
        name: String,
        ticketNumber: String,
        seatNumber: String,
        class: String
    }],
    distanceKm: { type: String, get: v => parseFloat(v), set: v => parseFloat(v) },
    durationHrs: { type: String, get: v => parseFloat(v), set: v => parseFloat(v) }
});

const Flight = mongoose.model('Flight', flightSchema);
module.exports = Flight;
