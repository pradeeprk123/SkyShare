const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
    transactionId: { type: String, required: true },
    dateTime: { type: Date, default: Date.now },
    amountDeposited: { type: Number, required: true },
    baggageId: { type: mongoose.Schema.Types.ObjectId, ref: 'Baggage' }  // Linking to baggage
}, { _id: false });

const walletSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', unique: true },
    totalAmount: { type: Number, default: 0 },
    transactions: [transactionSchema]
});

const Wallet = mongoose.model('Wallet', walletSchema);
module.exports = Wallet;
