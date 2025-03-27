const express = require('express');
const router = express.Router();
const OrderController = require('./order.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, OrderController.createOrder);
router.get('/', verifyToken, OrderController.getOrders);
router.get('/:orderId', verifyToken, OrderController.getOrder);

module.exports = router;