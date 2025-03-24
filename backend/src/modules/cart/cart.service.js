const Cart = require('./cart.model');
const Product = require('../product/product.model');

class CartService {
  async createCart(userId) {
    const cart = await Cart.findOne({ user: userId });
    if (cart) {
      return cart;
    }
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
  
      // Cari produk dari database
      const product = await Product.findById(productId);
      if (!product) {
        throw new Error('Product not found');
      }
  
      const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);
  
      if (itemIndex > -1) {
        // Jika item sudah ada di keranjang, tambahkan jumlah
        cart.items[itemIndex].quantity += quantity;
      } else {
        // Tambahkan item baru ke keranjang
        cart.items.push({ product: productId, quantity });
      }
  
      // Hitung ulang total menggunakan loop biasa
      let total = 0;
      for (let item of cart.items) {
        const itemProduct = await Product.findById(item.product); // Ambil produk dari database
        total += itemProduct.price * item.quantity; // Hitung total berdasarkan harga dan jumlah item
      }
  
      cart.total = total; // Set total ke keranjang
      await cart.save(); // Simpan perubahan ke database
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
