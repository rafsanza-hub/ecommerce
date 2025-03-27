const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const Auth = require('./auth.model');
const UserService = require('../user/user.service');

class AuthService {
  async register(username, password, email) {
    try {
      const auth = new Auth({ username, password, email });
      await auth.save();

      // Membuat user di module user
      await UserService.createUser(username, email);

      // Generate JWT
      const token = jwt.sign({ id: auth._id }, process.env.JWT_SECRET, {
        expiresIn: '24h' // Masa berlaku 24 jam
      });

      return { message: 'User created!', token: token };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async login(usernameOrEmail, password) {
    try {
      const auth = await Auth.findOne({
        $or: [{ username: usernameOrEmail }, { email: usernameOrEmail }],
      });

      if (!auth) {
        throw new Error('User not found!');
      }

      const isPasswordValid = await auth.comparePassword(password);

      if (!isPasswordValid) {
        throw new Error('Invalid password!');
      }

      // Generate JWT
      const token = jwt.sign({ id: auth._id }, process.env.JWT_SECRET, {
        expiresIn: '24h' // Masa berlaku 24 jam
      });

      return { message: 'Login successful!', token: token };
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new AuthService();
