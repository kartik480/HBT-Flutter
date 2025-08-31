#!/usr/bin/env python3
"""
AI Teacher - Combined Server Startup Script
Starts both the AI server (FastAPI) and web interface (Flask) simultaneously
"""

import subprocess
import sys
import time
import os
import signal
import threading
from pathlib import Path

def start_ai_server():
    """Start the AI server (FastAPI) on port 8000"""
    print("Starting AI Server (FastAPI) on port 8000...")
    try:
        # Start AI server
        ai_process = subprocess.Popen([
            sys.executable, "start_ai_server.py"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Wait a bit for the server to start
        time.sleep(3)
        
        if ai_process.poll() is None:
            print("AI Server started successfully on port 8000")
            print("API Documentation: http://localhost:8000/docs")
            return ai_process
        else:
            # Get the error output
            stdout, stderr = ai_process.communicate()
            print(f"AI Server failed to start")
            print(f"Exit code: {ai_process.returncode}")
            if stderr:
                print(f"Error output: {stderr}")
            if stdout:
                print(f"Standard output: {stdout}")
            return None
            
    except Exception as e:
        print(f"Error starting AI Server: {e}")
        return None

def start_web_interface():
    """Start the web interface (Flask) on port 5000"""
    print("Starting Web Interface (Flask) on port 5000...")
    try:
        # Start web interface
        web_process = subprocess.Popen([
            sys.executable, "web_interface.py"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Wait a bit for the server to start
        time.sleep(3)
        
        if web_process.poll() is None:
            print("Web Interface started successfully on port 5000")
            print("Web Interface: http://localhost:5000")
            return web_process
        else:
            # Get the error output
            stdout, stderr = web_process.communicate()
            print(f"Web Interface failed to start")
            print(f"Exit code: {web_process.returncode}")
            if stderr:
                print(f"Error output: {stderr}")
            if stdout:
                print(f"Standard output: {stdout}")
            return None
            
    except Exception as e:
        print(f"Error starting Web Interface: {e}")
        return None

def start_flutter_server():
    """Start the Flutter development server"""
    print("Starting Flutter Development Server...")
    try:
        # Check if Flutter is available
        try:
            subprocess.run(["flutter", "--version"], capture_output=True, check=True)
        except (subprocess.CalledProcessError, FileNotFoundError):
            print("Flutter not found in PATH. Skipping Flutter server startup.")
            print("You can manually start Flutter with: flutter run -d chrome")
            return None
        
        # Start Flutter server with shell=True to use PATH
        flutter_process = subprocess.Popen([
            "flutter", "run", "-d", "chrome", "--web-port", "8080"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
        
        # Wait a bit for the server to start
        time.sleep(8)  # Flutter takes longer to start
        
        if flutter_process.poll() is None:
            print("Flutter Development Server started successfully on port 8080")
            print("Flutter App: http://localhost:8080")
            return flutter_process
        else:
            # Get the error output
            stdout, stderr = flutter_process.communicate()
            print(f"Flutter Development Server failed to start")
            print(f"Exit code: {flutter_process.returncode}")
            if stderr:
                print(f"Error output: {stderr}")
            if stdout:
                print(f"Standard output: {stdout}")
            return None
            
    except Exception as e:
        print(f"Error starting Flutter Development Server: {e}")
        return None

def check_server_health(url, name):
    """Check if a server is responding"""
    import requests
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            print(f"{name} is healthy and responding")
            return True
        else:
            print(f"{name} responded with status {response.status_code}")
            return False
    except Exception as e:
        print(f"{name} is not responding: {e}")
        return False

def main():
    """Main function to start all servers"""
    print("AI Teacher - Complete System Startup")
    print("=" * 50)
    
    # Check if required files exist
    required_files = ["start_ai_server.py", "web_interface.py", "ai_teacher.py"]
    missing_files = [f for f in required_files if not Path(f).exists()]
    
    if missing_files:
        print(f"Missing required files: {', '.join(missing_files)}")
        print("Please make sure you're in the correct directory")
        return
    
    print("Found all required files")
    print()
    
    # Start AI Server
    ai_process = start_ai_server()
    if not ai_process:
        print("Failed to start AI Server. Exiting...")
        return
    
    print()
    
    # Start Web Interface
    web_process = start_web_interface()
    if not web_process:
        print("Failed to start Web Interface. Exiting...")
        ai_process.terminate()
        return
    
    print()
    
    # Start Flutter Development Server
    flutter_process = start_flutter_server()
    if not flutter_process:
        print("Flutter Development Server not started, but continuing with other servers...")
        print("You can manually start Flutter with: flutter run -d chrome")
        flutter_process = None  # Set to None to indicate it's not running
    
    print()
    if flutter_process:
        print("All servers started successfully!")
        print("=" * 50)
        print("Flutter App: http://localhost:8080")
        print("Web Interface: http://localhost:5000")
        print("AI Server API: http://localhost:8000")
        print("API Documentation: http://localhost:8000/docs")
        print("=" * 50)
        print()
        print("You can now:")
        print("   • Open http://localhost:8080 for your Flutter app")
        print("   • Open http://localhost:5000 for the web interface")
        print("   • Chat with the AI Teacher through both interfaces")
        print("   • Access all features through the web interface")
    else:
        print("Backend servers started successfully!")
        print("=" * 50)
        print("Web Interface: http://localhost:5000")
        print("AI Server API: http://localhost:8000")
        print("API Documentation: http://localhost:8000/docs")
        print("=" * 50)
        print()
        print("You can now:")
        print("   • Open http://localhost:5000 for the web interface")
        print("   • Chat with the AI Teacher through the web interface")
        print("   • Access all features through the web interface")
        print("   • Manually start Flutter with: flutter run -d chrome")
    print()
    print("Press Ctrl+C to stop all servers")
    print()
    
    try:
        # Wait for user to stop the servers
        while True:
            time.sleep(1)
            
            # Check if processes are still running
            if ai_process.poll() is not None:
                print("AI Server stopped unexpectedly")
                break
                
            if web_process.poll() is not None:
                print("Web Interface stopped unexpectedly")
                break
                
            if flutter_process and flutter_process.poll() is not None:
                print("Flutter Development Server stopped unexpectedly")
                break
                
    except KeyboardInterrupt:
        print("\nShutting down all servers...")
        
        # Terminate all processes
        if flutter_process:
            flutter_process.terminate()
            print("Flutter Development Server stopped")
            
        if web_process:
            web_process.terminate()
            print("Web Interface stopped")
            
        if ai_process:
            ai_process.terminate()
            print("AI Server stopped")
            
        print("All servers stopped. Goodbye!")

if __name__ == "__main__":
    main()
