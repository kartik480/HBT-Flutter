#!/usr/bin/env python3
"""
Fix Git Repository for Railway Deployment
"""

import os
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

def fix_git_repo():
    """Fix git repository for Railway deployment"""
    
    print("🔧 Fixing git repository for Railway deployment...")
    
    # Check if we're in a git repository
    if not run_command("git status"):
        print("❌ Not in a git repository!")
        return False
    
    # Check what files are in the repository
    print("\n📁 Checking files in repository...")
    run_command("git ls-files")
    
    # Add all files
    print("\n📁 Adding all files to git...")
    if not run_command("git add ."):
        print("❌ Failed to add files")
        return False
    
    # Check what files are now staged
    print("\n📁 Checking staged files...")
    run_command("git status --porcelain")
    
    # Commit changes
    print("\n💾 Committing changes...")
    if not run_command('git commit -m "Add Railway deployment files - fix deployment"'):
        print("❌ Failed to commit")
        return False
    
    # Push to GitHub
    print("\n📤 Pushing to GitHub...")
    if not run_command("git push origin master"):
        print("❌ Failed to push")
        return False
    
    print("\n✅ Successfully fixed git repository!")
    print("🎯 Railway should now see the Python files!")
    
    return True

if __name__ == "__main__":
    fix_git_repo()
