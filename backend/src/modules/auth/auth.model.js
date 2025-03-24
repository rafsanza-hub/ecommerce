const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const authSchema = new mongoose.Schema({
  // Mendefinisikan field skema autentikasi
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  email: { type: String, required: true, unique: true },
});

// Hash password sebelum disimpan
authSchema.pre('save', async function(next) {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(this.password, salt);
    this.password = hashedPassword;
    next();
  } catch (error) {
    next(error);
  }
});

// Method untuk membandingkan password
authSchema.methods.comparePassword = async function(password) {
  try {
    return await bcrypt.compare(password, this.password);
  } catch (error) {
    throw new Error(error);
  }
};

module.exports = mongoose.model('Auth', authSchema);
