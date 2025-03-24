const express = require('express');
const router = express.Router();
const authController = require('./auth.controller');
const verifyToken = require('../../middleware/auth');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/logout', verifyToken, authController.logout);

module.exports = router;
