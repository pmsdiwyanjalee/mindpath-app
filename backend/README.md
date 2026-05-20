# MindPath Backend API

A Node.js/Express backend API for the MindPath mental health mobile application.

## Features

- User authentication and authorization
- Counsellor management and verification
- Appointment scheduling
- Resource management
- Real-time chat functionality
- Admin dashboard with analytics

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: SQLite with Sequelize
- **Authentication**: JWT (JSON Web Tokens)
- **Validation**: express-validator
- **Password Hashing**: bcryptjs

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file in the backend directory with the following variables:
   ```bash
   PORT=5000
   DB_STORAGE=./database.sqlite
   JWT_SECRET=your_super_secret_jwt_key_here
   NODE_ENV=development
   ```

4. Initialize the local SQLite database:
   ```bash
   npm run db:init
   ```
   ```

   For development with auto-restart:
   ```bash
   npm run dev
   ```

The server will start on `http://localhost:5000`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users` - Get all users (admin only)

### Counsellors
- `GET /api/counsellors` - Get all verified counsellors
- `GET /api/counsellors/:id` - Get counsellor by ID
- `POST /api/counsellors` - Create counsellor profile
- `PUT /api/counsellors` - Update counsellor profile

### Appointments
- `GET /api/appointments` - Get user's appointments
- `POST /api/appointments` - Create appointment
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Delete appointment

### Resources
- `GET /api/resources` - Get published resources
- `GET /api/resources/:id` - Get resource by ID
- `POST /api/resources` - Create resource (admin/counsellor)
- `PUT /api/resources/:id` - Update resource
- `DELETE /api/resources/:id` - Delete resource
- `GET /api/resources/admin/all` - Get all resources (admin)

### Chat
- `GET /api/chat` - Get user's chats
- `GET /api/chat/:id` - Get chat by ID
- `POST /api/chat` - Create new chat
- `POST /api/chat/:id/messages` - Send message
- `PUT /api/chat/:id/read` - Mark messages as read

### Admin
- `GET /api/admin/analytics` - Get dashboard analytics
- `GET /api/admin/counsellors` - Manage counsellors
- `PUT /api/admin/counsellors/:id/verify` - Verify counsellor
- `GET /api/admin/users` - Manage users
- `PUT /api/admin/users/:id/status` - Update user status
- `GET /api/admin/support-tickets` - Get support tickets

## Data Models

### User
- Personal information, authentication, preferences

### Counsellor
- Professional details, verification status, availability

### Appointment
- Scheduling, status tracking, meeting details

### Resource
- Articles, guides, multimedia content

### Chat
- Real-time messaging between users and counsellors

### Database
- Local SQLite database stored at `./database.sqlite`
- Sequelize creates and syncs tables automatically on startup
- Use `npm run db:init` to create/synchronize the database tables before running the app

## Authentication

All protected routes require a JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

## Development

### Project Structure
```
backend/
├── models/          # Sequelize models
├── routes/          # API route handlers
├── middleware/      # Custom middleware
├── server.js        # Main application file
├── package.json     # Dependencies and scripts
└── .env            # Environment variables
```

### Adding New Features

1. Create/update models in `models/`
2. Add routes in `routes/`
3. Import and use routes in `server.js`
4. Update this README

## Deployment

1. Set up production SQLite database or another SQL database and update `DB_STORAGE` accordingly
2. Update `.env` with production values
3. Set `NODE_ENV=production`
4. Use a process manager like PM2
5. Set up reverse proxy with nginx

## MySQL / XAMPP Setup

If you want to use MySQL with XAMPP instead of SQLite:

1. Start XAMPP and activate `Apache` and `MySQL`.
2. Open phpMyAdmin and create a database named `mindpath`.
3. Import `backend/mysql_schema.sql` to create the tables.
4. (Optional) Import `backend/mysql_sample_data.sql` to add sample records.
5. Install the MySQL driver:
   ```bash
   cd backend
   npm install mysql2
   ```
6. Update `backend/config/database.js` to use the MySQL connection settings.
7. Update `backend/.env` with:
   ```env
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_NAME=mindpath
   DB_USER=root
   DB_PASSWORD=
   JWT_SECRET=your_jwt_secret_key_here
   NODE_ENV=development
   ```

## Contributing

1. Follow the existing code structure
2. Add proper error handling
3. Include input validation
4. Update documentation

## License

MIT License