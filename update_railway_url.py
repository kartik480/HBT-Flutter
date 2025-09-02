#!/usr/bin/env python3
"""
Update Flutter app to use Railway API URL
"""

import re
from pathlib import Path

def update_railway_url(railway_url):
    """Update the Flutter app configuration with Railway URL"""
    
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
    else:
        print("❌ lib/config/app_config.dart not found!")
        return False
    
    print("\n🎉 Flutter app updated successfully!")
    print("📱 Your app will now connect to the Railway backend!")
    print("\n🧪 Test your app:")
    print("1. Run: flutter run -d windows")
    print("2. Try registering a new account")
    print("3. Try logging in")
    print("4. Check if data persists")
    
    return True

if __name__ == "__main__":
    print("🚀 Railway URL Updater")
    print("=" * 50)
    
    # Get Railway URL from user
    railway_url = input("Enter your Railway URL (e.g., https://your-app.up.railway.app): ").strip()
    
    if not railway_url:
        print("❌ No URL provided!")
        exit(1)
    
    if not railway_url.startswith('http'):
        railway_url = f"https://{railway_url}"
    
    update_railway_url(railway_url)
