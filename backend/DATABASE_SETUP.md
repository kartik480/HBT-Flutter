# 🗄️ Database Setup Guide

This guide will help you set up the database for the Habit Tracker backend.

## 🎯 Database Options

### 1. SQLite (Development/Testing)
- **Pros**: Simple, no installation required, good for development
- **Cons**: Limited concurrent users, not suitable for production
- **Use Case**: Development, testing, small deployments

### 2. PostgreSQL (Production)
- **Pros**: Robust, scalable, ACID compliant, excellent performance
- **Cons**: Requires installation and configuration
- **Use Case**: Production, staging, team development

## 🚀 Quick Start with SQLite

### 1. Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 2. Run Database Initialization
```bash
python scripts/init_db.py
```

### 3. Start the Server
```bash
python run.py
# or
uvicorn app.main:app --reload
```

That's it! SQLite database will be created automatically in `./habit_tracker.db`

## 🐘 PostgreSQL Setup

### 1. Install PostgreSQL

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### macOS (with Homebrew)
```bash
brew install postgresql
brew services start postgresql
```

#### Windows
Download and install from [PostgreSQL official website](https://www.postgresql.org/download/windows/)

### 2. Create Database and User

```bash
# Connect to PostgreSQL as superuser
sudo -u postgres psql

# Create database
CREATE DATABASE habit_tracker_db;

# Create user
CREATE USER habit_user WITH PASSWORD 'your_secure_password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE habit_tracker_db TO habit_user;

# Exit
\q
```

### 3. Configure Environment

```bash
# Copy environment template
cp env_example.txt .env

# Edit .env file
DATABASE_URL=postgresql://habit_user:your_secure_password@localhost:5432/habit_tracker_db
```

### 4. Initialize Database

```bash
python scripts/init_db.py
```

## 🔧 Database Configuration

### Environment Variables

```bash
# SQLite (default)
DATABASE_URL=sqlite:///./habit_tracker.db

# PostgreSQL
DATABASE_URL=postgresql://username:password@localhost:5432/database_name

# PostgreSQL with SSL
DATABASE_URL=postgresql://username:password@localhost:5432/database_name?sslmode=require

# PostgreSQL with connection pooling
DATABASE_URL=postgresql://username:password@localhost:5432/database_name?pool_size=20&max_overflow=30
```

### Connection Parameters

- **username**: Database user
- **password**: User password
- **host**: Database host (localhost for local)
- **port**: Database port (5432 default for PostgreSQL)
- **database_name**: Name of your database

## 📊 Database Schema

### Tables Created

1. **users** - User accounts and profiles
2. **categories** - Habit categories
3. **habits** - Individual habits
4. **completions** - Habit completion records
5. **streaks** - Streak tracking
6. **reminders** - Reminder system

### Default Data

The initialization script creates:

- **8 Default Categories**: Health & Fitness, Productivity, Learning, etc.
- **Admin User**: admin@habittracker.com / admin123
- **Sample Habits** (optional): Morning Exercise, Reading, Meditation

## 🧪 Testing Database

### 1. Create Test Database

```bash
# For SQLite
DATABASE_URL=sqlite:///./habit_tracker_test.db python scripts/init_db.py

# For PostgreSQL
CREATE DATABASE habit_tracker_test_db;
GRANT ALL PRIVILEGES ON DATABASE habit_tracker_test_db TO habit_user;
```

### 2. Run Tests

```bash
# Set test database
export DATABASE_URL=sqlite:///./habit_tracker_test.db
# or
export DATABASE_URL=postgresql://habit_user:password@localhost:5432/habit_tracker_test_db

# Run tests
pytest
```

## 🔍 Database Management

### View Database

#### SQLite
```bash
# Install SQLite browser
sudo apt install sqlitebrowser  # Ubuntu
brew install --cask db-browser-for-sqlite  # macOS

# Open database
sqlitebrowser habit_tracker.db
```

#### PostgreSQL
```bash
# Connect to database
psql -U habit_user -d habit_tracker_db -h localhost

# List tables
\dt

# View table structure
\d table_name

# Exit
\q
```

### Backup and Restore

#### SQLite
```bash
# Backup
cp habit_tracker.db habit_tracker_backup.db

# Restore
cp habit_tracker_backup.db habit_tracker.db
```

#### PostgreSQL
```bash
# Backup
pg_dump -U habit_user -h localhost habit_tracker_db > backup.sql

# Restore
psql -U habit_user -h localhost habit_tracker_db < backup.sql
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Connection Refused
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start if stopped
sudo systemctl start postgresql
```

#### 2. Authentication Failed
```bash
# Check pg_hba.conf for authentication method
sudo nano /etc/postgresql/*/main/pg_hba.conf

# Restart PostgreSQL after changes
sudo systemctl restart postgresql
```

#### 3. Permission Denied
```bash
# Check user privileges
sudo -u postgres psql -c "\du"

# Grant privileges if needed
GRANT ALL PRIVILEGES ON DATABASE habit_tracker_db TO habit_user;
```

#### 4. Port Already in Use
```bash
# Check what's using port 5432
sudo netstat -tlnp | grep :5432

# Kill process if needed
sudo kill -9 <process_id>
```

### Performance Tuning

#### PostgreSQL
```sql
-- Increase shared buffers
ALTER SYSTEM SET shared_buffers = '256MB';

-- Set work memory
ALTER SYSTEM SET work_mem = '4MB';

-- Reload configuration
SELECT pg_reload_conf();
```

## 🔐 Security Considerations

### Production Database

1. **Use Strong Passwords**
2. **Enable SSL/TLS**
3. **Restrict Network Access**
4. **Regular Backups**
5. **Monitor Logs**

### Environment Variables

```bash
# Never commit .env files
echo ".env" >> .gitignore

# Use different databases for different environments
DATABASE_URL_DEV=postgresql://user:pass@localhost:5432/habit_tracker_dev
DATABASE_URL_PROD=postgresql://user:pass@prod-server:5432/habit_tracker_prod
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [FastAPI Database Guide](https://fastapi.tiangolo.com/tutorial/sql-databases/)
- [Alembic Migrations](https://alembic.sqlalchemy.org/)

## 🎯 Next Steps

After setting up the database:

1. **Test the API** - Visit http://localhost:8000/docs
2. **Create a User** - Use the registration endpoint
3. **Explore Endpoints** - Try different API calls
4. **Set Up Frontend** - Connect your Flutter app
5. **Add More Features** - Extend the API as needed

---

**Happy Database Setup! 🎉**
