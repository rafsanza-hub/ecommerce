const express = require('express');
const router = express.Router();
const ProductController = require('./product.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, ProductController.createProduct);
router.get('/', verifyToken, ProductController.getProducts);
router.put('/:id', verifyToken, ProductController.updateProduct);
router.delete('/:id', verifyToken, ProductController.deleteProduct);

module.exports = router;