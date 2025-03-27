const OrderService = require('./order.service');
const ApiResponse = require('../../utils/response');

class OrderController {
  async createOrder(req, res) {
    try {
      const userId = req.userId;
      const { shippingAddress } = req.body;
      if (!shippingAddress || !shippingAddress.street || !shippingAddress.city || !shippingAddress.postalCode || !shippingAddress.country) {
        return ApiResponse.error(res, 'Missing required shipping address fields', [
          { code: 'MISSING_FIELDS', detail: 'Street, city, postalCode, and country are required' }
        ], 400);
      }
      const order = await OrderService.createOrder(userId, shippingAddress);
      const responseData = {
        id: order._id,
        user: order.user,
        items: order.items.map(item => ({
          product: item.product,
          quantity: item.quantity,
          price: item.price
        })),
        total: order.total,
        shippingAddress: order.shippingAddress,
        orderDate: order.orderDate,
        status: order.status,
        createdAt: order.createdAt
      };
      return ApiResponse.success(res, responseData, 'Order created successfully', null, 201);
    } catch (error) {
      const statusCode = error.message.includes('empty') ? 400 : 500;
      const errorCode = error.message.includes('empty') ? 'CART_EMPTY' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }

  async getOrders(req, res) {
    try {
      const userId = req.userId;
      const orders = await OrderService.getOrders(userId);
      const responseData = orders.map(order => ({
        id: order._id,
        user: {
          id: order.user._id,
          username: order.user.username,
          email: order.user.email
        },
        items: order.items.map(item => ({
          product: {
            id: item.product._id,
            name: item.product.name,
            price: item.product.price,
            imageUrl: item.product.imageUrl
          },
          quantity: item.quantity,
          price: item.price
        })),
        total: order.total,
        shippingAddress: order.shippingAddress,
        orderDate: order.orderDate,
        status: order.status,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt
      }));
      return ApiResponse.success(res, responseData, 'Orders retrieved successfully');
    } catch (error) {
      return ApiResponse.error(res, error.message, [{ code: 'INTERNAL_SERVER_ERROR', detail: error.message }], 500);
    }
  }

  async getOrder(req, res) {
    try {
      const userId = req.userId;
      const { orderId } = req.params;
      const order = await OrderService.getOrder(orderId, userId);
      const responseData = {
        id: order._id,
        user: {
          id: order.user._id,
          username: order.user.username,
          email: order.user.email
        },
        items: order.items.map(item => ({
          product: {
            id: item.product._id,
            name: item.product.name,
            price: item.product.price,
            imageUrl: item.product.imageUrl
          },
          quantity: item.quantity,
          price: item.price
        })),
        total: order.total,
        shippingAddress: order.shippingAddress,
        orderDate: order.orderDate,
        status: order.status,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt
      };
      return ApiResponse.success(res, responseData, 'Order retrieved successfully');
    } catch (error) {
      const statusCode = error.message === 'Order not found' ? 404 : 500;
      const errorCode = error.message === 'Order not found' ? 'ORDER_NOT_FOUND' : 'INTERNAL_SERVER_ERROR';
      return ApiResponse.error(res, error.message, [{ code: errorCode, detail: error.message }], statusCode);
    }
  }
}

module.exports = new OrderController();