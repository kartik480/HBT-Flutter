#!/usr/bin/env python3
"""
Test Railway Connection and Update Flutter App
"""

import re
import requests
from pathlib import Path

def test_railway_url(railway_url):
    """Test if Railway URL is working"""
    try:
        health_url = f"{railway_url}/api/v1/health"
        print(f"🧪 Testing: {health_url}")
        response = requests.get(health_url, timeout=10)
        if response.status_code == 200:
            print(f"✅ Railway API is working! Health check passed.")
            print(f"📊 Response: {response.json()}")
            return True
        else:
            print(f"⚠️ Railway API responded with status {response.status_code}")
            print(f"📊 Response: {response.text}")
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
    print("🚀 Railway Connection Tester")
    print("=" * 50)
    
    # Common Railway URL patterns
    possible_urls = [
        "https://daring-education-production.up.railway.app",
        "https://daring-education.up.railway.app",
        "https://daring-education-production.railway.app"
    ]
    
    print("🔍 Trying common Railway URL patterns...")
    
    working_url = None
    for url in possible_urls:
        print(f"\n🧪 Testing: {url}")
        if test_railway_url(url):
            working_url = url
            break
    
    if working_url:
        print(f"\n🎉 Found working Railway URL: {working_url}")
        print(f"\n🔧 Updating Flutter app...")
        if update_flutter_app(working_url):
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
        print("\n❌ No working Railway URL found.")
        print("Please check your Railway deployment and try again.")
        print("\n💡 Make sure:")
        print("1. Your Railway project is deployed")
        print("2. Environment variables are set")
        print("3. PostgreSQL database is connected")
        print("4. The deployment is successful")

if __name__ == "__main__":
    main()
