const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');
const quoteRoutes = require('./routes/quoteRoutes');

// Load environment variables
dotenv.config();

// Initialize Express App
const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json());

// API Welcome Route
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Welcome to the QuoteVerse (Quote Duniya) API',
    endpoints: {
      getAllQuotes: 'GET /quotes',
      getRandomQuote: 'GET /quotes/random',
      createQuote: 'POST /quotes',
      updateQuote: 'PUT /quotes/:id',
      deleteQuote: 'DELETE /quotes/:id',
    },
  });
});

// Mount Routes
app.use('/quotes', quoteRoutes);

// 404 Route handler
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
  });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'An internal server error occurred',
    message: err.message,
  });
});

// Listen
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running in production-ready mode on port ${PORT}`);
});
