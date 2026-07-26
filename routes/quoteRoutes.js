const express = require('express');
const router = express.Router();
const {
  getQuotes,
  getRandomQuote,
  createQuote,
  updateQuote,
  deleteQuote,
} = require('../controllers/quoteController');

// Random endpoint must be declared BEFORE :id wildcard route
router.get('/random', getRandomQuote);

router.route('/')
  .get(getQuotes)
  .post(createQuote);

router.route('/:id')
  .put(updateQuote)
  .delete(deleteQuote);

module.exports = router;
