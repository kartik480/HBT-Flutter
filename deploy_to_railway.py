#!/usr/bin/env python3
"""
Deploy to Railway - Final setup script
"""

import os
import subprocess
import sys

def run_command(command):
    """Run a command and return the result"""
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def deploy_to_railway():
    """Deploy the project to Railway"""
    
    print("🚀 Deploying to Railway...")
    
    # Check if we're in a git repository
    success, stdout, stderr = run_command("git status")
    if not success:
        print("❌ Not in a git repository!")
        return False
    
    # Add all files
    print("📁 Adding files to git...")
    success, stdout, stderr = run_command("git add .")
    if not success:
        print(f"❌ Failed to add files: {stderr}")
        return False
    
    # Commit changes
    print("💾 Committing changes...")
    success, stdout, stderr = run_command('git commit -m "Fix Railway deployment - add all required files"')
    if not success:
        print(f"❌ Failed to commit: {stderr}")
        return False
    
    # Push to GitHub
    print("📤 Pushing to GitHub...")
    success, stdout, stderr = run_command("git push origin master")
    if not success:
        print(f"❌ Failed to push: {stderr}")
        return False
    
    print("✅ Successfully pushed to GitHub!")
    print("\n🎯 Next steps:")
    print("1. Go to your Railway dashboard")
    print("2. Redeploy your project (or delete and recreate)")
    print("3. Railway should now detect the Python files")
    print("4. Add environment variables")
    print("5. Add PostgreSQL database")
    
    return True

if __name__ == "__main__":
    deploy_to_railway()
