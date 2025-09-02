from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Date
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class Streak(Base):
    __tablename__ = "streaks"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    habit_id = Column(String, ForeignKey("habits.id"), nullable=False, index=True)
    
    start_date = Column(Date, nullable=False, index=True)
    end_date = Column(Date, nullable=True)
    current_length = Column(Integer, default=1)
    longest_length = Column(Integer, default=1)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="streaks")
    habit = relationship("Habit", back_populates="streaks")
    
    def __repr__(self):
        return f"<Streak(id={self.id}, habit_id='{self.habit_id}', length={self.current_length})>"
    
    @property
    def is_active(self):
        """Check if streak is currently active"""
        from datetime import datetime, timedelta
        today = datetime.utcnow().date()
        
        # If no end_date, streak is active
        if not self.end_date:
            return True
        
        # Check if streak ended recently (within last day)
        return self.end_date >= today - timedelta(days=1)
    
    @property
    def days_since_start(self):
        """Calculate days since streak started"""
        from datetime import datetime
        today = datetime.utcnow().date()
        return (today - self.start_date).days
    
    def update_streak(self, completed_today: bool):
        """Update streak based on today's completion"""
        from datetime import datetime, timedelta
        
        today = datetime.utcnow().date()
        
        if completed_today:
            if self.is_active:
                # Extend current streak
                self.current_length += 1
                self.longest_length = max(self.longest_length, self.current_length)
            else:
                # Start new streak
                self.start_date = today
                self.end_date = None
                self.current_length = 1
        else:
            if self.is_active:
                # End current streak
                self.end_date = today - timedelta(days=1)
        
        self.updated_at = datetime.utcnow()
    
    @classmethod
    def get_current_streak(cls, user_id: str, habit_id: str):
        """Get the current active streak for a user and habit"""
        from datetime import datetime
        today = datetime.utcnow().date()
        
        return cls.query.filter(
            cls.user_id == user_id,
            cls.habit_id == habit_id,
            cls.end_date.is_(None) | (cls.end_date >= today - timedelta(days=1))
        ).first()
