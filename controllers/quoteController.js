const Quote = require('../models/Quote');

// Curated list of famous Indian quotes for region-based recommendations
const indianQuotes = [
  {
    quote: "Dream, dream, dream. Dreams transform into thoughts and thoughts result in action.",
    author: "Dr. A.P.J. Abdul Kalam",
    year: "1998",
    category: "Inspiration"
  },
  {
    quote: "Be the change that you wish to see in the world.",
    author: "Mahatma Gandhi",
    year: "1913",
    category: "Wisdom"
  },
  {
    quote: "Arise, awake, and stop not until the goal is reached.",
    author: "Swami Vivekananda",
    year: "1897",
    category: "Motivation"
  },
  {
    quote: "You cannot cross the sea merely by standing and staring at the water.",
    author: "Rabindranath Tagore",
    year: "1916",
    category: "Life"
  },
  {
    quote: "The mind is everything. What you think you become.",
    author: "Gautama Buddha",
    year: "500 BC",
    category: "Wisdom"
  },
  {
    quote: "Education is the best friend. An educated person is respected everywhere. Education beats the beauty and the youth.",
    author: "Chanakya",
    year: "300 BC",
    category: "Wisdom"
  },
  {
    quote: "You have to dream before your dreams can come true.",
    author: "Dr. A.P.J. Abdul Kalam",
    year: "2002",
    category: "Inspiration"
  },
  {
    quote: "In a gentle way, you can shake the world.",
    author: "Mahatma Gandhi",
    year: "1942",
    category: "Peace"
  },
  {
    quote: "Believe in yourself and the world will be at your feet.",
    author: "Swami Vivekananda",
    year: "1895",
    category: "Motivation"
  },
  {
    quote: "Faith is the bird that feels the light when the dawn is still dark.",
    author: "Rabindranath Tagore",
    year: "1912",
    category: "Hope"
  },
  {
    quote: "If you want to shine like a sun, first burn like a sun.",
    author: "Dr. A.P.J. Abdul Kalam",
    year: "2006",
    category: "Success"
  },
  {
    quote: "Strength is life, weakness is death.",
    author: "Swami Vivekananda",
    year: "1899",
    category: "Wisdom"
  },
  {
    quote: "The weak can never forgive. Forgiveness is the attribute of the strong.",
    author: "Mahatma Gandhi",
    year: "1931",
    category: "Peace"
  },
  {
    quote: "Truth is one, the sages speak of it by many names.",
    author: "Rigveda",
    year: "1500 BC",
    category: "Philosophy"
  },
  {
    quote: "You have the right to work, but never to the fruit of work.",
    author: "Bhagavad Gita",
    year: "400 BC",
    category: "Wisdom"
  }
];

// Local fallback quotes
let inMemoryQuotes = [
  {
    _id: "demo_1",
    quote: "The only limit to our realization of tomorrow is our doubts of today.",
    author: "Franklin D. Roosevelt",
    year: "1945",
    category: "Inspiration",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    _id: "demo_2",
    quote: "The purpose of our lives is to be happy.",
    author: "Dalai Lama",
    year: "2001",
    category: "Life",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    _id: "demo_3",
    quote: "Life is what happens when you're busy making other plans.",
    author: "John Lennon",
    year: "1980",
    category: "Life",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    _id: "demo_4",
    quote: "Get busy living or get busy dying.",
    author: "Stephen King",
    year: "1982",
    category: "Motivation",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    _id: "demo_5",
    quote: "You only live once, but if you do it right, once is enough.",
    author: "Mae West",
    year: "1937",
    category: "Wisdom",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

// @desc    Get all quotes
// @route   GET /quotes
// @access  Public
exports.getQuotes = async (req, res) => {
  try {
    const { category, author } = req.query;

    if (process.env.USE_IN_MEMORY_DB === 'true') {
      let filtered = [...inMemoryQuotes, ...indianQuotes];
      if (category) {
        filtered = filtered.filter(q => q.category.toLowerCase().includes(category.toLowerCase()));
      }
      if (author) {
        filtered = filtered.filter(q => q.author.toLowerCase().includes(author.toLowerCase()));
      }
      return res.status(200).json({
        success: true,
        count: filtered.length,
        data: filtered,
      });
    }

    const filter = {};
    if (category) filter.category = new RegExp(category, 'i');
    if (author) filter.author = new RegExp(author, 'i');

    const quotes = await Quote.find(filter).sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: quotes.length,
      data: quotes,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error: Unable to fetch quotes',
      message: error.message,
    });
  }
};

// @desc    Get a single random quote (supports region weight and web API integration)
// @route   GET /quotes/random
// @access  Public
exports.getRandomQuote = async (req, res) => {
  try {
    const country = req.query.country || '';
    
    // Check if the user is from India and apply 65% probability for Indian Quotes
    const isIndia = country.toUpperCase() === 'IN';
    const pickLocalIndian = isIndia && Math.random() < 0.65;
    
    if (pickLocalIndian) {
      const randomIndex = Math.floor(Math.random() * indianQuotes.length);
      const selected = indianQuotes[randomIndex];
      return res.status(200).json({
        success: true,
        data: {
          _id: "in_" + randomIndex + "_" + Math.random().toString(36).substr(2, 4),
          ...selected,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      });
    }

    // Fetch from Web (ZenQuotes public REST API)
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 3500); // 3.5 seconds timeout
      
      const webResponse = await fetch('https://zenquotes.io/api/random', { signal: controller.signal });
      clearTimeout(timeoutId);

      if (webResponse.ok) {
        const json = await webResponse.json();
        if (json && json[0] && json[0].q) {
          return res.status(200).json({
            success: true,
            data: {
              _id: "web_" + Math.random().toString(36).substr(2, 9),
              quote: json[0].q,
              author: json[0].a || 'Unknown',
              year: 'Web',
              category: 'Global',
              createdAt: new Date().toISOString(),
              updatedAt: new Date().toISOString()
            }
          });
        }
      }
    } catch (e) {
      console.warn("Public Quotes API request failed, falling back to local datasets:", e.message);
    }

    // Fallback: Pick a random quote from our local arrays if API request fails
    if (process.env.USE_IN_MEMORY_DB === 'true') {
      const pool = [...inMemoryQuotes, ...indianQuotes];
      const randomIndex = Math.floor(Math.random() * pool.length);
      return res.status(200).json({
        success: true,
        data: pool[randomIndex],
      });
    }

    const count = await Quote.countDocuments();
    if (count === 0) {
      const pool = [...inMemoryQuotes, ...indianQuotes];
      const randomIndex = Math.floor(Math.random() * pool.length);
      return res.status(200).json({
        success: true,
        data: pool[randomIndex]
      });
    }

    const randomQuotes = await Quote.aggregate([{ $sample: { size: 1 } }]);
    res.status(200).json({
      success: true,
      data: randomQuotes[0],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error: Unable to fetch random quote',
      message: error.message,
    });
  }
};

// @desc    Create a new quote
// @route   POST /quotes
// @access  Public
exports.createQuote = async (req, res) => {
  try {
    const { quote, author, year, category } = req.body;

    if (!quote || !author) {
      return res.status(400).json({
        success: false,
        error: 'Please provide both a quote text and an author',
      });
    }

    if (process.env.USE_IN_MEMORY_DB === 'true') {
      const newQuote = {
        _id: "demo_" + (inMemoryQuotes.length + 1) + "_" + Math.random().toString(36).substr(2, 4),
        quote,
        author,
        year: year || 'Unknown',
        category: category || 'General',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      inMemoryQuotes.unshift(newQuote);
      return res.status(201).json({
        success: true,
        data: newQuote,
      });
    }

    const newQuote = await Quote.create({
      quote,
      author,
      year: year || 'Unknown',
      category: category || 'General',
    });

    res.status(201).json({
      success: true,
      data: newQuote,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error: Unable to create quote',
      message: error.message,
    });
  }
};

// @desc    Update a quote by ID
// @route   PUT /quotes/:id
// @access  Public
exports.updateQuote = async (req, res) => {
  try {
    const { quote, author, year, category } = req.body;

    if (process.env.USE_IN_MEMORY_DB === 'true') {
      const idx = inMemoryQuotes.findIndex(q => q._id === req.params.id);
      if (idx === -1) {
        return res.status(404).json({
          success: false,
          error: `Quote not found with ID of ${req.params.id}`,
        });
      }
      inMemoryQuotes[idx] = {
        ...inMemoryQuotes[idx],
        quote: quote || inMemoryQuotes[idx].quote,
        author: author || inMemoryQuotes[idx].author,
        year: year || inMemoryQuotes[idx].year,
        category: category || inMemoryQuotes[idx].category,
        updatedAt: new Date().toISOString()
      };
      return res.status(200).json({
        success: true,
        data: inMemoryQuotes[idx],
      });
    }

    let existingQuote = await Quote.findById(req.params.id);
    if (!existingQuote) {
      return res.status(404).json({
        success: false,
        error: `Quote not found with ID of ${req.params.id}`,
      });
    }

    existingQuote = await Quote.findByIdAndUpdate(
      req.params.id,
      { quote, author, year, category },
      { new: true, runValidators: true }
    );

    res.status(200).json({
      success: true,
      data: existingQuote,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error: Unable to update quote',
      message: error.message,
    });
  }
};

// @desc    Delete a quote by ID
// @route   DELETE /quotes/:id
// @access  Public
exports.deleteQuote = async (req, res) => {
  try {
    if (process.env.USE_IN_MEMORY_DB === 'true') {
      const idx = inMemoryQuotes.findIndex(q => q._id === req.params.id);
      if (idx === -1) {
        return res.status(404).json({
          success: false,
          error: `Quote not found with ID of ${req.params.id}`,
        });
      }
      inMemoryQuotes.splice(idx, 1);
      return res.status(200).json({
        success: true,
        data: {},
        message: 'Quote deleted successfully',
      });
    }

    const quote = await Quote.findById(req.params.id);
    if (!quote) {
      return res.status(404).json({
        success: false,
        error: `Quote not found with ID of ${req.params.id}`,
      });
    }

    await Quote.findByIdAndDelete(req.params.id);
    res.status(200).json({
      success: true,
      data: {},
      message: 'Quote deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Server Error: Unable to delete quote',
      message: error.message,
    });
  }
};
