const CategoryService = require('./category.service');
const ApiResponse = require('../../utils/response');

class CategoryController {
  async createCategory(req, res) {
    try {
      const { name, description } = req.body;
      if (!name) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'Category name is required' }
        ], 400);
      }
      const category = await CategoryService.createCategory({ name, description });
      const responseData = {
        id: category._id,
        name: category.name,
        description: category.description,
        slug: category.slug,
        createdAt: category.createdAt
      };
      return ApiResponse.success(res, responseData, 'Category created successfully', null, 201);
    } catch (error) {
      const statusCode = error.message.includes('exists') ? 409 : 500;
      const errorCode = error.message.includes('exists') ? 'DUPLICATE_ENTRY' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async getCategories(req, res) {
    try {
      const categories = await CategoryService.getCategories();
      const responseData = categories.map(category => ({
        id: category._id,
        name: category.name,
        description: category.description,
        slug: category.slug,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt
      }));
      return ApiResponse.success(res, responseData, 'Categories retrieved successfully');
    } catch (error) {
      return ApiResponse.error(res, error.message, [{ code: 'INTERNAL_SERVER_ERROR', detail: error.message }], 500);
    }
  }
}

module.exports = new CategoryController();