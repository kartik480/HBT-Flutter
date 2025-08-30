#!/usr/bin/env python3
"""
Test script for OpenRouter API integration
This script tests the OpenRouter API connection and response handling.
"""

import requests
import json

def test_openrouter_api():
    """Test the OpenRouter API connection"""
    
    # API configuration
    api_key = "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"
    url = "https://openrouter.ai/api/v1/chat/completions"
    
    # Test message
    messages = [
        {
            "role": "system", 
            "content": "You are an AI Teacher specializing in habit formation and personal development. Be concise and encouraging."
        },
        {
            "role": "user", 
            "content": "I need motivation to exercise regularly. Can you help me?"
        }
    ]
    
    # Request data
    data = {
        "model": "x-ai/grok-code-fast-1",
        "messages": messages,
        "max_tokens": 200,
        "temperature": 0.7
    }
    
    # Headers
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://habit-tracker-app.com",
        "X-Title": "Habit Tracker AI Teacher",
    }
    
    try:
        print("🧪 Testing OpenRouter API...")
        print(f"📡 URL: {url}")
        print(f"🤖 Model: {data['model']}")
        print(f"💬 Messages: {len(messages)}")
        print("-" * 50)
        
        # Make the request
        response = requests.post(
            url=url,
            headers=headers,
            data=json.dumps(data),
            timeout=30
        )
        
        print(f"📊 Status Code: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            ai_response = result['choices'][0]['message']['content']
            
            print("✅ API call successful!")
            print(f"🤖 AI Response: {ai_response}")
            
            # Test additional features
            print("\n🧪 Testing additional features...")
            
            # Test with different model
            data["model"] = "anthropic/claude-3-haiku"
            response2 = requests.post(
                url=url,
                headers=headers,
                data=json.dumps(data),
                timeout=30
            )
            
            if response2.status_code == 200:
                result2 = response2.json()
                ai_response2 = result2['choices'][0]['message']['content']
                print(f"✅ Claude model test successful!")
                print(f"🤖 Claude Response: {ai_response2[:100]}...")
            else:
                print(f"❌ Claude model test failed: {response2.status_code}")
                
        else:
            print(f"❌ API call failed: {response.status_code}")
            print(f"📝 Response: {response.text}")
            
    except requests.exceptions.Timeout:
        print("⏰ Request timed out")
    except requests.exceptions.RequestException as e:
        print(f"❌ Request error: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

def test_ai_teacher_integration():
    """Test the AI Teacher integration with OpenRouter"""
    try:
        print("\n🧪 Testing AI Teacher integration...")
        
        # Import AI Teacher
        from ai_teacher import AITeacher
        
        # Create AI Teacher instance
        ai_teacher = AITeacher()
        
        # Test query processing
        test_query = "I need help building a morning routine"
        user_id = 1
        
        print(f"👤 User Query: {test_query}")
        
        # Process query
        response = ai_teacher.process_query(user_id, test_query)
        
        print("✅ AI Teacher response generated!")
        print(f"🤖 Response: {response.get('message', 'No message')}")
        print(f"📊 Intent: {response.get('intent', 'Unknown')}")
        print(f"😊 Sentiment: {response.get('sentiment', 'Unknown')}")
        
    except ImportError as e:
        print(f"❌ Could not import AI Teacher: {e}")
    except Exception as e:
        print(f"❌ AI Teacher test failed: {e}")

if __name__ == "__main__":
    print("🚀 OpenRouter API Integration Test")
    print("=" * 50)
    
    # Test OpenRouter API directly
    test_openrouter_api()
    
    # Test AI Teacher integration
    test_ai_teacher_integration()
    
    print("\n✨ Test completed!")
