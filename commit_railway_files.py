#!/usr/bin/env python3
"""
Commit Railway files to git
"""

import subprocess
import sys

def run_command(command):
    """Run a command"""
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

def main():
    print("🚀 Committing Railway files to git...")
    
    # Add all files
    if not run_command("git add ."):
        print("❌ Failed to add files")
        return
    
    # Commit
    if not run_command('git commit -m "Add Railway deployment files"'):
        print("❌ Failed to commit")
        return
    
    # Push
    if not run_command("git push origin master"):
        print("❌ Failed to push")
        return
    
    print("✅ Successfully committed and pushed Railway files!")
    print("\n🎯 Now go to Railway and redeploy your project!")

if __name__ == "__main__":
    main()
