const Category = require('./category.model');

class CategoryService {
  async createCategory(categoryData) {
    const { name, description } = categoryData;
    if (!name) throw new Error('Category name is required');
    const existingCategory = await Category.findOne({ $or: [{ name }, { slug: name.toLowerCase().replace(/\s+/g, '-') }] });
    if (existingCategory) throw new Error('Category name or slug already exists');
    const category = new Category({ name, description });
    return await category.save();
  }

  async getCategories() {
    return await Category.find({ isActive: true }).select('name description slug createdAt updatedAt');
  }

  async getCategoryById(categoryId) {
    const category = await Category.findById(categoryId);
    if (!category || !category.isActive) throw new Error('Category not found');
    return category;
  }
}

module.exports = new CategoryService();