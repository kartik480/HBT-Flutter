#!/usr/bin/env python3
"""
Production entry point for Habit Tracker API
"""

import os
import sys
from pathlib import Path

# Add app directory to path
sys.path.insert(0, str(Path(__file__).parent / "app"))

from app.main import app

if __name__ == "__main__":
    import uvicorn
    
    # Production settings
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", "8000"))
    
    uvicorn.run(
        app,
        host=host,
        port=port,
        log_level="info"
    )
