const express = require('express');
const router = express.Router();
const paymentController = require('./payment.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, paymentController.createPayment);
router.post('/callback', paymentController.handlePaymentCallback);
router.get('/:orderId', verifyToken, paymentController.getPayment);

module.exports = router;
