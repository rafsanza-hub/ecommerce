const AuthService = require('./auth.service');

class AuthController {
  async register(req, res) {
    try {
      const { username, password, email } = req.body;
      const result = await AuthService.register(username, password, email);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async login(req, res) {
    try {
      const { usernameOrEmail, password } = req.body;
      const result = await AuthService.login(usernameOrEmail, password);
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async logout(req, res) {
    // Implementasi logika logout
    res.status(200).json({ message: 'Logout endpoint' });
  }
}

module.exports = new AuthController();
