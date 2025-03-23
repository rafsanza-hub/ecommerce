require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const productRoutes = require('./modules/product/product.routes');
const connectDB = require('./config/database'); 

const app = express();
app.use(express.json());
connectDB();

// Routes
app.use('/api/products', productRoutes); 

// Jalankan server
const PORT =  5000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
