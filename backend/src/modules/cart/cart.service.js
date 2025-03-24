const Cart = require('./cart.model');

class CartService {
  async createCart(userId) {
    try {
      const cart = new Cart({ user: userId, items: [], total: 0 });
      await cart.save();
      return cart;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async getCart(userId) {
    try {
      const cart = await Cart.findOne({ user: userId }).populate('items.product');
      return cart;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async addItem(userId, productId, quantity) {
    try {
      const cart = await Cart.findOne({ user: userId });
      if (!cart) {
        throw new Error('Cart not found');
      }

      const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);

      if (itemIndex > -1) {
        cart.items[itemIndex].quantity += quantity;
      } else {
        cart.items.push({ product: productId, quantity });
      }

      // Recalculate total
      cart.total = cart.items.reduce((acc, item) => acc + item.product.price * item.quantity, 0);

      await cart.save();
      return cart;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  async removeItem(userId, productId) {
    try {
      const cart = await Cart.findOne({ user: userId });
      if (!cart) {
        throw new Error('Cart not found');
      }

      const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);

      if (itemIndex > -1) {
        cart.items.splice(itemIndex, 1);
      }

      // Recalculate total
      cart.total = cart.items.reduce((acc, item) => acc + item.product.price * item.quantity, 0);

      await cart.save();
      return cart;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new CartService();
