const mongoose = require('mongoose');

const QuoteSchema = new mongoose.Schema(
  {
    quote: {
      type: String,
      required: [true, 'Please add a quote text'],
      trim: true,
    },
    author: {
      type: String,
      required: [true, 'Please add an author'],
      trim: true,
    },
    year: {
      type: String,
      trim: true,
      default: 'Unknown',
    },
    category: {
      type: String,
      trim: true,
      default: 'General',
    },
  },
  {
    timestamps: true, // Automatically manages createdAt and updatedAt fields
  }
);

module.exports = mongoose.model('Quote', QuoteSchema);
