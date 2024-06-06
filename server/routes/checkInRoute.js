const express = require('express');
const router = express.Router();
const Flight = require('../models/Flight'); // Adjust this path to where your Flight model is located
const verifyToken = require('../middleware/verifyToken'); // Ensure the token verification middleware is correctly implemented

// POST endpoint for flight check-in
router.post('/', verifyToken, async (req, res) => {
    console.log("Received check-in data:", req.body);  // Log the entire body to debug incoming data

    // Extracting fields from the body for clarity and easier handling
    const { flightNumber, airline, departureDate, name, ticketNumber, seatNumber, class: classOfService } = req.body;

    // Log the extracted fields to ensure data is being processed correctly
    console.log(`Processing check-in for:
        Flight Number: ${flightNumber}
        Airline: ${airline}
        Departure Date: ${departureDate}
        Passenger Name: ${name}
        Ticket Number: ${ticketNumber}
        Seat Number: ${seatNumber}
        Class: ${classOfService}`);

    try {
        // Parse date to start of the day in UTC
        const parsedDate = new Date(departureDate);
        parsedDate.setUTCHours(0, 0, 0, 0);

        const flight = await Flight.findOne({
            flightNumber,
            airline,
            'passengers.name': name,
            'passengers.ticketNumber': ticketNumber,
            'passengers.seatNumber': seatNumber,
            'passengers.class': classOfService,  // Ensure class comparison is case-insensitive
            departureDate: parsedDate  // Search by the corrected date
        });


        // Log the result of the database query
        if (flight) {
            console.log("Passenger found and verified:", flight);
            res.status(200).json({ valid: true, message: "Passenger verified." });
        } else {
            console.log("Passenger not found with provided data.");
            res.status(404).json({ valid: false, message: "Passenger not found." });
        }
    } catch (error) {
        // Log any errors that occur during the process
        console.error("Error during check-in process:", error);
        res.status(500).json({ valid: false, message: "Internal server error during check-in." });
    }
});

module.exports = router;
