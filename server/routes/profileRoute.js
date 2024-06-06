const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');
const User = require('../models/user');

router.put('/update', verifyToken, async (req, res) => {
    const { profileData } = req.body;  // Make sure this matches the key sent from Flutter

    if (!profileData) {
        return res.status(400).json({ message: 'Profile data is required' });
    }

    try {
        const { userId } = req.userData;
        const updatedUser = await User.findOneAndUpdate(
            { _id: userId },
            { $set: { profile: profileData } },
            { new: true }
        );

        if (!updatedUser) {
            return res.status(404).json({ message: 'User not found' });
        }

        return res.status(200).json({ message: 'Profile updated successfully', profile: updatedUser.profile });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/isProfileComplete', verifyToken, async (req, res) => {
    try {
        const { userId } = req.userData;
        const user = await User.findById(userId);
        const isComplete = user.profile
            && user.profile.firstName
            && user.profile.lastName
            && user.profile.phoneNumber
            && user.profile.country
            && typeof user.profile.age === 'number'
            && user.profile.gender;

        res.status(200).json({ isProfileComplete: Boolean(isComplete) });
    } catch (error) {
        res.status(500).json({ message: 'Internal server error' });
    }
});


module.exports = router;
