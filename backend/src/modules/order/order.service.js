const Order = require('./order.model');
const CartService = require('../cart/cart.service');

class OrderService {
  async createOrder(userId, shippingAddress) {
    const cart = await CartService.getCart(userId);
    if (!cart || cart.items.length === 0) throw new Error('Cart is empty');

    const order = new Order({
      user: userId,
      items: cart.items.map(item => ({
        product: item.product._id, // Pastikan ID produk dari populate
        quantity: item.quantity,
        price: item.price
      })),
      total: cart.total,
      shippingAddress
    });

    const savedOrder = await order.save();

    // Kosongkan cart setelah order dibuat
    cart.items = [];
    cart.total = 0;
    await cart.save();

    return savedOrder;
  }

  async getOrders(userId) {
    return await Order.find({ user: userId, isActive: true })
      .populate('items.product', 'name price imageUrl')
      .populate('user', 'username email')
      .sort({ orderDate: -1 }); // Urutkan dari terbaru
  }

  async getOrder(orderId, userId) {
    const order = await Order.findOne({ _id: orderId, user: userId, isActive: true })
      .populate('items.product', 'name price imageUrl')
      .populate('user', 'username email');
    if (!order) throw new Error('Order not found');
    return order;
  }
}

module.exports = new OrderService();