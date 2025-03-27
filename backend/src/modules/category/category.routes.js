const express = require('express');
const router = express.Router();
const CategoryController = require('./category.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, CategoryController.createCategory);
router.get('/', verifyToken, CategoryController.getCategories);

module.exports = router;