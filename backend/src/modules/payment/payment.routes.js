const express = require('express');
const router = express.Router();
const PaymentController = require('./payment.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, PaymentController.createPayment);
router.post('/callback', PaymentController.handlePaymentCallback); // Publik untuk Midtrans
router.get('/:orderId', verifyToken, PaymentController.getPayment);

module.exports = router;