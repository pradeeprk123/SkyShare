const express = require('express');
const multer = require('multer');
const path = require('path');
const verifyToken = require('../middleware/verifyToken');
const Baggage = require('../models/Baggage'); // Assuming you have a model Baggage

const router = express.Router();

// Set up file storage
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
        const newFilename = `${Date.now()}-${file.originalname}`;
        cb(null, newFilename);
    }
});

const upload = multer({ storage: storage });

router.post('/', verifyToken, upload.array('pictures', 5), async (req, res) => {
    const { weight, description, flightNumber } = req.body;
    const pictures = req.files.map(file => file.path);
    try {
        const baggage = new Baggage({
            weight,
            description,
            flightNumber,
            pictures,
            user: req.userData.userId
        });
        const savedBaggage = await baggage.save();
        res.status(200).json({ message: 'Baggage details saved successfully', baggageId: savedBaggage._id });
    } catch (error) {
        console.error('Error saving baggage details:', error);
        res.status(500).json({ message: 'Failed to save baggage details' });
    }
});

module.exports = router;
