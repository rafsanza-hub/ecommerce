class ApiResponse {
    static success(res, data = null, message = null, meta = null, statusCode = 200) {
      const response = { status: 'success', data };
      if (message) response.message = message;
      if (meta) response.meta = meta;
      return res.status(statusCode).json(response);
    }
  
    static error(res, message, errors = [], statusCode = 500) {
      const response = { status: 'error', message };
      if (errors.length > 0) response.errors = errors;
      return res.status(statusCode).json(response);
    }
  }
  
  module.exports = ApiResponse;