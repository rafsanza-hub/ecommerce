const jwt = require('jsonwebtoken');
const User = require('../user/user.model');

class AuthService {
  async register(username, password, email, fullName) {
    const existingUser = await User.findOne({ $or: [{ username }, { email }] });
    if (existingUser) throw new Error('Username or email already registered');

    const user = new User({ username, password, email, fullName });
    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '24h' });
    return { user: { id: user._id, username, email, fullName }, token };
  }

  async login(usernameOrEmail, password) {
    const user = await User.findOne({
      $or: [{ username: usernameOrEmail }, { email: usernameOrEmail }]
    }).select('+password');
    if (!user) throw new Error('User not found');
    if (!(await user.comparePassword(password))) throw new Error('Invalid password');

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '24h' });
    return { user: { id: user._id, username: user.username, email: user.email }, token };
  }
}

module.exports = new AuthService();