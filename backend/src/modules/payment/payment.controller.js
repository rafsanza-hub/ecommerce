const PaymentService = require('./payment.service');
const Order = require('../order/order.model');

class PaymentController {
  async createPayment(req, res) {
    try {
      const userId = req.userId;
      const { orderId, paymentType } = req.body;
      if (!orderId || !paymentType) {
        return res.status(400).json({ message: 'orderId dan paymentType diperlukan' });
      }

      const order = await Order.findOne({ _id: orderId, user: userId });
      if (!order) return res.status(404).json({ message: 'Pesanan tidak ditemukan atau bukan milik Anda' });

      const payment = await PaymentService.createPayment(orderId, paymentType);
      res.status(201).json({ message: 'Pembayaran dibuat', payment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async handlePaymentCallback(req, res) {
    try {
      const payment = await PaymentService.handlePaymentCallback(req);
      res.status(200).json({ message: 'Notifikasi diterima', payment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getPayment(req, res) {
    try {
      const userId = req.userId;
      const { orderId } = req.params;
      const payment = await PaymentService.getPayment(orderId);
      if (!payment) return res.status(404).json({ message: 'Pembayaran tidak ditemukan' });
      res.status(200).json({ message: 'Data pembayaran', payment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new PaymentController();