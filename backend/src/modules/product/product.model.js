const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Product name is required"],
      trim: true,
      minlength: [3, "Product name must be at least 3 characters"],
      maxlength: [100, "Product name cannot exceed 100 characters"],
    },
    price: {
      type: Number,
      required: [true, "Price is required"],
      min: [0, "Price cannot be negative"],
      validate: {
        validator: Number.isFinite,
        message: "Price must be a valid number",
      },
    },
    description: {
      type: String,
      required: [true, "Description is required"],
      trim: true,
      maxlength: [1000, "Description cannot exceed 1000 characters"],
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: [true, "Category is required"],
    },
    stock: {
      type: Number,
      default: 0,
      min: [0, "Stock cannot be negative"],
      validate: {
        validator: Number.isInteger,
        message: "Stock must be an integer",
      },
    },
    imageUrl: {
      type: String,
      trim: true,
      match: [/^https?:\/\/[^\s$.?#].[^\s]*$/, "Invalid URL format"],
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    sku: {
      type: String,
      unique: true,
      trim: true,
      maxlength: [50, "SKU cannot exceed 50 characters"],
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

module.exports = mongoose.model("Product", productSchema); // Tunggal sesuai konvensi Mongoose
