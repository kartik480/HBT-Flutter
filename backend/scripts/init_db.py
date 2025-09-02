#!/usr/bin/env python3
"""
Database initialization script for Habit Tracker
Creates tables and populates with default data
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.database import engine, create_tables, SessionLocal
from app.models import User, Category, Habit
from app.core.security import get_password_hash
from sqlalchemy.orm import Session

def init_db():
    """Initialize the database with tables and default data"""
    print("🚀 Initializing Habit Tracker Database...")
    
    # Create all tables
    print("📋 Creating database tables...")
    create_tables()
    print("✅ Tables created successfully!")
    
    # Create default categories
    print("🏷️  Creating default categories...")
    create_default_categories()
    print("✅ Default categories created!")
    
    # Create admin user
    print("👤 Creating admin user...")
    create_admin_user()
    print("✅ Admin user created!")
    
    print("🎉 Database initialization complete!")

def create_default_categories():
    """Create default categories for the app"""
    db = SessionLocal()
    try:
        # Check if categories already exist
        existing_categories = db.query(Category).count()
        if existing_categories > 0:
            print("   Categories already exist, skipping...")
            return
        
        default_categories = Category.get_default_categories()
        
        for cat_data in default_categories:
            category = Category(
                name=cat_data["name"],
                color=cat_data["color"],
                icon=cat_data["icon"],
                is_default=True
            )
            db.add(category)
        
        db.commit()
        print(f"   Created {len(default_categories)} default categories")
        
    except Exception as e:
        print(f"   Error creating categories: {e}")
        db.rollback()
    finally:
        db.close()

def create_admin_user():
    """Create a default admin user"""
    db = SessionLocal()
    try:
        # Check if admin user already exists
        existing_admin = db.query(User).filter(User.email == "admin@habittracker.com").first()
        if existing_admin:
            print("   Admin user already exists, skipping...")
            return
        
        from app.core.security import get_password_hash
        
        admin_user = User(
            email="admin@habittracker.com",
            username="admin",
            hashed_password=get_password_hash("admin123"),
            first_name="Admin",
            last_name="User",
            is_verified=True,
            is_active=True
        )
        
        db.add(admin_user)
        db.commit()
        print("   Admin user created: admin@habittracker.com / admin123")
        
    except Exception as e:
        print(f"   Error creating admin user: {e}")
        db.rollback()
    finally:
        db.close()

def create_sample_habits():
    """Create sample habits for demonstration"""
    db = SessionLocal()
    try:
        # Check if habits already exist
        existing_habits = db.query(Habit).count()
        if existing_habits > 0:
            print("   Sample habits already exist, skipping...")
            return
        
        # Get admin user and a category
        admin_user = db.query(User).filter(User.email == "admin@habittracker.com").first()
        fitness_category = db.query(Category).filter(Category.name == "Health & Fitness").first()
        
        if not admin_user or not fitness_category:
            print("   Admin user or fitness category not found, skipping sample habits...")
            return
        
        sample_habits = [
            {
                "title": "Morning Exercise",
                "description": "30 minutes of cardio or strength training",
                "category_id": fitness_category.id,
                "frequency_type": "daily",
                "target_count": 1,
                "color": "#10B981"
            },
            {
                "title": "Read 30 Minutes",
                "description": "Read a book or educational content",
                "category_id": db.query(Category).filter(Category.name == "Learning").first().id,
                "frequency_type": "daily",
                "target_count": 1,
                "color": "#8B5CF6"
            },
            {
                "title": "Meditation",
                "description": "10 minutes of mindfulness practice",
                "category_id": db.query(Category).filter(Category.name == "Mindfulness").first().id,
                "frequency_type": "daily",
                "target_count": 1,
                "color": "#F59E0B"
            }
        ]
        
        for habit_data in sample_habits:
            habit = Habit(
                user_id=admin_user.id,
                **habit_data
            )
            db.add(habit)
        
        db.commit()
        print(f"   Created {len(sample_habits)} sample habits")
        
    except Exception as e:
        print(f"   Error creating sample habits: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
    
    # Optionally create sample habits
    response = input("\n🤔 Would you like to create sample habits? (y/n): ")
    if response.lower() in ['y', 'yes']:
        print("📝 Creating sample habits...")
        create_sample_habits()
        print("✅ Sample habits created!")
    
    print("\n🎯 Database setup complete! You can now run the API server.")
    print("📚 Next steps:")
    print("   1. Copy env_example.txt to .env and configure your settings")
    print("   2. Run: uvicorn app.main:app --reload")
    print("   3. Visit: http://localhost:8000/docs")
