const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/quoteverse', {
      serverSelectionTimeoutMS: 2000 // Timeout quickly in 2 seconds if no MongoDB
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
    process.env.USE_IN_MEMORY_DB = 'false';
  } catch (error) {
    console.warn(`\n⚠️  MongoDB Connection Failed: ${error.message}`);
    console.warn('🚀 Falling back to premium IN-MEMORY DATABASE for demo/run mode!\n');
    process.env.USE_IN_MEMORY_DB = 'true';
  }
};

module.exports = connectDB;
