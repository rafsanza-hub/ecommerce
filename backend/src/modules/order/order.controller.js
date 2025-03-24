const OrderService = require('./order.service');

class OrderController {
  async createOrder(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const { shippingAddress } = req.body;
      const order = await OrderService.createOrder(userId, shippingAddress);
      res.status(201).json(order);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getOrders(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const orders = await OrderService.getOrders(userId);
      res.status(200).json(orders);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getOrder(req, res) {
    try {
      const { orderId } = req.params;
      const order = await OrderService.getOrder(orderId);
      res.status(200).json(order);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new OrderController();
