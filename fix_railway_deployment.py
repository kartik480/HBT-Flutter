#!/usr/bin/env python3
"""
Fix Railway Deployment - Ensure all files are properly set up
"""

import os
import shutil
from pathlib import Path

def fix_railway_deployment():
    """Fix Railway deployment by ensuring all files are in the right place"""
    
    print("🔧 Fixing Railway deployment...")
    
    # Check if we're in the right directory
    if not Path("backend").exists():
        print("❌ Error: backend directory not found!")
        return False
    
    # Ensure app directory exists in root
    if Path("app").exists():
        shutil.rmtree("app")
    shutil.copytree("backend/app", "app")
    print("✅ Copied app directory to root")
    
    # Ensure requirements.txt exists in root
    if not Path("requirements.txt").exists():
        shutil.copy("backend/requirements.txt", "requirements.txt")
        print("✅ Copied requirements.txt to root")
    
    # Ensure main.py exists in root
    if not Path("main.py").exists():
        # Create main.py if it doesn't exist
        main_py_content = '''#!/usr/bin/env python3
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
'''
        with open("main.py", "w") as f:
            f.write(main_py_content)
        print("✅ Created main.py in root")
    
    # Ensure railway.json exists
    if not Path("railway.json").exists():
        railway_config = '''{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "python main.py",
    "healthcheckPath": "/api/v1/health",
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}'''
        with open("railway.json", "w") as f:
            f.write(railway_config)
        print("✅ Created railway.json")
    
    # Check what files are now in root
    print("\n📁 Files in root directory:")
    root_files = [f for f in os.listdir(".") if os.path.isfile(f)]
    for file in sorted(root_files):
        print(f"  ✅ {file}")
    
    print("\n📁 Directories in root:")
    root_dirs = [d for d in os.listdir(".") if os.path.isdir(d)]
    for dir_name in sorted(root_dirs):
        print(f"  📁 {dir_name}/")
    
    print("\n🎯 Railway should now detect:")
    print("  ✅ Python project (main.py)")
    print("  ✅ Dependencies (requirements.txt)")
    print("  ✅ FastAPI app (app/ directory)")
    print("  ✅ Railway config (railway.json)")
    
    return True

if __name__ == "__main__":
    fix_railway_deployment()
