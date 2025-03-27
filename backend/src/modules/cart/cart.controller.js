const CartService = require('./cart.service');
const ApiResponse = require('../../utils/response');

class CartController {
  async createCart(req, res) {
    try {
      const userId = req.userId;
      const cart = await CartService.createCart(userId);
      const responseData = {
        id: cart._id,
        user: cart.user,
        items: cart.items,
        total: cart.total,
        createdAt: cart.createdAt
      };
      return ApiResponse.success(res, responseData, 'Cart created successfully', null, 201);
    } catch (error) {
      const statusCode = error.message.includes('exists') ? 409 : 500;
      const errorCode = error.message.includes('exists') ? 'DUPLICATE_ENTRY' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async getCart(req, res) {
    try {
      const userId = req.userId;
      const cart = await CartService.getCart(userId);
      const responseData = {
        id: cart._id,
        user: {
          id: cart.user._id,
          username: cart.user.username,
          email: cart.user.email
        },
        items: cart.items.map(item => ({
          product: {
            id: item.product._id,
            name: item.product.name,
            price: item.product.price,
            imageUrl: item.product.imageUrl
          },
          quantity: item.quantity,
          price: item.price
        })),
        total: cart.total,
        createdAt: cart.createdAt,
        updatedAt: cart.updatedAt
      };
      return ApiResponse.success(res, responseData, 'Cart retrieved successfully');
    } catch (error) {
      const statusCode = error.message === 'Cart not found' ? 404 : 500;
      const errorCode = error.message === 'Cart not found' ? 'CART_NOT_FOUND' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async addItem(req, res) {
    try {
      const userId = req.userId;
      const { productId, quantity = 1 } = req.body;
      if (!productId) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'productId is required' }
        ], 400);
      }
      if (!Number.isInteger(quantity) || quantity < 1) {
        return ApiResponse.error(res, 'Invalid quantity', [
          { code: 'INVALID_INPUT', detail: 'Quantity must be a positive integer' }
        ], 400);
      }
      const cart = await CartService.addItem(userId, productId, quantity);
      const responseData = {
        id: cart._id,
        items: cart.items.map(item => ({
          product: item.product,
          quantity: item.quantity,
          price: item.price
        })),
        total: cart.total,
        updatedAt: cart.updatedAt
      };
      return ApiResponse.success(res, responseData, 'Item added to cart successfully');
    } catch (error) {
      const statusCode = error.message.includes('not found') ? 404 : error.message.includes('stock') ? 400 : 500;
      const errorCode = error.message.includes('not found')
        ? 'PRODUCT_NOT_FOUND'
        : error.message.includes('stock')
        ? 'INSUFFICIENT_STOCK'
        : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async removeItem(req, res) {
    try {
      const userId = req.userId;
      const { productId } = req.body;
      if (!productId) {
        return ApiResponse.error(res, 'Missing required fields', [
          { code: 'MISSING_FIELDS', detail: 'productId is required' }
        ], 400);
      }
      const cart = await CartService.removeItem(userId, productId);
      const responseData = {
        id: cart._id,
        items: cart.items.map(item => ({
          product: item.product,
          quantity: item.quantity,
          price: item.price
        })),
        total: cart.total,
        updatedAt: cart.updatedAt
      };
      return ApiResponse.success(res, responseData, 'Item removed from cart successfully');
    } catch (error) {
      const statusCode = error.message.includes('not found') ? 404 : 500;
      const errorCode = error.message.includes('Cart')
        ? 'CART_NOT_FOUND'
        : error.message.includes('Item')
        ? 'ITEM_NOT_FOUND'
        : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }
}

module.exports = new CartController();