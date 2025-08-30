from fastapi import FastAPI, HTTPException, Depends, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from pydantic import BaseModel, Field
from typing import Dict, List, Optional, Any
import uvicorn
import asyncio
import logging
from datetime import datetime, timedelta
import json

from ai_teacher import AITeacher

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="AI Teacher API",
    description="Intelligent AI Teacher for Habit Formation, Guidance, and Motivation",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, restrict to specific domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize AI Teacher
ai_teacher = AITeacher()

# Security
security = HTTPBearer()

# Pydantic models for API requests/responses
class UserCreate(BaseModel):
    name: str = Field(..., description="User's name")
    preferences: Optional[Dict[str, Any]] = Field(default={}, description="User preferences")

class HabitCreate(BaseModel):
    name: str = Field(..., description="Habit name")
    description: Optional[str] = Field(default="", description="Habit description")
    frequency: str = Field(default="daily", description="Habit frequency")
    reminder_time: str = Field(default="morning", description="Optimal reminder time")

class HabitLog(BaseModel):
    completed: bool = Field(..., description="Whether habit was completed")
    mood: Optional[str] = Field(default=None, description="User's mood")
    notes: Optional[str] = Field(default=None, description="Additional notes")

class QueryRequest(BaseModel):
    query: str = Field(..., description="User's question or request")
    context: Optional[Dict[str, Any]] = Field(default={}, description="Additional context")
    mood: Optional[str] = Field(default="neutral", description="User's current mood")

class QueryResponse(BaseModel):
    message: str = Field(..., description="AI Teacher's main response")
    suggestions: List[str] = Field(default=[], description="Personalized suggestions")
    reminders: List[Dict[str, Any]] = Field(default=[], description="Smart reminders")
    motivation: str = Field(default="", description="Motivational content")
    analysis: Optional[Dict[str, Any]] = Field(default=None, description="Progress analysis")
    intent: str = Field(..., description="Detected user intent")
    sentiment: str = Field(..., description="Detected user sentiment")

class UserInsights(BaseModel):
    habit_analysis: Dict[str, Any] = Field(..., description="Detailed habit analysis")
    recommendations: List[str] = Field(..., description="Personalized recommendations")
    best_times: Dict[str, float] = Field(..., description="Optimal times for habits")
    consistency_scores: Dict[str, float] = Field(..., description="Habit consistency scores")

# API Routes

@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "AI Teacher API is running! 🤖",
        "version": "1.0.0",
        "features": [
            "Intelligent habit analysis",
            "Personalized coaching",
            "Smart reminders",
            "Progress tracking",
            "Motivational support"
        ],
        "docs": "/docs",
        "health": "/health"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "ai_teacher_status": "active",
        "database_status": "connected"
    }

@app.post("/users", response_model=Dict[str, Any])
async def create_user(user_data: UserCreate):
    """Create a new user"""
    try:
        user_id = ai_teacher.data_manager.add_user(
            name=user_data.name,
            preferences=user_data.preferences
        )
        
        logger.info(f"Created user: {user_data.name} with ID: {user_id}")
        
        return {
            "success": True,
            "user_id": user_id,
            "message": f"User {user_data.name} created successfully",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error creating user: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create user: {str(e)}")

@app.post("/users/{user_id}/habits", response_model=Dict[str, Any])
async def add_habit(user_id: int, habit_data: HabitCreate):
    """Add a new habit for a user"""
    try:
        habit_id = ai_teacher.add_habit_for_user(
            user_id=user_id,
            habit_name=habit_data.name,
            description=habit_data.description,
            frequency=habit_data.frequency,
            reminder_time=habit_data.reminder_time
        )
        
        logger.info(f"Added habit '{habit_data.name}' for user {user_id}")
        
        return {
            "success": True,
            "habit_id": habit_id,
            "message": f"Habit '{habit_data.name}' added successfully",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error adding habit: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to add habit: {str(e)}")

@app.post("/habits/{habit_id}/log", response_model=Dict[str, Any])
async def log_habit_completion(habit_id: int, log_data: HabitLog):
    """Log habit completion status"""
    try:
        ai_teacher.log_habit_completion(
            habit_id=habit_id,
            completed=log_data.completed,
            mood=log_data.mood,
            notes=log_data.notes
        )
        
        status = "completed" if log_data.completed else "missed"
        logger.info(f"Logged habit {habit_id} as {status}")
        
        return {
            "success": True,
            "message": f"Habit logged as {status}",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error logging habit: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to log habit: {str(e)}")

@app.post("/ai/ask")
async def ask_ai(request: Dict[str, Any]):
    """Simple endpoint for Flutter app to ask AI questions"""
    try:
        user_id = request.get('user_id', 'default_user')
        question = request.get('question', '')
        
        if not question:
            raise HTTPException(status_code=400, detail="Question is required")
        
        # Convert string user_id to int for compatibility
        try:
            user_id_int = int(user_id) if user_id.isdigit() else hash(user_id) % 1000000
        except:
            user_id_int = hash(user_id) % 1000000
        
        # Process query through AI Teacher
        response = ai_teacher.process_query(
            user_id=user_id_int,
            query=question,
            context={}
        )
        
        logger.info(f"AI query processed for user {user_id}: {question[:50]}...")
        
        return {
            "success": True,
            "response": response.get('message', 'No response generated'),
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error processing AI query: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to process query: {str(e)}")

@app.post("/ai/insights")
async def get_ai_insights(request: Dict[str, Any]):
    """Get AI insights for a user"""
    try:
        user_id = request.get('user_id', 'default_user')
        
        # Convert string user_id to int for compatibility
        try:
            user_id_int = int(user_id) if user_id.isdigit() else hash(user_id) % 1000000
        except:
            user_id_int = hash(user_id) % 1000000
        
        # Get insights from AI Teacher
        insights = ai_teacher.get_user_insights(user_id_int)
        
        logger.info(f"Generated insights for user {user_id}")
        
        return {
            "success": True,
            "insights": insights,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error generating insights: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to generate insights: {str(e)}")

@app.get("/ai/motivational-quote")
async def get_motivational_quote(context: Optional[str] = None):
    """Get a motivational quote from AI Teacher"""
    try:
        quote = ai_teacher.coach.get_motivational_quote(context)
        
        return {
            "success": True,
            "quote": quote,
            "context": context,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error getting motivational quote: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get motivational quote: {str(e)}")

@app.post("/ai/coaching-session")
async def start_ai_coaching_session(request: Dict[str, Any]):
    """Start an AI coaching session"""
    try:
        user_id = request.get('user_id', 'default_user')
        session_type = request.get('session_type', 'general')
        
        # Convert string user_id to int for compatibility
        try:
            user_id_int = int(user_id) if user_id.isdigit() else hash(user_id) % 1000000
        except:
            user_id_int = hash(user_id) % 1000000
        
        # Get user context and insights
        user_context = ai_teacher._get_user_context(user_id_int)
        insights = ai_teacher.get_user_insights(user_id_int)
        
        # Generate coaching message
        coaching_message = ai_teacher.coach.get_personalized_message(user_context, session_type)
        
        # Get motivational quote
        motivation = ai_teacher.coach.get_motivational_quote()
        
        logger.info(f"Started AI coaching session for user {user_id}, type: {session_type}")
        
        return {
            "success": True,
            "coaching_session": {
                "type": session_type,
                "message": coaching_message,
                "motivation": motivation,
                "insights": insights,
                "recommendations": insights.get('recommendations', [])
            },
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error starting coaching session: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to start coaching session: {str(e)}")

@app.post("/users/{user_id}/query", response_model=QueryResponse)
async def process_query(user_id: int, query_request: QueryRequest):
    """Process user query and get AI Teacher response"""
    try:
        # Add mood to context if provided
        context = query_request.context or {}
        if query_request.mood:
            context['mood'] = query_request.mood
        
        # Process query through AI Teacher
        response = ai_teacher.process_query(
            user_id=user_id,
            query=query_request.query,
            context=context
        )
        
        # Extract response data
        message = response.get('message', 'No response generated')
        suggestions = response.get('suggestions', [])
        reminders = response.get('reminders', [])
        motivation = response.get('motivation', '')
        analysis = response.get('analysis')
        
        # Get intent and sentiment for response
        intent_scores = ai_teacher.nlp.analyze_intent(query_request.query)
        sentiment = ai_teacher.nlp.analyze_sentiment(query_request.query)
        
        primary_intent = max(intent_scores.items(), key=lambda x: x[1])[0] if intent_scores else 'general'
        
        logger.info(f"Processed query for user {user_id}: {query_request.query[:50]}...")
        
        return QueryResponse(
            message=response['message'],
            suggestions=response.get('suggestions', []),
            reminders=response.get('reminders', []),
            motivation=response.get('motivation', ''),
            analysis=response.get('analysis'),
            intent=primary_intent,
            sentiment=sentiment
        )
    except Exception as e:
        logger.error(f"Error processing query: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to process query: {str(e)}")

@app.get("/users/{user_id}/insights", response_model=UserInsights)
async def get_user_insights(user_id: int):
    """Get comprehensive insights for a user"""
    try:
        insights = ai_teacher.get_user_insights(user_id)
        
        logger.info(f"Generated insights for user {user_id}")
        
        return UserInsights(
            habit_analysis=insights['habit_analysis'],
            recommendations=insights['recommendations'],
            best_times=insights['best_times'],
            consistency_scores=insights['consistency_scores']
        )
    except Exception as e:
        logger.error(f"Error generating insights: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to generate insights: {str(e)}")

@app.get("/users/{user_id}/habits")
async def get_user_habits(user_id: int):
    """Get all habits for a user"""
    try:
        # This would need to be implemented in the DataManager
        # For now, return a placeholder
        return {
            "success": True,
            "message": "User habits retrieved successfully",
            "habits": [],  # Placeholder
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error retrieving user habits: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve habits: {str(e)}")

@app.get("/users/{user_id}/progress")
async def get_user_progress(user_id: int, days: int = 30):
    """Get user's progress over specified days"""
    try:
        habit_data = ai_teacher.data_manager.get_habit_data(user_id, days=days)
        
        # Calculate progress metrics
        total_habits = len(habit_data)
        completed_habits = sum(1 for h in habit_data if h['completed'])
        completion_rate = (completed_habits / total_habits * 100) if total_habits > 0 else 0
        
        # Calculate streak
        streak = 0
        for habit in reversed(habit_data):
            if habit['completed']:
                streak += 1
            else:
                break
        
        logger.info(f"Generated progress report for user {user_id}")
        
        return {
            "success": True,
            "progress_data": {
                "total_habits": total_habits,
                "completed_habits": completed_habits,
                "completion_rate": round(completion_rate, 2),
                "current_streak": streak,
                "period_days": days
            },
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error generating progress report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to generate progress report: {str(e)}")

@app.post("/users/{user_id}/reminders/generate")
async def generate_smart_reminders(user_id: int, habit_name: str):
    """Generate smart reminders for a specific habit"""
    try:
        # Get user context
        user_context = ai_teacher._get_user_context(user_id)
        
        # Generate reminder
        reminder_msg = ai_teacher.reminder.generate_reminder(habit_name, user_context)
        optimal_time = ai_teacher.reminder.get_optimal_reminder_time(habit_name, {})
        
        logger.info(f"Generated reminder for user {user_id}, habit: {habit_name}")
        
        return {
            "success": True,
            "reminder": {
                "habit": habit_name,
                "message": reminder_msg,
                "optimal_time": optimal_time,
                "user_context": user_context
            },
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error generating reminder: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to generate reminder: {str(e)}")

@app.get("/motivation/quote")
async def get_motivational_quote(context: Optional[str] = None):
    """Get a motivational quote, optionally contextualized"""
    try:
        quote = ai_teacher.coach.get_motivational_quote(context)
        
        return {
            "success": True,
            "quote": quote,
            "context": context,
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error getting motivational quote: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get motivational quote: {str(e)}")

@app.post("/users/{user_id}/coaching/session")
async def start_coaching_session(user_id: int, session_type: str = "general"):
    """Start a personalized coaching session"""
    try:
        # Get user context and insights
        user_context = ai_teacher._get_user_context(user_id)
        insights = ai_teacher.get_user_insights(user_id)
        
        # Generate coaching message
        coaching_message = ai_teacher.coach.get_personalized_message(user_context, session_type)
        
        # Get motivational quote
        motivation = ai_teacher.coach.get_motivational_quote()
        
        logger.info(f"Started coaching session for user {user_id}, type: {session_type}")
        
        return {
            "success": True,
            "coaching_session": {
                "type": session_type,
                "message": coaching_message,
                "motivation": motivation,
                "insights": insights,
                "recommendations": insights.get('recommendations', [])
            },
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error starting coaching session: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to start coaching session: {str(e)}")

# Background task for periodic AI learning
@app.post("/admin/trigger-learning")
async def trigger_learning(background_tasks: BackgroundTasks):
    """Trigger AI learning process (admin endpoint)"""
    try:
        def run_learning():
            ai_teacher._learn_from_interactions()
        
        background_tasks.add_task(run_learning)
        
        return {
            "success": True,
            "message": "AI learning process triggered",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Error triggering learning: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to trigger learning: {str(e)}")

# Error handlers
@app.exception_handler(404)
async def not_found_handler(request, exc):
    return {
        "error": "Not Found",
        "message": "The requested resource was not found",
        "timestamp": datetime.now().isoformat()
    }

@app.exception_handler(500)
async def internal_error_handler(request, exc):
    return {
        "error": "Internal Server Error",
        "message": "An internal server error occurred",
        "timestamp": datetime.now().isoformat()
    }

if __name__ == "__main__":
    # Run the API server
    uvicorn.run(
        "ai_teacher_api:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
