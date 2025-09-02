#!/usr/bin/env python3
"""
Quick Railway Setup Script
This script helps you set up your Railway deployment and update Flutter app
"""

import re
import requests
from pathlib import Path

def test_railway_url(railway_url):
    """Test if Railway URL is working"""
    try:
        health_url = f"{railway_url}/api/v1/health"
        response = requests.get(health_url, timeout=10)
        if response.status_code == 200:
            print(f"✅ Railway API is working! Health check passed.")
            return True
        else:
            print(f"⚠️ Railway API responded with status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Railway API test failed: {e}")
        return False

def update_flutter_app(railway_url):
    """Update Flutter app configuration with Railway URL"""
    
    # Remove trailing slash and ensure it ends with /api/v1
    if railway_url.endswith('/'):
        railway_url = railway_url[:-1]
    
    if not railway_url.endswith('/api/v1'):
        railway_url = f"{railway_url}/api/v1"
    
    print(f"🚀 Updating Flutter app to use Railway URL: {railway_url}")
    
    # Update app_config.dart
    config_file = Path("lib/config/app_config.dart")
    if config_file.exists():
        content = config_file.read_text()
        
        # Update API base URL
        content = re.sub(
            r'static const String apiBaseUrl = \'[^\']*\';',
            f'static const String apiBaseUrl = \'{railway_url}\';',
            content
        )
        
        # Disable mock authentication
        content = re.sub(
            r'static const bool enableMockAuth = true;',
            'static const bool enableMockAuth = false;',
            content
        )
        
        config_file.write_text(content)
        print("✅ Updated lib/config/app_config.dart")
        return True
    else:
        print("❌ lib/config/app_config.dart not found!")
        return False

def main():
    print("🚀 Quick Railway Setup")
    print("=" * 50)
    
    # Get Railway URL from user
    railway_url = input("Enter your Railway URL (e.g., https://your-app.up.railway.app): ").strip()
    
    if not railway_url:
        print("❌ No URL provided!")
        return
    
    if not railway_url.startswith('http'):
        railway_url = f"https://{railway_url}"
    
    print(f"\n🧪 Testing Railway API...")
    if test_railway_url(railway_url):
        print(f"\n🔧 Updating Flutter app...")
        if update_flutter_app(railway_url):
            print("\n🎉 Setup Complete!")
            print("📱 Your Flutter app is now connected to Railway!")
            print("\n🧪 Next steps:")
            print("1. Run: flutter run -d windows")
            print("2. Try registering a new account")
            print("3. Try logging in")
            print("4. Check if data persists")
        else:
            print("❌ Failed to update Flutter app")
    else:
        print("❌ Railway API is not working. Please check your deployment.")

if __name__ == "__main__":
    main()
