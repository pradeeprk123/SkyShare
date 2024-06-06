const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }, // For hashing
  profile: {
    firstName: String,
    lastName: String,
    country: String,
    phoneNumber: String,
    gender: String,
    age: Number,
  }
});

const User = mongoose.model('User', userSchema);
module.exports = User;