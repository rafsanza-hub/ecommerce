const UserService = require('./user.service');
const ApiResponse = require('../../utils/response');

class UserController {
  async getCurrentUser(req, res) {
    try {
      const userId = req.userId;
      const user = await UserService.getUserById(userId);
      const responseData = {
        id: user._id,
        username: user.username,
        email: user.email,
        fullName: user.fullName,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      };
      return ApiResponse.success(res, responseData);
    } catch (error) {
      const statusCode = error.message === 'User not found' ? 404 : 500;
      const errorCode = error.message === 'User not found' ? 'USER_NOT_FOUND' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }
}

module.exports = new UserController();