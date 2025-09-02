from sqlalchemy import Column, Integer, String, DateTime, Boolean, Text, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid
import enum

class FrequencyType(str, enum.Enum):
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    CUSTOM = "custom"

class Habit(Base):
    __tablename__ = "habits"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    category_id = Column(String, ForeignKey("categories.id"), nullable=False, index=True)
    
    title = Column(String(200), nullable=False)
    description = Column(Text)
    frequency_type = Column(Enum(FrequencyType), default=FrequencyType.DAILY)
    frequency_value = Column(Integer, default=1)  # e.g., every 2 days, every 3 weeks
    target_count = Column(Integer, default=1)  # how many times per frequency period
    color = Column(String(7), default="#6366F1")
    icon = Column(String(50), default="check_circle")
    
    is_active = Column(Boolean, default=True)
    is_public = Column(Boolean, default=False)
    start_date = Column(DateTime(timezone=True), server_default=func.now())
    end_date = Column(DateTime(timezone=True), nullable=True)
    
    # Streak tracking
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    total_completions = Column(Integer, default=0)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="habits")
    category = relationship("Category", back_populates="habits")
    completions = relationship("Completion", back_populates="habit", cascade="all, delete-orphan")
    reminders = relationship("Reminder", back_populates="habit", cascade="all, delete-orphan")
    streaks = relationship("Streak", back_populates="habit", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Habit(id={self.id}, title='{self.title}', user_id='{self.user_id}')>"
    
    @property
    def completion_rate(self):
        """Calculate completion rate for the current period"""
        if not self.completions:
            return 0.0
        
        # Get completions for current period
        from datetime import datetime, timedelta
        now = datetime.utcnow()
        
        if self.frequency_type == FrequencyType.DAILY:
            period_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
        elif self.frequency_type == FrequencyType.WEEKLY:
            period_start = now - timedelta(days=now.weekday())
        elif self.frequency_type == FrequencyType.MONTHLY:
            period_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
        else:
            return 0.0
        
        period_completions = [c for c in self.completions if c.completed_at >= period_start]
        return min(len(period_completions) / self.target_count, 1.0) * 100
    
    @property
    def is_due_today(self):
        """Check if habit is due for completion today"""
        from datetime import datetime, timedelta
        today = datetime.utcnow().date()
        
        # Check if there's already a completion for today
        today_completions = [c for c in self.completions 
                           if c.completed_at.date() == today]
        
        return len(today_completions) < self.target_count
