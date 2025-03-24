const UserService = require('./user.service');

class UserController {
  async createUser(req, res) {
    try {
      const { username, email } = req.body;
      const user = await UserService.createUser(username, email);
      res.status(201).json(user);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new UserController();
