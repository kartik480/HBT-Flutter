#!/usr/bin/env python3
"""
AI Teacher Server Startup Script
This script starts the AI Teacher server with proper configuration.
"""

import subprocess
import sys
import os
from pathlib import Path

def check_dependencies():
    """Check if required packages are installed"""
    try:
        import fastapi
        import uvicorn
        import sqlite3
        print("All required packages are installed")
        return True
    except ImportError as e:
        print(f"Missing package: {e}")
        print("Please install requirements: pip install -r requirements.txt")
        return False

def start_server():
    """Start the AI Teacher server"""
    print("Starting AI Teacher Server...")
    print("Server will be available at: http://localhost:8000")
    print("Web interface will be available at: http://localhost:5000")
    print("Flutter app can connect to: http://localhost:8000")
    print("\nPress Ctrl+C to stop the server")
    print("-" * 50)
    
    try:
        # Start the FastAPI server
        subprocess.run([
            sys.executable, "-m", "uvicorn", 
            "ai_teacher_api:app", 
            "--host", "0.0.0.0", 
            "--port", "8000",
            "--reload"
        ])
    except KeyboardInterrupt:
        print("\nServer stopped by user")
    except Exception as e:
        print(f"Error starting server: {e}")

def main():
    """Main function"""
    print("AI Teacher Server Startup")
    print("=" * 40)
    
    # Check if we're in the right directory
    if not Path("ai_teacher_api.py").exists():
        print("Error: ai_teacher_api.py not found!")
        print("Please run this script from the project root directory")
        return
    
    # Check dependencies
    if not check_dependencies():
        return
    
    # Start server
    start_server()

if __name__ == "__main__":
    main()
