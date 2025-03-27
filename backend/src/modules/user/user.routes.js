const express = require('express');
const router = express.Router();
const userController = require('./user.controller');
const verifyToken = require('../../middleware/auth');

router.get('/me', verifyToken, userController.getCurrentUser);

module.exports = router;