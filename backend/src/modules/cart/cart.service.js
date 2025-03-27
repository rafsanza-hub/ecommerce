const Cart = require('./cart.model');
const Product = require('../product/product.model');

class CartService {
  async createCart(userId) {
    const existingCart = await Cart.findOne({ user: userId });
    if (existingCart) throw new Error('Cart already exists for this user');
    const cart = new Cart({ user: userId, items: [], total: 0 });
    return await cart.save();
  }

  async getCart(userId) {
    const cart = await Cart.findOne({ user: userId, isActive: true })
      .populate('items.product', 'name price imageUrl')
      .populate('user', 'username email');
    if (!cart) throw new Error('Cart not found');
    return cart;
  }

  async addItem(userId, productId, quantity) {
    let cart = await Cart.findOne({ user: userId, isActive: true });
    if (!cart) {
      cart = new Cart({ user: userId, items: [], total: 0 });
    }

    const product = await Product.findById(productId);
    if (!product || !product.isActive) throw new Error('Product not found or inactive');
    if (product.stock < quantity) throw new Error('Insufficient stock');

    const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);
    if (itemIndex > -1) {
      cart.items[itemIndex].quantity += quantity;
    } else {
      cart.items.push({ product: productId, quantity, price: product.price });
    }

    cart.total = cart.items.reduce((acc, item) => {
      return acc + item.price * item.quantity;
    }, 0);

    return await cart.save();
  }

  async removeItem(userId, productId) {
    const cart = await Cart.findOne({ user: userId, isActive: true });
    if (!cart) throw new Error('Cart not found');

    const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);
    if (itemIndex === -1) throw new Error('Item not found in cart');

    cart.items.splice(itemIndex, 1);
    cart.total = cart.items.reduce((acc, item) => acc + item.price * item.quantity, 0);

    return await cart.save();
  }
}

module.exports = new CartService();