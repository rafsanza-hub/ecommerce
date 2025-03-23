const Product = require('./product.model');

// Tambah produk baru
const addProduct = async (productData) => {
  const product = new Product(productData);
  return await product.save();
};

// Ambil semua produk
const getAllProducts = async () => {
  return await Product.find();
};

// Update produk berdasarkan ID
const updateProductById = async (productId, updateData) => {
  return await Product.findByIdAndUpdate(productId, updateData, { new: true });
};

// Hapus produk berdasarkan ID
const deleteProductById = async (productId) => {
  return await Product.findByIdAndDelete(productId);
};

module.exports = {
  addProduct,
  getAllProducts,
  updateProductById,
  deleteProductById,
};
