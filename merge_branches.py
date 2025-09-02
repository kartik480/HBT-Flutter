#!/usr/bin/env python3
"""
Merge Master Branch into Main for Railway Deployment
"""

import subprocess
import sys

def run_command(command):
    """Run a command and return the result"""
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        print(f"Running: {command}")
        if result.stdout:
            print(f"Output: {result.stdout}")
        if result.stderr:
            print(f"Error: {result.stderr}")
        return result.returncode == 0
    except Exception as e:
        print(f"Exception: {e}")
        return False

def merge_branches():
    """Merge master branch into main for Railway deployment"""
    
    print("🔧 Merging master branch into main for Railway deployment...")
    
    # Check current branch
    print("📁 Checking current branch...")
    run_command("git branch")
    
    # Switch to main branch
    print("\n🔄 Switching to main branch...")
    if not run_command("git checkout main"):
        print("❌ Failed to switch to main branch")
        return False
    
    # Pull latest changes from remote main
    print("\n📥 Pulling latest changes from remote main...")
    if not run_command("git pull origin main"):
        print("❌ Failed to pull from remote main")
        return False
    
    # Merge master into main
    print("\n🔀 Merging master branch into main...")
    if not run_command("git merge master"):
        print("❌ Failed to merge master into main")
        return False
    
    # Push merged main branch to GitHub
    print("\n📤 Pushing merged main branch to GitHub...")
    if not run_command("git push origin main"):
        print("❌ Failed to push merged main branch")
        return False
    
    print("\n✅ Successfully merged master into main!")
    print("🎯 Railway should now see all the files in the main branch!")
    
    return True

if __name__ == "__main__":
    merge_branches()
