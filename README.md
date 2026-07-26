# QuoteVerse Backend (API Service)

This is the production-ready REST API for the **QuoteVerse** (Quote Duniya) Random Quote Generator application. It is built using Node.js, Express.js, and MongoDB, following Clean Architecture principles (Separated Models, Controllers, Configuration, and Routes).

---

## Features

- **RESTful Endpoints**: Full CRUD for administrators and public fetch queries.
- **Random Selection**: High-performance MongoDB Aggregation pipeline (`$sample`) to retrieve real random quotes.
- **Robust Error Handling**: Standardized JSON responses for all requests.
- **Database Seeding**: Built-in seeding script to populate quotes automatically.
- **CORS Configured**: Ready to securely interact with the Flutter frontend on Web and Mobile environments.

---

## Folder Structure

```text
quoteverse-backend/
├── config/
│   └── db.js            # MongoDB Mongoose connection
├── controllers/
│   └── quoteController.js # API Route business logic
├── models/
│   └── Quote.js         # Mongoose schema for Quote collection
├── routes/
│   └── quoteRoutes.js   # Route-to-controller mapping
├── .env.example         # Template for environmental variables
├── .env                 # Local variables (git ignored)
├── package.json         # Dependencies & scripts
├── seed.js              # Database initialization scripts
└── server.js            # Server entrypoint
```

---

## Requirements

- **Node.js** (v18.0.0 or higher)
- **MongoDB** (Local instance or MongoDB Atlas Connection String)

---

## Installation & Setup

1. **Clone & Navigate**:
   ```bash
   cd quoteverse-backend
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Configure Environment Variables**:
   Create a `.env` file in the root of the backend directory (or copy `.env.example`):
   ```bash
   cp .env.example .env
   ```
   Modify `.env` to point to your MongoDB Instance:
   ```env
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/quoteverse
   ```

---

## Running the Server

- **Start in Development Mode** (auto-reloads on changes using Nodemon):
  ```bash
  npm run dev
  ```
- **Start in Production Mode**:
  ```bash
  npm start
  ```

---

## Seeding the Database

To bootstrap your MongoDB database with sample, premium quotes, run:
```bash
npm run seed
```

---

## API Documentation

All routes are prefixed with `/quotes` (or mounted directly).

### 1. Get All Quotes
- **Endpoint**: `GET /quotes`
- **Description**: Returns a list of all quotes in descending order of creation. Can filter using query parameters.
- **Query Params (Optional)**:
  - `category` (string, case-insensitive partial match)
  - `author` (string, case-insensitive partial match)
- **Response**:
  ```json
  {
    "success": true,
    "count": 1,
    "data": [
      {
        "_id": "60d0fe4f5311236168a109ca",
        "quote": "Your time is limited, so don't waste it living someone else's life.",
        "author": "Steve Jobs",
        "year": "2005",
        "category": "Inspiration",
        "createdAt": "2026-07-21T15:00:00.000Z",
        "updatedAt": "2026-07-21T15:00:00.000Z"
      }
    ]
  }
  ```

### 2. Get a Random Quote
- **Endpoint**: `GET /quotes/random`
- **Description**: Fetches one random quote from the collection.
- **Response**:
  ```json
  {
    "success": true,
    "data": {
      "_id": "60d0fe4f5311236168a109ca",
      "quote": "Your time is limited, so don't waste it living someone else's life.",
      "author": "Steve Jobs",
      "year": "2005",
      "category": "Inspiration",
      "createdAt": "2026-07-21T15:00:00.000Z",
      "updatedAt": "2026-07-21T15:00:00.000Z"
    }
  }
  ```

### 3. Create a Quote
- **Endpoint**: `POST /quotes`
- **Headers**: `Content-Type: application/json`
- **Body**:
  ```json
  {
    "quote": "To be or not to be, that is the question.",
    "author": "William Shakespeare",
    "year": "1603",
    "category": "Wisdom"
  }
  ```
- **Response** (201 Created):
  ```json
  {
    "success": true,
    "data": {
      "quote": "To be or not to be, that is the question.",
      "author": "William Shakespeare",
      "year": "1603",
      "category": "Wisdom",
      "_id": "60d0fe4f5311236168a109cb",
      "createdAt": "2026-07-21T15:10:00.000Z",
      "updatedAt": "2026-07-21T15:10:00.000Z"
    }
  }
  ```

### 4. Update a Quote
- **Endpoint**: `PUT /quotes/:id`
- **Headers**: `Content-Type: application/json`
- **Body**: Any field you want to modify (e.g. `quote`, `author`, `year`, `category`).
- **Response**: Returns the updated Quote document.

### 5. Delete a Quote
- **Endpoint**: `DELETE /quotes/:id`
- **Response**:
  ```json
  {
    "success": true,
    "data": {},
    "message": "Quote deleted successfully"
  }
  ```

---

## Future Scope

- **Authentication**: Secure POST/PUT/DELETE routes using JSON Web Tokens (JWT) for admin authentication.
- **Analytics**: Track and log popular categories or most shared quotes.
- **Pagination**: Implement cursor-based pagination for querying massive quote lists.
