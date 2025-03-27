const mongoose = require("mongoose");

const paymentSchema = new mongoose.Schema(
  {
    order: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Order", // Sesuaikan dengan nama model Order
      required: [true, "Order is required"],
      unique: true, // Satu order satu pembayaran
    },
    transactionId: {
      type: String,
      required: [true, "Transaction ID is required"],
      unique: true,
      trim: true,
    },
    paymentType: {
      type: String,
      required: [true, "Payment type is required"],
      enum: ["credit_card", "bank_transfer", "e_wallet", "qris"], // Contoh tipe pembayaran
      trim: true,
    },
    amount: {
      type: Number,
      required: [true, "Amount is required"],
      min: [0, "Amount cannot be negative"],
      validate: {
        validator: Number.isFinite,
        message: "Amount must be a valid number",
      },
    },
    status: {
      type: String,
      enum: ["pending", "success", "failed", "expired"],
      default: "pending",
    },
    paymentUrl: {
      type: String,
      trim: true,
      match: [/^https?:\/\/[^\s$.?#].[^\s]*$/, "Invalid URL format"],
      default: null,
    },
    paymentDate: {
      type: Date,
      default: Date.now,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
);

module.exports = mongoose.model("Payment", paymentSchema);
