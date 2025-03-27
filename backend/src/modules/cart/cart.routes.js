const express = require('express');
const router = express.Router();
const CartController = require('./cart.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, CartController.createCart);
router.get('/', verifyToken, CartController.getCart);
router.post('/item', verifyToken, CartController.addItem);
router.delete('/item', verifyToken, CartController.removeItem);

module.exports = router;