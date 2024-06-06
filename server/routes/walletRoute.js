const express = require('express');
const router = express.Router();
const Wallet = require('../models/Wallet');
const verifyToken = require('../middleware/verifyToken');
const { v4: uuidv4 } = require('uuid');

async function ensureWallet(userId) {
    let wallet = await Wallet.findOne({ userId });
    if (!wallet) {
        wallet = new Wallet({ userId, totalAmount: 0, transactions: [] });
        await wallet.save();
    }
    return wallet;
}

router.get('/balance', verifyToken, async (req, res) => {
    console.log('User Data:', req.userData);  // Debugging line
    if (!req.userData || !req.userData.userId) {
        return res.status(400).json({ message: "User data is not available" });
    }
    const userId = req.userData.userId;
    try {
        const wallet = await ensureWallet(userId);
        res.json({ balance: wallet.totalAmount });
    } catch (err) {
        console.error('Error fetching wallet balance:', err);
        res.status(500).json({ message: 'Error fetching wallet balance', error: err.message });
    }
});


router.post('/add', verifyToken, async (req, res) => {
    const { amount, baggageId } = req.body;
    const userId = req.userData.userId;
    try {
        const wallet = await ensureWallet(userId);
        const transactionId = uuidv4();
        wallet.transactions.push({
            transactionId,
            dateTime: new Date(),
            amountDeposited: amount,
            baggageId // Include the baggageId in the transaction
        });
        wallet.totalAmount += amount;
        await wallet.save();
        res.json({ success: true, newBalance: wallet.totalAmount, transactionId });
    } catch (err) {
        console.error('Error adding to wallet:', err);
        res.status(500).json({ message: 'Error adding to wallet', error: err.message });
    }
});

module.exports = router;
