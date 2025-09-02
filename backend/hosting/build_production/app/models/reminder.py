from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean, Time
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import uuid

class Reminder(Base):
    __tablename__ = "reminders"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    habit_id = Column(String, ForeignKey("habits.id"), nullable=True, index=True)  # Null for general reminders
    
    title = Column(String(200), nullable=False)
    message = Column(String(500))
    reminder_time = Column(Time, nullable=False)  # Time of day for reminder
    days_of_week = Column(String(50), default="1,2,3,4,5,6,7")  # Comma-separated days (1=Monday)
    
    is_active = Column(Boolean, default=True)
    is_recurring = Column(Boolean, default=True)
    last_sent = Column(DateTime(timezone=True))
    next_send = Column(DateTime(timezone=True), index=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="reminders")
    habit = relationship("Habit", back_populates="reminders")
    
    def __repr__(self):
        return f"<Reminder(id={self.id}, title='{self.title}', user_id='{self.user_id}')>"
    
    @property
    def days_list(self):
        """Convert days_of_week string to list of integers"""
        return [int(day) for day in self.days_of_week.split(",")]
    
    @property
    def is_due_today(self):
        """Check if reminder should be sent today"""
        from datetime import datetime
        today = datetime.utcnow().weekday() + 1  # Convert to 1-7 format
        return str(today) in self.days_of_week.split(",")
    
    def get_next_send_time(self):
        """Calculate next time reminder should be sent"""
        from datetime import datetime, timedelta
        
        now = datetime.utcnow()
        today = now.weekday() + 1  # Convert to 1-7 format
        
        # Check if reminder is due today
        if str(today) in self.days_of_week.split(","):
            # Check if it's already past reminder time today
            reminder_datetime = now.replace(
                hour=self.reminder_time.hour,
                minute=self.reminder_time.minute,
                second=0,
                microsecond=0
            )
            
            if now < reminder_datetime:
                return reminder_datetime
        
        # Find next day when reminder should be sent
        days_ahead = 1
        while days_ahead <= 7:
            next_day = (today + days_ahead - 1) % 7 + 1
            if str(next_day) in self.days_of_week.split(","):
                next_date = now.date() + timedelta(days=days_ahead)
                return datetime.combine(next_date, self.reminder_time)
            days_ahead += 1
        
        return None
