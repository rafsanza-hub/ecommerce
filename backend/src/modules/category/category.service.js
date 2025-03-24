const Category = require('./category.model');

class CategoryService {
  async createCategory(name, description) {
    try {
      const category = new Category({ name, description });
      await category.save();
      return category;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async getCategories() {
    try {
      const categories = await Category.find();
      return categories;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new CategoryService();
