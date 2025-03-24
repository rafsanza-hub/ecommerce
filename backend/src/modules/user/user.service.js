const User = require('./user.model');

class UserService {
  async createUser(username, email) {
    try {
      const user = new User({ username, email });
      await user.save();
      return user;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new UserService();
