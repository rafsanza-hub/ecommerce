const AuthService = require('./auth.service');
const ApiResponse = require('../../utils/response');

class AuthController {
  async register(req, res) {
    try {
      const { username, password, email, fullName } = req.body;
      if (!username || !password || !email) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'Username, password, and email are required' }
        ], 400);
      }
      const result = await AuthService.register(username, password, email, fullName);
      return ApiResponse.success(res, result, 'User registered successfully', null, 201);
    } catch (error) {
      const errorCode = error.message.includes('registered') ? 'DUPLICATE_ENTRY' : 'REGISTRATION_FAILED';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], 400);
    }
  }

  async login(req, res) {
    try {
      const { usernameOrEmail, password } = req.body;
      if (!usernameOrEmail || !password) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'Username/email and password are required' }
        ], 400);
      }
      const result = await AuthService.login(usernameOrEmail, password);
      return ApiResponse.success(res, result, 'Login successful');
    } catch (error) {
      const errorCode = error.message === 'Invalid password' ? 'INVALID_CREDENTIALS' : 'USER_NOT_FOUND';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], 401);
    }
  }

  async logout(req, res) {
    try {
      // JWT stateless, logout hanya beri tahu client
      return ApiResponse.success(res, null, 'Logout successful');
    } catch (error) {
      return ApiResponse.error(res, error.message, [{ code: 'LOGOUT_FAILED', detail: error.message }], 500);
    }
  }
}

module.exports = new AuthController();