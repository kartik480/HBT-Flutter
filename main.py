#!/usr/bin/env python3
"""
Railway deployment entry point for Habit Tracker API
"""

import os
import sys
from pathlib import Path

# Add the app directory to Python path
app_dir = Path(__file__).parent / "app"
sys.path.insert(0, str(app_dir))

# Import and run the FastAPI app
from app.main import app

if __name__ == "__main__":
    import uvicorn
    
    # Get port from Railway environment variable
    port = int(os.environ.get("PORT", 8000))
    
    # Run the app
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=port,
        reload=False,
        log_level="info"
    )
