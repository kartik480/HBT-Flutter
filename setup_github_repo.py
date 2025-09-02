#!/usr/bin/env python3
"""
Setup GitHub Repository for Railway Deployment
"""

import subprocess
import webbrowser
import os

def run_command(command):
    """Run a command and return the result"""
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def setup_github_repo():
    """Setup GitHub repository for Railway deployment"""
    
    print("🚀 Setting up GitHub repository for Railway deployment...")
    
    # Check if we're in a git repository
    success, stdout, stderr = run_command("git status")
    if not success:
        print("❌ Not in a git repository!")
        return False
    
    # Check current remote
    success, stdout, stderr = run_command("git remote -v")
    if success:
        print(f"📡 Current remote: {stdout}")
    
    # Add all files
    print("📁 Adding all files to git...")
    success, stdout, stderr = run_command("git add .")
    if not success:
        print(f"❌ Failed to add files: {stderr}")
        return False
    
    # Commit changes
    print("💾 Committing changes...")
    success, stdout, stderr = run_command('git commit -m "Add Railway deployment files"')
    if not success:
        print(f"❌ Failed to commit: {stderr}")
        return False
    
    print("✅ Files committed successfully!")
    
    # Instructions for GitHub
    print("\n🎯 Next steps:")
    print("1. Go to https://github.com/new")
    print("2. Create a new repository named 'HBT-Flutter'")
    print("3. Make it public")
    print("4. Don't initialize with README")
    print("5. Copy the repository URL")
    print("6. Run: git remote add origin <your-repo-url>")
    print("7. Run: git push -u origin master")
    print("8. Then deploy to Railway using the GitHub repo")
    
    # Open GitHub in browser
    try:
        webbrowser.open("https://github.com/new")
        print("🌐 Opened GitHub in your browser!")
    except:
        print("🌐 Please manually go to https://github.com/new")
    
    return True

if __name__ == "__main__":
    setup_github_repo()
