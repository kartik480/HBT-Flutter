from sqlalchemy import Column, Integer, String, DateTime, Text, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class Category(Base):
    __tablename__ = "categories"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String(100), nullable=False, unique=True)
    description = Column(Text)
    color = Column(String(7), default="#6366F1")  # Hex color code
    icon = Column(String(50), default="category")
    is_default = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    habits = relationship("Habit", back_populates="category")
    
    def __repr__(self):
        return f"<Category(id={self.id}, name='{self.name}', color='{self.color}')>"
    
    @classmethod
    def get_default_categories(cls):
        """Return list of default categories to create on app initialization"""
        return [
            {"name": "Health & Fitness", "color": "#10B981", "icon": "fitness_center"},
            {"name": "Productivity", "color": "#3B82F6", "icon": "work"},
            {"name": "Learning", "color": "#8B5CF6", "icon": "school"},
            {"name": "Mindfulness", "color": "#F59E0B", "icon": "self_improvement"},
            {"name": "Relationships", "color": "#EF4444", "icon": "people"},
            {"name": "Finance", "color": "#06B6D4", "icon": "account_balance"},
            {"name": "Creativity", "color": "#EC4899", "icon": "palette"},
            {"name": "Home & Organization", "color": "#84CC16", "icon": "home"},
        ]
