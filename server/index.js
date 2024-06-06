const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
// const http = require('http');
// const socketIo = require('socket.io');
// const Chat = require('./models/chats');
const authRoutes = require('./routes/authRoute');
const profileRoutes = require('./routes/profileRoute');
const checkinRoutes = require('./routes/checkInRoute');
const baggageRouter = require('./routes/baggagedetailsRoute');
const priceDetailsRoutes = require('./routes/pricedetailsRoute');
const walletRoutes = require('./routes/walletRoute');
const postsRoute = require('./routes/postsRoute');
// const profilepageRoutes = require('./routes/profilepageRoute');
// const chatRoutes = require('./routes/chatsRoute');

require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

const cors = require('cors');
app.use(cors());

// const server = http.createServer(app);
// const io = socketIo(server);


// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.log(err));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/checkin', checkinRoutes);

app.use('/uploads', express.static('uploads'));

app.use('/api/baggage', baggageRouter);

app.use('/api/flights', priceDetailsRoutes);

app.use('/api/wallet', walletRoutes);

app.use('/api/posts', postsRoute);

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// app.use('/api/profile', profileRoutes);

// app.use('/api/chats', chatRoutes);

// Route to create or fetch a chat room
// app.post('/chats', async (req, res) => {
//   const { users } = req.body;
//   let chat = await Chat.findOne({ users: { $all: users.sort() } });
//   if (!chat) {
//     chat = new Chat({ users, messages: [] });
//     await chat.save();
//   }
//   res.json(chat);
// });

// io.on('connection', (socket) => {
//   socket.on('joinChat', (chatId) => {
//     socket.join(chatId);
//   });

//   socket.on('sendMessage', async ({ chatId, senderId, text }) => {
//     const chat = await Chat.findById(chatId);
//     const message = { senderId, text, timestamp: new Date() };
//     chat.messages.push(message);
//     await chat.save();
//     io.to(chatId).emit('message', message);
//   });
// });


// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});