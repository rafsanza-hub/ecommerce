const mongoose = require( "mongoose");

// Schema Produk (Model MongoDB)
const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  stock: { type: Number, default: 0 },
  imageUrl: { type: String },
}, { timestamps: true }); 

module.exports = mongoose.model('Product', productSchema);
