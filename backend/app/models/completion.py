from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class Completion(Base):
    __tablename__ = "completions"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    habit_id = Column(String, ForeignKey("habits.id"), nullable=False, index=True)
    
    completed_at = Column(DateTime(timezone=True), nullable=False, index=True)
    notes = Column(Text)
    mood_rating = Column(Integer)  # 1-10 scale
    difficulty_rating = Column(Integer)  # 1-10 scale
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="completions")
    habit = relationship("Habit", back_populates="completions")
    
    def __repr__(self):
        return f"<Completion(id={self.id}, habit_id='{self.habit_id}', completed_at='{self.completed_at}')>"
    
    @property
    def is_today(self):
        """Check if completion was done today"""
        from datetime import datetime
        today = datetime.utcnow().date()
        return self.completed_at.date() == today
    
    @property
    def is_this_week(self):
        """Check if completion was done this week"""
        from datetime import datetime, timedelta
        now = datetime.utcnow()
        week_start = now - timedelta(days=now.weekday())
        return self.completed_at >= week_start
    
    @property
    def is_this_month(self):
        """Check if completion was done this month"""
        from datetime import datetime
        now = datetime.utcnow()
        month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
        return self.completed_at >= month_start
