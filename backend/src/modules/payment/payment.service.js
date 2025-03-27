const Payment = require('./payment.model');
const Order = require('../order/order.model');
const midtransClient = require('midtrans-client');

class PaymentService {
  constructor() {
    this.snap = new midtransClient.Snap({
      isProduction: process.env.MIDTRANS_IS_PRODUCTION === 'true',
      serverKey: process.env.MIDTRANS_SERVER_KEY,
      clientKey: process.env.MIDTRANS_CLIENT_KEY
    });

    if (!process.env.MIDTRANS_SERVER_KEY || !process.env.MIDTRANS_CLIENT_KEY) {
      throw new Error('Midtrans configuration is missing');
    }
  }

  async createPayment(userId, orderId, paymentType) {
    const order = await Order.findOne({ _id: orderId, user: userId });
    if (!order) throw new Error('Order not found or not owned by user');
    if (order.status !== 'pending') throw new Error('Order is already processed');
    if (order.payment) throw new Error('Payment already exists for this order');

    const amount = order.total;
    if (!amount || amount <= 0) throw new Error('Invalid payment amount');

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
        name: 'Product Item' // Bisa diganti dengan nama produk dari populate
      }))
    };

    const itemTotal = parameter.item_details.reduce((sum, item) => sum + item.price * item.quantity, 0);
    if (itemTotal !== parameter.transaction_details.gross_amount) {
      throw new Error('Gross amount does not match item total');
    }

    const midtransTransaction = await this.snap.createTransaction(parameter);
    const transactionId = midtransTransaction.token;
    const paymentUrl = midtransTransaction.redirect_url;

    const payment = new Payment({
      order: orderId,
      transactionId,
      paymentType,
      amount,
      paymentUrl
    });
    await payment.save();

    order.payment = payment._id;
    await order.save();

    return payment;
  }

  async handlePaymentCallback(notification) {
    const { order_id, transaction_status, fraud_status } = notification;

    const payment = await Payment.findOne({ order: order_id });
    if (!payment) throw new Error('Payment not found');

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
  }

  async getPayment(orderId, userId) {
    const payment = await Payment.findOne({ order: orderId })
      .populate('order', 'total status shippingAddress');
    if (!payment) throw new Error('Payment not found');
    const order = await Order.findOne({ _id: orderId, user: userId });
    if (!order) throw new Error('Order not found or not owned by user');
    return payment;
  }
}

module.exports = new PaymentService();