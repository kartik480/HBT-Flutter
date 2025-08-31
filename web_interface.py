from flask import Flask, render_template, request, jsonify, session
import requests
import json
from datetime import datetime
import os

app = Flask(__name__)
app.secret_key = 'ai_teacher_secret_key_2024'

# Configuration
API_BASE_URL = "http://localhost:8000"
DEFAULT_USER_ID = 1  # For demo purposes

class AITeacherWeb:
    """Web interface for AI Teacher system"""
    
    def __init__(self):
        self.api_url = API_BASE_URL
        self.current_user_id = DEFAULT_USER_ID
    
    def create_user(self, name, preferences=None):
        """Create a new user"""
        try:
            response = requests.post(f"{self.api_url}/users", json={
                "name": name,
                "preferences": preferences or {}
            })
            if response.status_code == 200:
                data = response.json()
                self.current_user_id = data['user_id']
                return data
            return None
        except Exception as e:
            print(f"Error creating user: {e}")
            return None
    
    def add_habit(self, habit_name, description="", frequency="daily", reminder_time="morning"):
        """Add a new habit"""
        try:
            response = requests.post(f"{self.api_url}/users/{self.current_user_id}/habits", json={
                "name": habit_name,
                "description": description,
                "frequency": frequency,
                "reminder_time": reminder_time
            })
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error adding habit: {e}")
            return None
    
    def log_habit(self, habit_id, completed, mood=None, notes=None):
        """Log habit completion"""
        try:
            response = requests.post(f"{self.api_url}/habits/{habit_id}/log", json={
                "completed": completed,
                "mood": mood,
                "notes": notes
            })
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error logging habit: {e}")
            return None
    
    def ask_question(self, question, mood="neutral"):
        """Ask AI Teacher a question"""
        try:
            response = requests.post(f"{self.api_url}/ai/ask", json={
                "user_id": self.current_user_id,
                "question": question
            })
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error asking question: {e}")
            return None
    
    def get_insights(self):
        """Get user insights"""
        try:
            response = requests.get(f"{self.api_url}/ai/insights?user_id={self.current_user_id}")
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error getting insights: {e}")
            return None
    
    def get_progress(self, days=30):
        """Get user progress"""
        try:
            response = requests.get(f"{self.api_url}/ai/progress?user_id={self.current_user_id}&days={days}")
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error getting progress: {e}")
            return None
    
    def get_motivation(self, context=None):
        """Get motivational quote"""
        try:
            params = {"user_id": self.current_user_id}
            if context:
                params["context"] = context
            response = requests.get(f"{self.api_url}/ai/motivation", params=params)
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error getting motivation: {e}")
            return None
    
    def start_coaching(self, session_type="general"):
        """Start coaching session"""
        try:
            response = requests.post(f"{self.api_url}/ai/coaching", json={
                "user_id": self.current_user_id,
                "session_type": session_type
            })
            if response.status_code == 200:
                return response.json()
            return None
        except Exception as e:
            print(f"Error starting coaching: {e}")
            return None

# Initialize AI Teacher Web interface
ai_teacher_web = AITeacherWeb()

def create_basic_templates():
    """Create basic HTML templates for the web interface"""
    
    # Index template
    index_html = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Teacher - Your Personal AI Coach</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: white; margin-bottom: 40px; }
        .header h1 { font-size: 3rem; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .header p { font-size: 1.2rem; opacity: 0.9; }
        .features { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; margin-bottom: 40px; }
        .feature-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 30px; text-align: center; color: white; transition: transform 0.3s ease; }
        .feature-card:hover { transform: translateY(-10px); }
        .feature-card h3 { font-size: 1.5rem; margin-bottom: 15px; }
        .feature-card p { opacity: 0.8; line-height: 1.6; }
        .cta-buttons { text-align: center; }
        .btn { display: inline-block; padding: 15px 30px; margin: 10px; background: linear-gradient(45deg, #ff6b6b, #ee5a24); color: white; text-decoration: none; border-radius: 50px; font-weight: bold; transition: transform 0.3s ease; }
        .btn:hover { transform: scale(1.05); }
        .btn-secondary { background: linear-gradient(45deg, #4ecdc4, #44a08d); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 AI Teacher</h1>
            <p>Your Personal AI Coach for Habit Formation, Guidance, and Motivation</p>
        </div>
        
        <div class="features">
            <div class="feature-card">
                <h3>🧠 Intelligent Analysis</h3>
                <p>AI-powered habit analysis and pattern recognition to help you understand your behavior and optimize your routines.</p>
            </div>
            <div class="feature-card">
                <h3>💪 Personalized Coaching</h3>
                <p>Adaptive coaching that adjusts to your mood, progress, and preferences for maximum effectiveness.</p>
            </div>
            <div class="feature-card">
                <h3>⏰ Smart Reminders</h3>
                <p>Intelligent reminder system that learns your optimal times and adapts to your schedule.</p>
            </div>
            <div class="feature-card">
                <h3>📊 Progress Tracking</h3>
                <p>Comprehensive progress analysis with actionable insights and recommendations.</p>
            </div>
            <div class="feature-card">
                <h3>🎯 Goal Setting</h3>
                <p>Smart goal setting and habit formation strategies based on proven psychological principles.</p>
            </div>
            <div class="feature-card">
                <h3>🌟 Motivation</h3>
                <p>Personalized motivational content and quotes to keep you inspired and on track.</p>
            </div>
        </div>
        
        <div class="cta-buttons">
            <a href="/chat" class="btn">Start Chatting with AI Teacher</a>
            <a href="/habits" class="btn btn-secondary">Manage Your Habits</a>
            <a href="/insights" class="btn">View Your Insights</a>
            <a href="/coaching" class="btn btn-secondary">Start Coaching Session</a>
        </div>
    </div>
</body>
</html>'''
    
    # Chat template
    chat_html = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat with AI Teacher</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: white; margin-bottom: 30px; }
        .chat-container { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 20px; height: 500px; display: flex; flex-direction: column; }
        .chat-messages { flex: 1; overflow-y: auto; margin-bottom: 20px; padding: 10px; }
        .message { margin-bottom: 15px; padding: 15px; border-radius: 15px; max-width: 80%; }
        .user-message { background: linear-gradient(45deg, #4ecdc4, #44a08d); color: white; margin-left: auto; }
        .ai-message { background: rgba(255,255,255,0.2); color: white; }
        .chat-input { display: flex; gap: 10px; }
        .chat-input input { flex: 1; padding: 15px; border: none; border-radius: 25px; background: rgba(255,255,255,0.2); color: white; }
        .chat-input input::placeholder { color: rgba(255,255,255,0.7); }
        .chat-input button { padding: 15px 25px; border: none; border-radius: 25px; background: linear-gradient(45deg, #ff6b6b, #ee5a24); color: white; cursor: pointer; }
        .mood-selector { margin-bottom: 20px; text-align: center; }
        .mood-selector select { padding: 10px; border-radius: 15px; border: none; background: rgba(255,255,255,0.2); color: white; }
        .back-btn { display: inline-block; padding: 10px 20px; background: rgba(255,255,255,0.2); color: white; text-decoration: none; border-radius: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <a href="/" class="back-btn">← Back to Home</a>
        
        <div class="header">
            <h1>💬 Chat with AI Teacher</h1>
            <p>Ask questions, get guidance, and receive personalized coaching</p>
        </div>
        
        <div class="mood-selector">
            <label for="mood" style="color: white; margin-right: 10px;">How are you feeling?</label>
            <select id="mood">
                <option value="neutral">Neutral</option>
                <option value="positive">Happy/Positive</option>
                <option value="negative">Sad/Stressed</option>
            </select>
        </div>
        
        <div class="chat-container">
            <div class="chat-messages" id="chatMessages">
                <div class="message ai-message">
                    <strong>AI Teacher:</strong> Hello! I'm your AI Teacher and personal coach. How can I help you today? You can ask me about habits, motivation, goal setting, or anything else you'd like guidance on.
                </div>
            </div>
            
            <div class="chat-input">
                <input type="text" id="messageInput" placeholder="Ask me anything..." onkeypress="handleKeyPress(event)">
                <button onclick="sendMessage()">Send</button>
            </div>
        </div>
    </div>
    
    <script>
        function sendMessage() {
            const input = document.getElementById('messageInput');
            const message = input.value.trim();
            const mood = document.getElementById('mood').value;
            
            if (!message) return;
            
            // Add user message
            addMessage('You', message, 'user-message');
            input.value = '';
            
            // Send to API
            fetch('/api/ask_question', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ question: message, mood: mood })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const response = data.data;
                    let aiMessage = response.message;
                    
                    if (response.motivation) {
                        aiMessage += '\\n\\n💪 ' + response.motivation;
                    }
                    
                    if (response.suggestions && response.suggestions.length > 0) {
                        aiMessage += '\\n\\n💡 Suggestions:\\n' + response.suggestions.map(s => '• ' + s).join('\\n');
                    }
                    
                    addMessage('AI Teacher', aiMessage, 'ai-message');
                } else {
                    addMessage('AI Teacher', 'Sorry, I encountered an error. Please try again.', 'ai-message');
                }
            })
            .catch(error => {
                addMessage('AI Teacher', 'Sorry, I\'m having trouble connecting. Please check if the API is running.', 'ai-message');
            });
        }
        
        function addMessage(sender, text, className) {
            const messagesDiv = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${className}`;
            messageDiv.innerHTML = `<strong>${sender}:</strong> ${text.replace(/\\n/g, '<br>')}`;
            messagesDiv.appendChild(messageDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
        
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
    </script>
</body>
</html>'''
    
    # Write templates to files
    with open('templates/index.html', 'w', encoding='utf-8') as f:
        f.write(index_html)
    
    with open('templates/chat.html', 'w', encoding='utf-8') as f:
        f.write(chat_html)
    
    # Create other basic templates
    basic_template = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: white; margin-bottom: 30px; }
        .content { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 30px; color: white; }
        .back-btn { display: inline-block; padding: 10px 20px; background: rgba(255,255,255,0.2); color: white; text-decoration: none; border-radius: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <a href="/" class="back-btn">← Back to Home</a>
        <div class="header">
            <h1>{{ title }}</h1>
        </div>
        <div class="content">
            <p>This page is under construction. Check back soon for more features!</p>
        </div>
    </div>
</body>
</html>'''
    
    templates = [
        ('habits.html', 'Habit Management'),
        ('insights.html', 'Your Insights'),
        ('coaching.html', 'Coaching Sessions')
    ]
    
    for filename, title in templates:
        with open(f'templates/{filename}', 'w', encoding='utf-8') as f:
            f.write(basic_template.replace('{{ title }}', title))

@app.route('/')
def index():
    """Main page"""
    return render_template('index.html')

@app.route('/chat')
def chat():
    """Chat interface with AI Teacher"""
    return render_template('chat.html')

@app.route('/habits')
def habits():
    """Habit management page"""
    return render_template('habits.html')

@app.route('/insights')
def insights():
    """User insights and analysis page"""
    return render_template('insights.html')

@app.route('/coaching')
def coaching():
    """Coaching sessions page"""
    return render_template('coaching.html')

# API endpoints for the web interface

@app.route('/api/create_user', methods=['POST'])
def api_create_user():
    """Create a new user"""
    try:
        data = request.get_json()
        name = data.get('name', 'Anonymous User')
        preferences = data.get('preferences', {})
        
        result = ai_teacher_web.create_user(name, preferences)
        if result:
            session['user_id'] = result['user_id']
            session['user_name'] = name
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to create user"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/add_habit', methods=['POST'])
def api_add_habit():
    """Add a new habit"""
    try:
        data = request.get_json()
        result = ai_teacher_web.add_habit(
            habit_name=data.get('name'),
            description=data.get('description', ''),
            frequency=data.get('frequency', 'daily'),
            reminder_time=data.get('reminder_time', 'morning')
        )
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to add habit"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/ask_question', methods=['POST'])
def api_ask_question():
    """Ask AI Teacher a question"""
    try:
        data = request.get_json()
        question = data.get('question', '')
        mood = data.get('mood', 'neutral')
        
        if not question:
            return jsonify({"success": False, "error": "Question is required"})
        
        # Use the correct endpoint and parameter names
        result = ai_teacher_web.ask_question(question, mood)
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to get response"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/get_insights')
def api_get_insights():
    """Get user insights"""
    try:
        result = ai_teacher_web.get_insights()
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to get insights"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/get_progress')
def api_get_progress():
    """Get user progress"""
    try:
        days = request.args.get('days', 30, type=int)
        result = ai_teacher_web.get_progress(days)
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to get progress"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/get_motivation')
def api_get_motivation():
    """Get motivational quote"""
    try:
        context = request.args.get('context')
        result = ai_teacher_web.get_motivation(context)
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to get motivation"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/start_coaching', methods=['POST'])
def api_start_coaching():
    """Start coaching session"""
    try:
        data = request.get_json()
        session_type = data.get('session_type', 'general')
        
        result = ai_teacher_web.start_coaching(session_type)
        if result:
            return jsonify({"success": True, "data": result})
        else:
            return jsonify({"success": False, "error": "Failed to start coaching"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route('/api/health')
def api_health():
    """Check API health"""
    try:
        response = requests.get(f"{API_BASE_URL}/health")
        if response.status_code == 200:
            return jsonify({"success": True, "status": "API is healthy"})
        else:
            return jsonify({"success": False, "status": "API is not responding"})
    except Exception as e:
        return jsonify({"success": False, "status": f"API connection failed: {str(e)}"})

if __name__ == '__main__':
    # Create templates directory if it doesn't exist
    os.makedirs('templates', exist_ok=True)
    
    # Create basic HTML templates
    create_basic_templates()
    
    print("Starting AI Teacher Web Interface...")
    print(f"API URL: {API_BASE_URL}")
    print("Web Interface: http://localhost:5000")
    print("API Documentation: http://localhost:8000/docs")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
