const express = require('express');
const router = express.Router();
const cartController = require('./cart.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, cartController.createCart);
router.get('/', verifyToken, cartController.getCart);
router.post('/item', verifyToken, cartController.addItem);
router.delete('/item', verifyToken, cartController.removeItem);

module.exports = router;
