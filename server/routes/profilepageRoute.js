const express = require('express');
const router = express.Router();
const User = require('../models/user');
const verifyToken = require('../middleware/verifyToken');

// Assuming `authenticate` is a middleware function that verifies the JWT
router.get('/profile/:email', verifyToken, async (req, res) => {
    const email = decodeURIComponent(req.params.email);
    try {
        const user = await User.findOne({ email: email }, 'profile email -_id');
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        const userProfile = {
            email: user.email,
            ...user.profile.toObject()
        };
        res.json(userProfile);
    } catch (error) {
        res.status(500).json({ message: 'Server error', error: error.message });
    }
});


module.exports = router;