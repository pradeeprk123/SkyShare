const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
    users: [String],
    messages: [{
        senderId: String,
        text: String,
        timestamp: { type: Date, default: Date.now }
    }]
});

module.exports = mongoose.model('Chat', chatSchema);
