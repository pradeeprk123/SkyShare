const express = require('express');
const router = express.Router();
const Chat = require('../models/chats');
const verifyToken = require('../middleware/verifyToken');

// Create a new chat
router.post('/', verifyToken, async (req, res) => {
    try {
        const { participants } = req.body;
        const chat = new Chat({ participants });
        await chat.save();
        res.status(201).json(chat);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get chat messages
router.get('/:chatId', verifyToken, async (req, res) => {
    try {
        const chat = await Chat.findById(req.params.chatId).populate('participants', 'profile.firstName profile.lastName').populate('messages.sender', 'profile.firstName profile.lastName');
        if (!chat) {
            return res.status(404).json({ message: 'Chat not found' });
        }
        res.json(chat);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Send a new message
router.post('/:chatId/messages', verifyToken, async (req, res) => {
    try {
        const { message } = req.body;
        const chat = await Chat.findByIdAndUpdate(
            req.params.chatId,
            { $push: { messages: { sender: req.user._id, message } } },
            { new: true }
        ).populate('messages.sender', 'profile.firstName profile.lastName');
        if (!chat) {
            return res.status(404).json({ message: 'Chat not found' });
        }
        res.json(chat);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

module.exports = router;