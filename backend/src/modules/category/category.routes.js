const express = require('express');
const router = express.Router();
const categoryController = require('./category.controller');
const verifyToken = require('../../middleware/auth');

router.post('/', verifyToken, categoryController.createCategory);
router.get('/', verifyToken, categoryController.getCategories);

module.exports = router;
