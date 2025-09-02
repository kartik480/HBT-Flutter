"""
Production configuration for Habit Tracker API on Hostinger
"""

from pydantic_settings import BaseSettings
from typing import List
import os

class ProductionSettings(BaseSettings):
    # Database - Use MySQL for shared hosting, PostgreSQL for VPS
    DATABASE_URL: str = "mysql://habit_user:password@localhost:habit_tracker_db"
    
    # Security - Generate strong secret key for production
    SECRET_KEY: str = os.getenv("SECRET_KEY", "generate-strong-secret-key-here")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # Redis (optional for shared hosting)
    REDIS_URL: str = "redis://localhost:6379"
    
    # Email configuration for Hostinger
    SMTP_SERVER: str = "mail.your-domain.com"
    SMTP_PORT: int = 587
    SMTP_USERNAME: str = "noreply@your-domain.com"
    SMTP_PASSWORD: str = ""
    
    # App configuration
    APP_NAME: str = "Habit Tracker API"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False
    ENVIRONMENT: str = "production"
    
    # CORS - Restrict to your domain
    ALLOWED_ORIGINS: List[str] = [
        "https://your-domain.com",
        "https://www.your-domain.com",
        "https://app.your-domain.com"
    ]
    
    # Performance settings
    MAX_CONNECTIONS: int = 100
    WORKER_PROCESSES: int = 4
    REQUEST_TIMEOUT: int = 30
    
    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_FILE: str = "/var/log/habit-tracker.log"
    
    # Rate limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    RATE_LIMIT_PER_HOUR: int = 1000
    
    class Config:
        env_file = ".env"
        case_sensitive = True

# Create production settings instance
production_settings = ProductionSettings()

# Validate required settings
def validate_production_settings():
    """Validate that all required production settings are configured"""
    required_settings = [
        "DATABASE_URL",
        "SECRET_KEY",
        "SMTP_SERVER",
        "SMTP_USERNAME",
        "SMTP_PASSWORD"
    ]
    
    missing_settings = []
    for setting in required_settings:
        if not getattr(production_settings, setting):
            missing_settings.append(setting)
    
    if missing_settings:
        raise ValueError(f"Missing required production settings: {missing_settings}")
    
    # Check if SECRET_KEY is still default
    if production_settings.SECRET_KEY == "generate-strong-secret-key-here":
        raise ValueError("SECRET_KEY must be set to a strong, unique value in production")
    
    return True

# Production environment checks
def is_production():
    """Check if running in production environment"""
    return production_settings.ENVIRONMENT == "production"

def get_database_config():
    """Get database configuration based on environment"""
    if "mysql" in production_settings.DATABASE_URL.lower():
        return {
            "type": "mysql",
            "pool_size": 10,
            "max_overflow": 20,
            "pool_timeout": 30,
            "pool_recycle": 3600
        }
    elif "postgresql" in production_settings.DATABASE_URL.lower():
        return {
            "type": "postgresql",
            "pool_size": 20,
            "max_overflow": 30,
            "pool_timeout": 30,
            "pool_pre_ping": True
        }
    else:
        return {
            "type": "sqlite",
            "pool_size": 1,
            "max_overflow": 0
        }

def get_cors_config():
    """Get CORS configuration for production"""
    return {
        "allow_origins": production_settings.ALLOWED_ORIGINS,
        "allow_credentials": True,
        "allow_methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": [
            "Content-Type",
            "Authorization",
            "X-Requested-With",
            "Accept",
            "Origin"
        ],
        "expose_headers": ["Content-Length", "X-Total-Count"],
        "max_age": 86400  # 24 hours
    }

def get_security_config():
    """Get security configuration for production"""
    return {
        "secret_key": production_settings.SECRET_KEY,
        "algorithm": production_settings.ALGORITHM,
        "access_token_expire_minutes": production_settings.ACCESS_TOKEN_EXPIRE_MINUTES,
        "refresh_token_expire_days": production_settings.REFRESH_TOKEN_EXPIRE_DAYS,
        "password_min_length": 8,
        "require_uppercase": True,
        "require_lowercase": True,
        "require_numbers": True,
        "require_special_chars": True
    }

def get_logging_config():
    """Get logging configuration for production"""
    return {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "default": {
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            },
            "detailed": {
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s"
            }
        },
        "handlers": {
            "file": {
                "class": "logging.FileHandler",
                "filename": production_settings.LOG_FILE,
                "formatter": "detailed",
                "level": production_settings.LOG_LEVEL
            },
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "default",
                "level": "WARNING"
            }
        },
        "root": {
            "handlers": ["file", "console"],
            "level": production_settings.LOG_LEVEL
        },
        "loggers": {
            "uvicorn": {
                "handlers": ["file", "console"],
                "level": "INFO"
            },
            "sqlalchemy": {
                "handlers": ["file"],
                "level": "WARNING"
            }
        }
    }

if __name__ == "__main__":
    # Validate settings when run directly
    try:
        validate_production_settings()
        print("✅ Production settings are valid!")
        print(f"🌐 Environment: {production_settings.ENVIRONMENT}")
        print(f"🗄️ Database: {production_settings.DATABASE_URL.split('://')[0]}")
        print(f"🔐 Secret Key: {'*' * 20 if production_settings.SECRET_KEY != 'generate-strong-secret-key-here' else 'NOT SET'}")
    except ValueError as e:
        print(f"❌ Production settings validation failed: {e}")
        exit(1)
