const Product = require('./product.model');

class ProductService {
  async createProduct(productData) {
    const product = new Product(productData);
    return await product.save();
  }

  async getAllProducts() {
    return await Product.find({ isActive: true }).populate('category', 'name');
  }

  async getProductById(productId) {
    const product = await Product.findById(productId).populate('category', 'name');
    if (!product || !product.isActive) throw new Error('Product not found');
    return product;
  }

  async updateProduct(productId, updateData) {
    const product = await Product.findByIdAndUpdate(productId, updateData, {
      new: true,
      runValidators: true
    });
    if (!product || !product.isActive) throw new Error('Product not found');
    return product;
  }

  async deleteProduct(productId) {
    const product = await Product.findByIdAndUpdate(
      productId,
      { isActive: false },
      { new: true }
    );
    if (!product || !product.isActive) throw new Error('Product not found');
    return product;
  }
}

module.exports = new ProductService();