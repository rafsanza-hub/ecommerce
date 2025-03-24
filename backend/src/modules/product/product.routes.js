const express = require('express');
const router = express.Router();
const {
    createProduct,
    getProducts,
    updateProduct,
    deleteProduct,
  } = require('./product.controller');
const verifyToken = require('../../middleware/auth');

// (POST /api/products)
router.post('/', verifyToken, createProduct);

// (GET /api/products)
router.get('/', verifyToken, getProducts);

// (PUT /api/products/:id)
router.put('/:id', verifyToken, updateProduct);

// (DELETE /api/products/:id)
router.delete('/:id', verifyToken, deleteProduct);

module.exports = router;
