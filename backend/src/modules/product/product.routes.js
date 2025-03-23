const express = require('express');
const router = express.Router();
const {
    createProduct,
    getProducts,
    updateProduct,
    deleteProduct,
  } = require('./product.controller');

// (POST /api/products)
router.post('/', createProduct);

// (GET /api/products)
router.get('/', getProducts);

// (PUT /api/products/:id)
router.put('/:id', updateProduct);

// (DELETE /api/products/:id)
router.delete('/:id', deleteProduct);

module.exports = router;
