const Order = require('./order.model');
const CartService = require('../cart/cart.service');

class OrderService {
  async createOrder(userId, shippingAddress) {
    try {
      const cart = await CartService.getCart(userId);
      if (!cart || cart.items.length === 0) {
        throw new Error('Cart is empty');
      }

      const order = new Order({
        user: userId,
        items: cart.items.map(item => ({
          product: item.product._id,
          quantity: item.quantity,
          price: item.product.price // Use the price from the cart item
        })),
        total: cart.total,
        shippingAddress: shippingAddress
      });

      await order.save();

      // Clear the cart after creating the order
      cart.items = [];
      cart.total = 0;
      await cart.save();

      return order;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async getOrders(userId) {
    try {
      const orders = await Order.find({ user: userId }).populate('items.product');
      return orders;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async getOrder(orderId) {
    try {
      const order = await Order.findById(orderId).populate('items.product');
      return order;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new OrderService();
