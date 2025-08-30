#!/usr/bin/env python3
"""
AI Integration Test Script
Tests the connection between Flutter app and AI server
"""

import requests
import json
import time

def test_server_health():
    """Test if the AI server is responding"""
    try:
        response = requests.get('http://localhost:8000/health', timeout=5)
        if response.status_code == 200:
            print("✅ Server health check passed")
            return True
        else:
            print(f"❌ Server health check failed: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Server health check failed: {e}")
        return False

def test_ai_ask():
    """Test the AI ask endpoint"""
    try:
        data = {
            "user_id": "test_user@example.com",
            "question": "Hello, how can you help me with my habits?"
        }
        response = requests.post(
            'http://localhost:8000/ai/ask',
            json=data,
            headers={'Content-Type': 'application/json'},
            timeout=10
        )
        
        if response.status_code == 200:
            result = response.json()
            print("✅ AI ask endpoint working")
            print(f"   Response: {result.get('response', 'No response')[:100]}...")
            return True
        else:
            print(f"❌ AI ask endpoint failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ AI ask endpoint failed: {e}")
        return False

def test_ai_insights():
    """Test the AI insights endpoint"""
    try:
        response = requests.get(
            'http://localhost:8000/ai/insights/test_user@example.com',
            timeout=10
        )
        
        if response.status_code == 200:
            result = response.json()
            print("✅ AI insights endpoint working")
            print(f"   Insights: {result.get('insights', 'No insights')[:100]}...")
            return True
        else:
            print(f"❌ AI insights endpoint failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ AI insights endpoint failed: {e}")
        return False

def test_motivational_quote():
    """Test the motivational quote endpoint"""
    try:
        response = requests.get(
            'http://localhost:8000/ai/motivational-quote',
            timeout=10
        )
        
        if response.status_code == 200:
            result = response.json()
            print("✅ Motivational quote endpoint working")
            print(f"   Quote: {result.get('quote', 'No quote')[:100]}...")
            return True
        else:
            print(f"❌ Motivational quote endpoint failed: {response.statusCode}")
            print(f"   Error: {response.text}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Motivational quote endpoint failed: {e}")
        return False

def main():
    """Run all tests"""
    print("🤖 AI Integration Test Suite")
    print("=" * 40)
    
    # Check if server is running
    print("\n1. Testing server availability...")
    if not test_server_health():
        print("\n❌ Server is not running!")
        print("Please start the AI server first:")
        print("   python start_ai_server.py")
        return
    
    print("\n2. Testing AI ask endpoint...")
    test_ai_ask()
    
    print("\n3. Testing AI insights endpoint...")
    test_ai_insights()
    
    print("\n4. Testing motivational quote endpoint...")
    test_motivational_quote()
    
    print("\n" + "=" * 40)
    print("🎯 Test Summary")
    print("If all tests passed, your AI server is ready!")
    print("You can now run your Flutter app and use the AI features.")
    print("\nNext steps:")
    print("1. Run: flutter run")
    print("2. Tap the AI icon (🧠) in the bottom right")
    print("3. Start chatting with your AI Teacher!")

if __name__ == "__main__":
    main()
