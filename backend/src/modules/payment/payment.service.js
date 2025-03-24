const Payment = require('./payment.model');
const midtransClient = require('midtrans-client');
const Order = require('../order/order.model');

class PaymentService {
  constructor() {
    this.snap = new midtransClient.Snap({
      isProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true',
      serverKey: process.env.MIDTRANS_SERVER_KEY,
      clientKey: process.env.MIDTRANS_CLIENT_KEY
    });

    if (!process.env.MIDTRANS_SERVER_KEY || !process.env.MIDTRANS_CLIENT_KEY) {
      throw new Error('Midtrans Server Key atau Client Key tidak ditemukan');
    }
    console.log('Midtrans Snap initialized');
  }

  async createPayment(orderId, paymentType) {
    try {
      console.log('Received orderId:', orderId);

      // Validasi Order
      const order = await Order.findById(orderId);
      if (!order) throw new Error('Pesanan tidak ditemukan');
      if (order.status !== 'pending') throw new Error('Pesanan sudah diproses');
      if (order.payment) throw new Error('Pembayaran untuk pesanan ini sudah ada');

      // Gunakan order.total sebagai amount
      const amount = order.total;
      if (!amount || isNaN(amount) || amount <= 0) {
        throw new Error('Jumlah pembayaran tidak valid');
      }

      // Parameter untuk Midtrans
      const parameter = {
        transaction_details: {
          order_id: orderId.toString(),
          gross_amount: Number(amount)
        },
        credit_card: paymentType === 'credit_card' ? { secure: true } : undefined,
        item_details: order.items.map(item => ({
          id: item.product.toString(),
          price: Number(item.price),
          quantity: Number(item.quantity),
          name: 'Product Item' // Ganti dengan nama produk kalau ada
        }))
      };

      // Validasi gross_amount vs item_details
      const itemTotal = parameter.item_details.reduce(
        (sum, item) => sum + item.price * item.quantity,
        0
      );
      if (itemTotal !== parameter.transaction_details.gross_amount) {
        console.error(`Gross amount mismatch. Expected: ${parameter.transaction_details.gross_amount}, Item total: ${itemTotal}`);
        throw new Error('Gross amount tidak sama dengan total item_details');
      }

      // Buat transaksi di Midtrans
      const midtransTransaction = await this.snap.createTransaction(parameter);
      const transactionId = midtransTransaction.token;
      const paymentUrl = midtransTransaction.redirect_url;

      // Simpan pembayaran
      const payment = new Payment({
        order: orderId,
        transactionId,
        paymentType,
        amount,
        status: 'pending',
        paymentUrl
      });
      await payment.save();

      // Update Order
      order.payment = payment._id;
      await order.save();

      return payment;
    } catch (error) {
      console.error('Error in createPayment:', error);
      throw new Error(
        error.httpStatusCode
          ? `Midtrans API error. HTTP status code: ${error.httpStatusCode}. Response: ${JSON.stringify(error.ApiResponse)}`
          : error.message
      );
    }
  }

  async handlePaymentCallback(req) {
    try {
      const notification = req.body;
      const { order_id, transaction_status, fraud_status } = notification;

      const payment = await Payment.findOne({ order: order_id });
      if (!payment) throw new Error('Pembayaran tidak ditemukan');

      let newStatus = payment.status;
      if (transaction_status === 'capture' || transaction_status === 'settlement') {
        newStatus = fraud_status === 'accept' ? 'success' : 'pending';
      } else if (transaction_status === 'deny' || transaction_status === 'cancel' || transaction_status === 'expire') {
        newStatus = transaction_status === 'expire' ? 'expired' : 'failed';
      } else if (transaction_status === 'pending') {
        newStatus = 'pending';
      }

      payment.status = newStatus;
      await payment.save();

      const order = await Order.findById(payment.order);
      if (newStatus === 'success') order.status = 'processing';
      else if (newStatus === 'failed' || newStatus === 'expired') order.status = 'cancelled';
      await order.save();

      return payment;
    } catch (error) {
      console.error('Error in handlePaymentCallback:', error);
      throw new Error(error.message);
    }
  }

  async getPayment(orderId) {
    try {
      const payment = await Payment.findOne({ order: orderId });
      if (!payment) throw new Error('Pembayaran tidak ditemukan');
      return payment;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new PaymentService();