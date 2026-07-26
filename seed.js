const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Quote = require('./models/Quote');

dotenv.config();

const quotes = [
  {
    quote: "The only limit to our realization of tomorrow is our doubts of today.",
    author: "Franklin D. Roosevelt",
    year: "1945",
    category: "Inspiration"
  },
  {
    quote: "The purpose of our lives is to be happy.",
    author: "Dalai Lama",
    year: "2001",
    category: "Life"
  },
  {
    quote: "Life is what happens when you're busy making other plans.",
    author: "John Lennon",
    year: "1980",
    category: "Life"
  },
  {
    quote: "Get busy living or get busy dying.",
    author: "Stephen King",
    year: "1982",
    category: "Motivation"
  },
  {
    quote: "You only live once, but if you do it right, once is enough.",
    author: "Mae West",
    year: "1937",
    category: "Wisdom"
  },
  {
    quote: "Many of life's failures are people who did not realize how close they were to success when they gave up.",
    author: "Thomas A. Edison",
    year: "1877",
    category: "Success"
  },
  {
    quote: "If you want to live a happy life, tie it to a goal, not to people or things.",
    author: "Albert Einstein",
    year: "1929",
    category: "Wisdom"
  },
  {
    quote: "Never let the fear of striking out keep you from playing the game.",
    author: "Babe Ruth",
    year: "1923",
    category: "Motivation"
  },
  {
    quote: "Money and success don't change people; they merely amplify what is already there.",
    author: "Will Smith",
    year: "2005",
    category: "Success"
  },
  {
    quote: "Your time is limited, so don't waste it living someone else's life.",
    author: "Steve Jobs",
    year: "2005",
    category: "Inspiration"
  },
  {
    quote: "Not how long, but how well you have lived is the main thing.",
    author: "Seneca",
    year: "54 AD",
    category: "Wisdom"
  },
  {
    quote: "In order to write about life first you must live it.",
    author: "Ernest Hemingway",
    year: "1952",
    category: "Life"
  },
  {
    quote: "The big lesson in life, baby, is never be scared of anyone or anything.",
    author: "Frank Sinatra",
    year: "1960",
    category: "Motivation"
  }
];

const seedQuotes = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/quoteverse');
    console.log('MongoDB Connected for Seeding...');

    // Clear existing collection
    await Quote.deleteMany();
    console.log('Existing quotes cleared.');

    // Insert seeds
    await Quote.insertMany(quotes);
    console.log('Sample quotes successfully seeded to database!');
    
    mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error(`Seeding error: ${error.message}`);
    process.exit(1);
  }
};

seedQuotes();
