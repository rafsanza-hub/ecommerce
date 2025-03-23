require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const productRoutes = require('./src/modules/product/product.routes');
const connectDB = require('./src/config/database'); 

const app = express();
app.use(express.json());
connectDB();

// Jalankan server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
