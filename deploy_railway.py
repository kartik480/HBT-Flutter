#!/usr/bin/env python3
"""
Railway Deployment Helper Script
This script helps prepare your project for Railway deployment
"""

import os
import shutil
from pathlib import Path

def prepare_railway_deployment():
    """Prepare the project for Railway deployment"""
    
    print("🚀 Preparing Railway deployment...")
    
    # Check if we're in the right directory
    if not Path("backend").exists():
        print("❌ Error: backend directory not found!")
        print("Please run this script from the project root directory.")
        return False
    
    # Copy backend files to root for Railway
    print("📁 Copying backend files to root...")
    
    # Copy app directory
    if Path("app").exists():
        shutil.rmtree("app")
    shutil.copytree("backend/app", "app")
    
    # Copy requirements.txt if it doesn't exist
    if not Path("requirements.txt").exists():
        shutil.copy("backend/requirements.txt", "requirements.txt")
    
    print("✅ Files copied successfully!")
    
    # Check required files
    required_files = ["railway.json", "main.py", "requirements.txt", "app"]
    missing_files = []
    
    for file in required_files:
        if not Path(file).exists():
            missing_files.append(file)
    
    if missing_files:
        print(f"❌ Missing required files: {missing_files}")
        return False
    
    print("✅ All required files present!")
    
    # Display next steps
    print("\n🎯 Next Steps:")
    print("1. Push your code to GitHub")
    print("2. Go to https://railway.app")
    print("3. Create new project from GitHub repo")
    print("4. Add environment variables (see RAILWAY_DEPLOYMENT.md)")
    print("5. Deploy!")
    
    print("\n📖 For detailed instructions, see RAILWAY_DEPLOYMENT.md")
    
    return True

if __name__ == "__main__":
    prepare_railway_deployment()
