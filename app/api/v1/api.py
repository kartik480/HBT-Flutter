from fastapi import APIRouter
from app.api.v1.endpoints import auth, users, habits, categories, completions, reminders, analytics

# Create main API router
api_router = APIRouter()

# Include all endpoint routers
api_router.include_router(auth.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(users.router, prefix="/users", tags=["Users"])
api_router.include_router(habits.router, prefix="/habits", tags=["Habits"])
api_router.include_router(categories.router, prefix="/categories", tags=["Categories"])
api_router.include_router(completions.router, prefix="/completions", tags=["Completions"])
api_router.include_router(reminders.router, prefix="/reminders", tags=["Reminders"])
api_router.include_router(analytics.router, prefix="/analytics", tags=["Analytics"])
