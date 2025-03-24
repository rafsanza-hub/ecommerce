const CategoryService = require('./category.service');

class CategoryController {
  async createCategory(req, res) {
    try {
      const { name, description } = req.body;
      const category = await CategoryService.createCategory(name, description);
      res.status(201).json(category);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getCategories(req, res) {
    try {
      const categories = await CategoryService.getCategories();
      res.status(200).json(categories);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new CategoryController();
