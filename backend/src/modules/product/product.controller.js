const ProductService = require('./product.service');
const ApiResponse = require('../../utils/response');

class ProductController {
  async createProduct(req, res) {
    try {
      const { name, price, description, category, stock, imageUrl, sku } = req.body;
      if (!name || !price || !description || !category) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'Name, price, description, and category are required' }
        ], 400);
      }
      const product = await ProductService.createProduct(req.body);
      const responseData = {
        id: product._id,
        name: product.name,
        price: product.price,
        description: product.description,
        category: product.category,
        stock: product.stock,
        imageUrl: product.imageUrl,
        sku: product.sku,
        createdAt: product.createdAt
      };
      return ApiResponse.success(res, responseData, 'Product created successfully', null, 201);
    } catch (error) {
      const statusCode = error.message.includes('duplicate') ? 409 : 500;
      const errorCode = error.message.includes('duplicate') ? 'DUPLICATE_ENTRY' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async getProducts(req, res) {
    try {
      const products = await ProductService.getAllProducts();
      const responseData = products.map(product => ({
        id: product._id,
        name: product.name,
        price: product.price,
        description: product.description,
        category: product.category,
        stock: product.stock,
        imageUrl: product.imageUrl,
        sku: product.sku,
        createdAt: product.createdAt
      }));
      return ApiResponse.success(res, responseData, 'Products retrieved successfully');
    } catch (error) {
      return ApiResponse.error(res, error.message, [{ code: 'INTERNAL_SERVER_ERROR', detail: error.message }], 500);
    }
  }

  async updateProduct(req, res) {
    try {
      const productId = req.params.id;
      const updatedProduct = await ProductService.updateProduct(productId, req.body);
      const responseData = {
        id: updatedProduct._id,
        name: updatedProduct.name,
        price: updatedProduct.price,
        description: updatedProduct.description,
        category: updatedProduct.category,
        stock: updatedProduct.stock,
        imageUrl: updatedProduct.imageUrl,
        sku: updatedProduct.sku,
        updatedAt: updatedProduct.updatedAt
      };
      return ApiResponse.success(res, responseData, 'Product updated successfully');
    } catch (error) {
      const statusCode = error.message === 'Product not found' ? 404 : 500;
      const errorCode = error.message === 'Product not found' ? 'PRODUCT_NOT_FOUND' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async deleteProduct(req, res) {
    try {
      const productId = req.params.id;
      await ProductService.deleteProduct(productId);
      return ApiResponse.success(res, null, 'Product deleted successfully');
    } catch (error) {
      const statusCode = error.message === 'Product not found' ? 404 : 500;
      const errorCode = error.message === 'Product not found' ? 'PRODUCT_NOT_FOUND' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }
}

module.exports = new ProductController();