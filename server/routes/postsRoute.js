const express = require('express');
const router = express.Router();
const Baggage = require('../models/Baggage');
const User = require('../models/user');
const Wallet = require('../models/Wallet');

// Fetch posts by flight number
router.get('/:flightNumber', async (req, res) => {
    try {
        const baggages = await Baggage.find({ flightNumber: req.params.flightNumber }).lean();
        const userIds = baggages.map(baggage => baggage.user.toString());
        const users = await User.find({ _id: { $in: userIds } }).lean();
        const wallets = await Wallet.find({ userId: { $in: userIds } }).lean();

        const posts = baggages.map(baggage => {
            const user = users.find(u => u._id.toString() === baggage.user.toString());
            const wallet = wallets.find(w => w.userId.toString() === baggage.user.toString());
            const transaction = wallet ? wallet.transactions.find(t => t.baggageId.toString() === baggage._id.toString()) : null;
            const amountDeposited = transaction ? transaction.amountDeposited : 0;
            const amountOffered = amountDeposited * 0.87;

            return {
                userName: `${user.profile.firstName} ${user.profile.lastName}`,
                weight: baggage.weight,
                description: baggage.description,
                pictureUrl: baggage.pictures[0], // Assuming there is at least one picture
                amount: amountOffered.toFixed(2)
            };
        });

        res.json(posts);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});


module.exports = router;
