const CartService = require('./cart.service');

class CartController {
  async createCart(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const cart = await CartService.createCart(userId);
      res.status(201).json(cart);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getCart(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const cart = await CartService.getCart(userId);
      res.status(200).json(cart);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async addItem(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const { productId, quantity } = req.body;
      const cart = await CartService.addItem(userId, productId, quantity);
      res.status(200).json(cart);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async removeItem(req, res) {
    try {
      const userId = req.userId; // Assuming userId is attached to the request by the auth middleware
      const { productId } = req.body;
      const cart = await CartService.removeItem(userId, productId);
      res.status(200).json(cart);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new CartController();
