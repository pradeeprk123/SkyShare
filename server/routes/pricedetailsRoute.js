const express = require('express');
const verifyToken = require('../middleware/verifyToken');
const Flight = require('../models/Flight');

const router = express.Router();

router.get('/details/:flightNumber', verifyToken, async (req, res) => {
    try {
        const flight = await Flight.findOne({ flightNumber: req.params.flightNumber });
        if (!flight) {
            return res.status(404).json({ message: 'Flight not found' });
        }
        // Ensure conversion to number before sending the response
        res.json({
            distanceKm: parseFloat(flight.distanceKm),
            durationHrs: parseFloat(flight.durationHrs)
        });
    } catch (error) {
        console.error('Error fetching flight details:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;
