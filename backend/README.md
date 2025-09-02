# 🚀 Habit Tracker Backend API

A modern, fast, and scalable backend API for the Habit Tracker application built with FastAPI, SQLAlchemy, and PostgreSQL.

## ✨ Features

- **🔐 JWT Authentication** - Secure user authentication with access and refresh tokens
- **📊 Database Models** - Comprehensive data models for habits, users, categories, and analytics
- **🔄 RESTful API** - Clean, documented API endpoints following REST principles
- **🛡️ Security** - Password hashing, token validation, and CORS protection
- **📈 Analytics** - Built-in analytics and streak tracking
- **⏰ Reminders** - Smart reminder system for habit tracking
- **🧪 Testing** - Comprehensive test suite with pytest
- **📚 Auto-documentation** - Interactive API docs with Swagger UI

## 🏗️ Architecture

```
backend/
├── app/
│   ├── api/           # API endpoints and routers
│   ├── core/          # Core functionality (security, config)
│   ├── models/        # Database models
│   ├── schemas/       # Pydantic schemas for validation
│   ├── services/      # Business logic services
│   ├── config.py      # Configuration settings
│   ├── database.py    # Database connection and setup
│   └── main.py        # FastAPI application entry point
├── scripts/           # Database scripts and utilities
├── tests/             # Test files
├── requirements.txt   # Python dependencies
└── README.md         # This file
```

## 🚀 Quick Start

### 1. Prerequisites

- Python 3.8+
- PostgreSQL (or SQLite for development)
- Redis (optional, for caching)

### 2. Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Environment Setup

```bash
# Copy environment template
cp env_example.txt .env

# Edit .env with your configuration
DATABASE_URL=postgresql://username:password@localhost:5432/habit_tracker_db
SECRET_KEY=your-super-secret-key-here
```

### 4. Database Setup

```bash
# Initialize database with tables and default data
python scripts/init_db.py
```

### 5. Run the API

```bash
# Development mode with auto-reload
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production mode
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### 6. Access the API

- **API Documentation**: http://localhost:8000/docs
- **ReDoc Documentation**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 🗄️ Database Models

### Core Entities

- **Users** - User accounts and authentication
- **Categories** - Habit categories (Health, Productivity, Learning, etc.)
- **Habits** - Individual habits with frequency and tracking
- **Completions** - Daily habit completion records
- **Streaks** - Habit streak tracking and analytics
- **Reminders** - Smart reminder system

### Relationships

```
User (1) ←→ (N) Habits
User (1) ←→ (N) Completions
User (1) ←→ (N) Reminders
User (1) ←→ (N) Streaks
Category (1) ←→ (N) Habits
Habit (1) ←→ (N) Completions
Habit (1) ←→ (N) Reminders
Habit (1) ←→ (N) Streaks
```

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication:

1. **Register** - Create a new user account
2. **Login** - Authenticate and receive access/refresh tokens
3. **Protected Routes** - Include `Authorization: Bearer <token>` header
4. **Token Refresh** - Use refresh token to get new access token

### Example Usage

```bash
# Register
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","username":"user","password":"password123"}'

# Login
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email_or_username":"user@example.com","password":"password123"}'

# Use protected endpoint
curl -X GET "http://localhost:8000/api/v1/habits" \
  -H "Authorization: Bearer <your-access-token>"
```

## 📊 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - User logout

### Users
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update user profile
- `DELETE /api/v1/users/me` - Delete user account

### Habits
- `GET /api/v1/habits` - List user habits
- `POST /api/v1/habits` - Create new habit
- `GET /api/v1/habits/{id}` - Get habit details
- `PUT /api/v1/habits/{id}` - Update habit
- `DELETE /api/v1/habits/{id}` - Delete habit

### Categories
- `GET /api/v1/categories` - List all categories
- `POST /api/v1/categories` - Create custom category
- `PUT /api/v1/categories/{id}` - Update category
- `DELETE /api/v1/categories/{id}` - Delete category

### Completions
- `POST /api/v1/completions` - Mark habit as completed
- `GET /api/v1/completions` - Get completion history
- `PUT /api/v1/completions/{id}` - Update completion
- `DELETE /api/v1/completions/{id}` - Delete completion

### Analytics
- `GET /api/v1/analytics/overview` - User overview statistics
- `GET /api/v1/analytics/habits/{id}` - Habit-specific analytics
- `GET /api/v1/analytics/streaks` - Streak analytics
- `GET /api/v1/analytics/trends` - Habit completion trends

## 🧪 Testing

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app

# Run specific test file
pytest tests/test_auth.py

# Run with verbose output
pytest -v
```

## 🚀 Deployment

### Docker

```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Environment Variables

```bash
# Production settings
ENVIRONMENT=production
DEBUG=False
DATABASE_URL=postgresql://user:pass@prod-db:5432/habit_tracker
SECRET_KEY=your-production-secret-key
```

## 📚 API Documentation

The API includes comprehensive documentation:

- **Interactive Docs**: Visit `/docs` for Swagger UI
- **ReDoc**: Visit `/redoc` for alternative documentation
- **OpenAPI Schema**: Available at `/openapi.json`

## 🔧 Configuration

Key configuration options in `app/config.py`:

- Database connection strings
- JWT token settings
- CORS origins
- Email settings
- Redis configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:

- Create an issue in the repository
- Check the API documentation
- Review the test files for examples

## 🎯 Roadmap

- [ ] Real-time notifications with WebSockets
- [ ] Advanced analytics and insights
- [ ] Social features and sharing
- [ ] Mobile push notifications
- [ ] Integration with external services
- [ ] Advanced reminder algorithms
- [ ] Habit templates and challenges
- [ ] Export/import functionality

---

**Happy Habit Tracking! 🎉**
