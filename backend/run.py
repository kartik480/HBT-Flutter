#!/usr/bin/env python3
"""
Simple startup script for Habit Tracker Backend
"""

import uvicorn
from app.config import settings

if __name__ == "__main__":
    print("🚀 Starting Habit Tracker Backend...")
    print(f"📊 Environment: {settings.ENVIRONMENT}")
    print(f"🔧 Debug Mode: {settings.DEBUG}")
    print(f"🌐 Server: http://localhost:8000")
    print(f"📚 API Docs: http://localhost:8000/docs")
    print("=" * 50)
    
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        log_level="info"
    )
