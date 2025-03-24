require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const productRoutes = require('./modules/product/product.routes');
const authRoutes = require('./modules/auth/auth.routes');
const userRoutes = require('./modules/user/user.routes');
const categoryRoutes = require('./modules/category/category.routes');
const cartRoutes = require('./modules/cart/cart.routes');
const orderRoutes = require('./modules/order/order.routes');
const paymentRoutes = require('./modules/payment/payment.routes');
const connectDB = require('./config/database');

const app = express();
app.use(express.json());
connectDB();

// Routes
app.use('/api/products', productRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/carts', cartRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);

// Jalankan server
const PORT =  5000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
