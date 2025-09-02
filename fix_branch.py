#!/usr/bin/env python3
"""
Fix Git Branch for Railway Deployment
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

def fix_branch():
    """Fix git branch for Railway deployment"""
    
    print("🔧 Fixing git branch for Railway deployment...")
    
    # Check current branch
    print("📁 Checking current branch...")
    run_command("git branch")
    
    # Rename master to main
    print("\n🔄 Renaming master branch to main...")
    if not run_command("git branch -m master main"):
        print("❌ Failed to rename branch")
        return False
    
    # Push main branch to GitHub
    print("\n📤 Pushing main branch to GitHub...")
    if not run_command("git push -u origin main"):
        print("❌ Failed to push main branch")
        return False
    
    # Delete old master branch from GitHub
    print("\n🗑️ Deleting old master branch from GitHub...")
    run_command("git push origin --delete master")
    
    print("\n✅ Successfully fixed git branch!")
    print("🎯 Railway should now see the files in the main branch!")
    
    return True

if __name__ == "__main__":
    fix_branch()
