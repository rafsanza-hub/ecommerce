const express = require('express');
const router = express.Router();
const orderController = require('./order.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, orderController.createOrder);
router.get('/', verifyToken, orderController.getOrders);
router.get('/:orderId', verifyToken, orderController.getOrder);

module.exports = router;
