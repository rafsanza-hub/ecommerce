require('dotenv').config();

const express = require('express');
const connectDB = require('./config/database');

connectDB();

const app = express();

app.use(express.json());
app.use('/api/auth', require('./modules/auth/auth.routes'));
app.use('/api/users', require('./modules/user/user.routes'));
app.use('/api/products', require('./modules/product/product.routes'));
app.use('/api/categories', require('./modules/category/category.routes'));
app.use('/api/cart', require('./modules/cart/cart.routes'));


// Jalankan server
const PORT =  5000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
