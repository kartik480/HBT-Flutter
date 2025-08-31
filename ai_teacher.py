import json
import datetime
import random
import re
import requests
from typing import Dict, List, Optional, Tuple
import numpy as np
from dataclasses import dataclass, asdict
import sqlite3
import threading
import time
from pathlib import Path

# Simulated ML/NLP components (in a real implementation, you'd use actual libraries)
class NLPProcessor:
    """Natural Language Processing for understanding user queries and generating responses"""
    
    def __init__(self):
        self.intent_patterns = {
            'motivation': [r'motivate', r'inspire', r'encourage', r'boost', r'energy'],
            'guidance': [r'help', r'guide', r'advice', r'suggest', r'recommend'],
            'reminder': [r'remind', r'remember', r'alert', r'notify'],
            'analysis': [r'analyze', r'review', r'assess', r'evaluate', r'progress'],
            'goal_setting': [r'goal', r'target', r'objective', r'plan', r'strategy'],
            'habit_formation': [r'habit', r'routine', r'consistency', r'discipline'],
            'stress_relief': [r'stress', r'anxiety', r'relax', r'calm', r'peace'],
            'productivity': [r'productive', r'efficient', r'focus', r'concentrate'],
            'health': [r'health', r'fitness', r'wellness', r'exercise', r'diet'],
            'learning': [r'learn', r'study', r'knowledge', r'skill', r'improve']
        }
        
        self.sentiment_patterns = {
            'positive': [r'good', r'great', r'excellent', r'amazing', r'wonderful', r'happy'],
            'negative': [r'bad', r'terrible', r'awful', r'sad', r'depressed', r'angry'],
            'neutral': [r'okay', r'fine', r'alright', r'normal', r'usual']
        }
    
    def analyze_intent(self, text: str) -> Dict[str, float]:
        """Analyze user text to determine intent and confidence scores"""
        text_lower = text.lower()
        intent_scores = {}
        
        for intent, patterns in self.intent_patterns.items():
            score = 0
            for pattern in patterns:
                matches = len(re.findall(pattern, text_lower))
                score += matches * 0.3
            intent_scores[intent] = min(score, 1.0)
        
        return intent_scores
    
    def analyze_sentiment(self, text: str) -> str:
        """Analyze sentiment of user text"""
        text_lower = text.lower()
        sentiment_scores = {'positive': 0, 'negative': 0, 'neutral': 0}
        
        for sentiment, patterns in self.sentiment_patterns.items():
            for pattern in patterns:
                matches = len(re.findall(pattern, text_lower))
                sentiment_scores[sentiment] += matches
        
        if sentiment_scores['positive'] > sentiment_scores['negative']:
            return 'positive'
        elif sentiment_scores['negative'] > sentiment_scores['positive']:
            return 'negative'
        else:
            return 'neutral'
    
    def extract_entities(self, text: str) -> Dict[str, List[str]]:
        """Extract key entities from text (habits, goals, time references, etc.)"""
        entities = {
            'habits': [],
            'goals': [],
            'time_references': [],
            'emotions': [],
            'numbers': []
        }
        
        # Extract habits (common habit patterns)
        habit_patterns = [
            r'exercise', r'meditation', r'reading', r'writing', r'learning',
            r'workout', r'study', r'practice', r'walk', r'run', r'sleep',
            r'water', r'vitamins', r'journal', r'planning', r'cleaning'
        ]
        
        for pattern in habit_patterns:
            if re.search(pattern, text.lower()):
                entities['habits'].append(pattern)
        
        # Extract time references
        time_patterns = [
            r'\d+ (hour|minute|day|week|month)s?',
            r'tomorrow', r'today', r'next week', r'this month',
            r'morning', r'afternoon', r'evening', r'night'
        ]
        
        for pattern in time_patterns:
            matches = re.findall(pattern, text.lower())
            entities['time_references'].extend(matches)
        
        # Extract numbers
        numbers = re.findall(r'\d+', text)
        entities['numbers'] = numbers
        
        return entities

class HabitAnalyzer:
    """ML-based habit analysis and pattern recognition"""
    
    def __init__(self):
        self.habit_patterns = {}
        self.success_factors = {}
        self.recommendation_weights = {
            'consistency': 0.4,
            'time_of_day': 0.2,
            'duration': 0.15,
            'environment': 0.15,
            'mood': 0.1
        }
    
    def analyze_habit_patterns(self, habit_data: List[Dict]) -> Dict:
        """Analyze habit data to find patterns and success factors"""
        if not habit_data:
            return {}
        
        analysis = {
            'best_times': {},
            'success_rate': {},
            'consistency_score': {},
            'recommendations': []
        }
        
        # Analyze best times for habits
        time_success = {}
        for entry in habit_data:
            time = entry.get('time_of_day', 'unknown')
            success = entry.get('completed', False)
            
            if time not in time_success:
                time_success[time] = {'success': 0, 'total': 0}
            
            time_success[time]['total'] += 1
            if success:
                time_success[time]['success'] += 1
        
        for time, data in time_success.items():
            success_rate = data['success'] / data['total'] if data['total'] > 0 else 0
            analysis['best_times'][time] = success_rate
        
        # Calculate consistency scores
        habit_consistency = {}
        for entry in habit_data:
            habit = entry.get('habit_name', 'unknown')
            if habit not in habit_consistency:
                habit_consistency[habit] = []
            habit_consistency[habit].append(entry.get('completed', False))
        
        for habit, completions in habit_consistency.items():
            if completions:
                consistency = sum(completions) / len(completions)
                analysis['consistency_score'][habit] = consistency
        
        # Generate recommendations
        analysis['recommendations'] = self._generate_recommendations(analysis)
        
        return analysis
    
    def _generate_recommendations(self, analysis: Dict) -> List[str]:
        """Generate personalized recommendations based on analysis"""
        recommendations = []
        
        # Time-based recommendations
        best_times = analysis.get('best_times', {})
        if best_times:
            best_time = max(best_times.items(), key=lambda x: x[1])
            recommendations.append(f"Try to schedule your most important habits around {best_time[0]} for better success rates.")
        
        # Consistency recommendations
        consistency_scores = analysis.get('consistency_score', {})
        if consistency_scores:
            low_consistency = [h for h, s in consistency_scores.items() if s < 0.5]
            if low_consistency:
                recommendations.append(f"Focus on building consistency for: {', '.join(low_consistency[:3])}")
        
        # General habit formation advice
        recommendations.extend([
            "Start with small, achievable goals to build momentum.",
            "Use habit stacking - link new habits to existing routines.",
            "Track your progress to stay motivated and identify patterns.",
            "Celebrate small wins to reinforce positive behavior."
        ])
        
        return recommendations[:5]  # Limit to top 5 recommendations

class PersonalizedCoach:
    """AI coach that provides personalized guidance and motivation"""
    
    def __init__(self):
        self.user_profile = {}
        self.coaching_style = 'adaptive'
        self.motivational_quotes = [
            "The only bad workout is the one that didn't happen.",
            "Small progress is still progress.",
            "Your future self is watching you right now through memories.",
            "Discipline is choosing between what you want now and what you want most.",
            "Every expert was once a beginner.",
            "The difference between try and triumph is just a little umph!",
            "Success is not final, failure is not fatal: it is the courage to continue that counts.",
            "The only way to do great work is to love what you do."
        ]
        
        self.coaching_approaches = {
            'motivational': [
                "You've got this! Remember why you started.",
                "Every step forward is progress, no matter how small.",
                "Your future self will thank you for today's efforts."
            ],
            'analytical': [
                "Let's analyze what's working and what needs adjustment.",
                "Based on your data, here are the key insights.",
                "Consider these factors for optimal habit formation."
            ],
            'supportive': [
                "It's okay to have off days. What matters is getting back up.",
                "You're doing better than you think. Let's review your progress.",
                "Remember, building habits is a journey, not a destination."
            ],
            'challenging': [
                "Are you really giving it your all, or just going through the motions?",
                "Your goals don't care about your excuses. What's your next move?",
                "The only person you're competing with is yourself from yesterday."
            ]
        }
    
    def get_personalized_message(self, user_context: Dict, intent: str) -> str:
        """Generate personalized coaching message based on user context and intent"""
        user_mood = user_context.get('mood', 'neutral')
        recent_progress = user_context.get('recent_progress', 'stable')
        habit_streak = user_context.get('habit_streak', 0)
        
        # Choose coaching approach based on context
        if user_mood == 'negative' or recent_progress == 'declining':
            approach = 'supportive'
        elif habit_streak > 7:
            approach = 'challenging'
        elif intent == 'motivation':
            approach = 'motivational'
        else:
            approach = 'analytical'
        
        # Get base message
        base_message = random.choice(self.coaching_approaches[approach])
        
        # Personalize based on context
        if habit_streak > 0:
            base_message += f" You're on a {habit_streak}-day streak - that's amazing!"
        
        if user_mood == 'positive':
            base_message += " Your positive energy is contagious!"
        elif user_mood == 'negative':
            base_message += " Remember, tough times don't last, but tough people do."
        
        return base_message
    
    def get_motivational_quote(self, context: str = None) -> str:
        """Get a motivational quote, optionally contextualized"""
        quote = random.choice(self.motivational_quotes)
        
        if context:
            if 'exercise' in context.lower():
                quote += " 💪"
            elif 'study' in context.lower():
                quote += " 📚"
            elif 'health' in context.lower():
                quote += " 🌟"
        
        return quote

class SmartReminder:
    """Intelligent reminder system that adapts to user behavior"""
    
    def __init__(self):
        self.reminder_types = {
            'gentle': "Just a friendly reminder: {habit}",
            'motivational': "Time to {habit}! You've got this! 💪",
            'progress': "Don't break your {habit} streak! You're at {streak} days!",
            'challenge': "Ready to tackle {habit}? Let's make today count!",
            'supportive': "Remember your {habit} goal. Small steps lead to big changes."
        }
        
        self.optimal_timing = {
            'morning': ['meditation', 'exercise', 'planning', 'reading'],
            'afternoon': ['workout', 'learning', 'practice'],
            'evening': ['reflection', 'planning', 'relaxation'],
            'night': ['preparation', 'journaling']
        }
    
    def generate_reminder(self, habit: str, context: Dict) -> str:
        """Generate contextual reminder message"""
        reminder_type = self._choose_reminder_type(context)
        streak = context.get('streak', 0)
        
        if reminder_type == 'progress' and streak > 0:
            message = self.reminder_types[reminder_type].format(
                habit=habit, streak=streak
            )
        else:
            message = self.reminder_types[reminder_type].format(habit=habit)
        
        return message
    
    def _choose_reminder_type(self, context: Dict) -> str:
        """Choose appropriate reminder type based on context"""
        mood = context.get('mood', 'neutral')
        recent_success = context.get('recent_success', True)
        streak = context.get('streak', 0)
        
        if mood == 'negative':
            return 'supportive'
        elif streak > 5:
            return 'progress'
        elif not recent_success:
            return 'motivational'
        elif random.random() < 0.3:
            return 'challenge'
        else:
            return 'gentle'
    
    def get_optimal_reminder_time(self, habit: str, user_schedule: Dict) -> str:
        """Determine optimal time to send reminder based on habit and user schedule"""
        for time_slot, habits in self.optimal_timing.items():
            if habit.lower() in [h.lower() for h in habits]:
                return time_slot
        
        # Default to user's preferred time or morning
        return user_schedule.get('preferred_time', 'morning')

class DataManager:
    """Manages user data, habits, and learning from interactions"""
    
    def __init__(self, db_path: str = "ai_teacher.db"):
        self.db_path = db_path
        self.init_database()
    
    def init_database(self):
        """Initialize database with required tables"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Users table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                name TEXT,
                preferences TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Habits table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS habits (
                id INTEGER PRIMARY KEY,
                user_id INTEGER,
                name TEXT,
                description TEXT,
                frequency TEXT,
                reminder_time TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id)
            )
        ''')
        
        # Habit_logs table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS habit_logs (
                id INTEGER PRIMARY KEY,
                habit_id INTEGER,
                completed BOOLEAN,
                mood TEXT,
                notes TEXT,
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (habit_id) REFERENCES habits (id)
            )
        ''')
        
        # Interactions table
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS interactions (
                id INTEGER PRIMARY KEY,
                user_id INTEGER,
                query TEXT,
                response TEXT,
                intent TEXT,
                sentiment TEXT,
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id)
            )
        ''')
        
        conn.commit()
        conn.close()
    
    def add_user(self, name: str, preferences: Dict = None) -> int:
        """Add new user and return user ID"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        preferences_json = json.dumps(preferences) if preferences else '{}'
        cursor.execute(
            'INSERT INTO users (name, preferences) VALUES (?, ?)',
            (name, preferences_json)
        )
        
        user_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return user_id
    
    def add_habit(self, user_id: int, name: str, description: str = "", 
                  frequency: str = "daily", reminder_time: str = "morning") -> int:
        """Add new habit for user"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            '''INSERT INTO habits (user_id, name, description, frequency, reminder_time) 
               VALUES (?, ?, ?, ?, ?)''',
            (user_id, name, description, frequency, reminder_time)
        )
        
        habit_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return habit_id
    
    def log_habit_completion(self, habit_id: int, completed: bool, 
                           mood: str = None, notes: str = None):
        """Log habit completion status"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            '''INSERT INTO habit_logs (habit_id, completed, mood, notes) 
               VALUES (?, ?, ?, ?)''',
            (habit_id, completed, mood, notes)
        )
        
        conn.commit()
        conn.close()
    
    def get_habit_data(self, user_id: int, days: int = 30) -> List[Dict]:
        """Get habit data for analysis"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT h.name, hl.completed, hl.mood, hl.timestamp
            FROM habits h
            JOIN habit_logs hl ON h.id = hl.habit_id
            WHERE h.user_id = ? AND hl.timestamp >= datetime('now', '-{} days')
            ORDER BY hl.timestamp DESC
        '''.format(days), (user_id,))
        
        rows = cursor.fetchall()
        conn.close()
        
        data = []
        for row in rows:
            data.append({
                'habit_name': row[0],
                'completed': bool(row[1]),
                'mood': row[2],
                'timestamp': row[3]
            })
        
        return data
    
    def save_interaction(self, user_id: int, query: str, response: str, 
                        intent: str, sentiment: str):
        """Save user interaction for learning"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            '''INSERT INTO interactions (user_id, query, response, intent, sentiment) 
               VALUES (?, ?, ?, ?, ?)''',
            (user_id, query, response, intent, sentiment)
        )
        
        conn.commit()
        conn.close()

class AITeacher:
    """Main AI Teacher class that orchestrates all components"""
    
    def __init__(self):
        self.nlp = NLPProcessor()
        self.analyzer = HabitAnalyzer()
        self.coach = PersonalizedCoach()
        self.reminder = SmartReminder()
        self.data_manager = DataManager()
        
        # OpenRouter API configuration
        self.openrouter_api_key = "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"
        self.openrouter_url = "https://openrouter.ai/api/v1/chat/completions"
        
        self.active_users = {}
        self.learning_thread = None
        self.start_learning_thread()
    
    def _call_openrouter_api(self, messages: List[Dict[str, str]], model: str = "google/gemini-2.5-pro") -> str:
        """Call OpenRouter API to get AI response using Google Gemini 2.5 Pro"""
        try:
            headers = {
                "Authorization": f"Bearer {self.openrouter_api_key}",
                "Content-Type": "application/json",
                "HTTP-Referer": "https://habit-tracker-app.com",
                "X-Title": "Habit Tracker AI Teacher",
            }
            
            # Format messages for Gemini 2.5 Pro
            formatted_messages = []
            for msg in messages:
                if msg['role'] == 'system':
                    # Convert system message to user message for Gemini
                    formatted_messages.append({
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": msg['content']
                            }
                        ]
                    })
                else:
                    formatted_messages.append({
                        "role": msg['role'],
                        "content": [
                            {
                                "type": "text",
                                "text": msg['content']
                            }
                        ]
                    })
            
            data = {
                "model": model,
                "messages": formatted_messages,
                "max_tokens": 1200,  # Increased for better responses
                "temperature": 0.8,   # Slightly higher for more creative responses
                "top_p": 0.9,        # Add top_p for better response quality
                "frequency_penalty": 0.1,  # Reduce repetition
                "presence_penalty": 0.1    # Encourage more diverse responses
            }
            
            response = requests.post(
                url=self.openrouter_url,
                headers=headers,
                data=json.dumps(data),
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                if 'choices' in result and len(result['choices']) > 0:
                    content = result['choices'][0]['message']['content']
                    print(f"OpenRouter API success: Got response of length {len(content)}")
                    return content
                else:
                    print(f"OpenRouter API returned unexpected format: {result}")
                    return None
            else:
                print(f"OpenRouter API error: {response.status_code} - {response.text}")
                return None
                
        except Exception as e:
            print(f"Error calling OpenRouter API: {e}")
            return None

    def start_learning_thread(self):
        """Start background thread for continuous learning"""
        def learning_loop():
            while True:
                try:
                    self._learn_from_interactions()
                    time.sleep(3600)  # Learn every hour
                except Exception as e:
                    print(f"Learning error: {e}")
                    time.sleep(3600)
        
        self.learning_thread = threading.Thread(target=learning_loop, daemon=True)
        self.learning_thread.start()
    
    def process_query(self, user_id: int, query: str, context: Dict = None) -> Dict:
        """Process user query and return comprehensive response"""
        # Analyze user intent and sentiment
        intent_scores = self.nlp.analyze_intent(query)
        sentiment = self.nlp.analyze_sentiment(query)
        entities = self.nlp.extract_entities(query)
        
        # Get user context and habit data
        user_context = self._get_user_context(user_id, context)
        
        # Try to get response from OpenRouter API first
        system_message = f"""You are an AI Teacher specializing in habit formation, personal development, and motivation. 

Your role is to provide helpful, encouraging, and practical advice to help users build better habits and achieve their goals.

User Context: {user_context}

Key Principles:
- Start small and build gradually
- Focus on consistency over perfection
- Celebrate small wins and progress
- Provide actionable, specific advice
- Be encouraging and supportive
- Use emojis and formatting to make responses engaging
- Always respond to the specific question asked
- Provide unique, personalized advice based on the user's context
- Avoid generic responses - make each answer specific to their situation

Current User Query: {query}

Please provide a helpful, motivating response that directly addresses their specific question while incorporating habit-building principles. Make sure your response is:
1. Directly relevant to what they asked
2. Specific and actionable
3. Encouraging and motivating
4. Personalized to their context
5. Not generic or repetitive"""
        
        messages = [
            {"role": "system", "content": system_message},
            {"role": "user", "content": query}
        ]
        
        ai_response = self._call_openrouter_api(messages)
        
        if ai_response and len(ai_response.strip()) > 20:  # Only use if response is substantial
            # Use AI response from OpenRouter
            print(f"Using OpenRouter API response: {ai_response[:100]}...")
            response = {
                'message': ai_response,
                'suggestions': [],
                'reminders': [],
                'motivation': '',
                'analysis': None
            }
        else:
            # Enhanced fallback to local processing if API fails
            print(f"API response insufficient, using enhanced local fallback. API response: {ai_response}")
            primary_intent = max(intent_scores.items(), key=lambda x: x[1])[0] if intent_scores else 'general'
            response = self._generate_enhanced_response(primary_intent, user_context, entities, query)
        
        # Save interaction for learning
        self.data_manager.save_interaction(user_id, query, response['message'], 
                                         primary_intent if 'primary_intent' in locals() else 'ai_generated', sentiment)
        
        return response
    
    def _get_user_context(self, user_id: int, context: Dict = None) -> Dict:
        """Get comprehensive user context"""
        user_context = {
            'mood': context.get('mood', 'neutral') if context else 'neutral',
            'recent_progress': 'stable',
            'habit_streak': 0,
            'recent_success': True
        }
        
        # Get habit data for analysis
        habit_data = self.data_manager.get_habit_data(user_id, days=7)
        if habit_data:
            analysis = self.analyzer.analyze_habit_patterns(habit_data)
            
            # Calculate recent progress
            recent_completions = [h['completed'] for h in habit_data[-5:]]
            if recent_completions:
                success_rate = sum(recent_completions) / len(recent_completions)
                if success_rate > 0.7:
                    user_context['recent_progress'] = 'improving'
                elif success_rate < 0.3:
                    user_context['recent_progress'] = 'declining'
                
                user_context['recent_success'] = success_rate > 0.5
            
            # Calculate habit streak
            completed_habits = [h for h in habit_data if h['completed']]
            if completed_habits:
                user_context['habit_streak'] = len(completed_habits)
        
        return user_context
    
    def _generate_response(self, intent: str, user_context: Dict, 
                          entities: Dict, original_query: str) -> Dict:
        """Generate comprehensive response based on intent and context"""
        response = {
            'message': '',
            'suggestions': [],
            'reminders': [],
            'motivation': '',
            'analysis': None
        }
        
        # Enhanced context-aware response generation
        query_lower = original_query.lower()
        
        if intent == 'motivation':
            response['motivation'] = self.coach.get_motivational_quote(original_query)
            response['message'] = self._generate_motivational_response(query_lower, user_context)
            
        elif intent == 'guidance':
            response['message'] = self._generate_guidance_response(query_lower, user_context, entities)
            response['suggestions'] = self._get_guidance_suggestions(entities, user_context)
            
        elif intent == 'reminder':
            if entities.get('habits'):
                habit = entities['habits'][0]
                reminder_msg = self.reminder.generate_reminder(habit, user_context)
                response['message'] = reminder_msg
                response['reminders'].append({
                    'habit': habit,
                    'message': reminder_msg,
                    'optimal_time': self.reminder.get_optimal_reminder_time(habit, {})
                })
            else:
                response['message'] = "What would you like me to remind you about?"
                
        elif intent == 'analysis':
            response['message'] = self._generate_analysis_response(user_context)
            response['analysis'] = self._generate_progress_analysis(user_context)
            
        elif intent == 'habit_formation':
            response['message'] = self._generate_habit_formation_response(query_lower, user_context)
            response['suggestions'] = [
                "Start with one small habit and build from there",
                "Use habit stacking to link new habits to existing routines",
                "Track your progress to stay motivated",
                "Set specific, measurable goals"
            ]
            
        else:
            response['message'] = self._generate_general_response(query_lower, user_context, entities)
        
        return response
    
    def _generate_motivational_response(self, query: str, user_context: Dict) -> str:
        """Generate motivational response based on query and context"""
        if 'exercise' in query or 'workout' in query:
            return "💪 **Exercise Motivation:** Movement is medicine! Even 10 minutes of walking can boost your mood and energy. Start with what feels good and build from there. Your body will thank you!"
        elif 'habit' in query or 'routine' in query:
            return "🔥 **Habit Building:** You don't need motivation to start - you need discipline to continue! Think about your future self. What would they thank you for doing today?"
        elif 'sleep' in query or 'bedtime' in query:
            return "😴 **Sleep Motivation:** Quality sleep is the foundation of everything else. Create a relaxing bedtime routine and stick to it. Your mind and body will reward you!"
        elif 'diet' in query or 'food' in query:
            return "🥗 **Healthy Eating:** Focus on adding good foods rather than restricting. Start your day with protein, stay hydrated, and remember - progress, not perfection!"
        else:
            return "🌟 **General Motivation:** Every step forward, no matter how small, is progress. Your future self is watching and cheering you on! What will you do today to make them proud?"
    
    def _generate_guidance_response(self, query: str, user_context: Dict, entities: Dict) -> str:
        """Generate guidance response based on query and context"""
        if 'start' in query or 'begin' in query:
            return "🚀 **Getting Started:** The best way to start is to start small! Choose one habit and commit to it for just 2 minutes a day. Once that becomes automatic, gradually increase the time."
        elif 'stuck' in query or 'struggle' in query:
            return "🔄 **Overcoming Obstacles:** It's normal to struggle! When you feel stuck, break your goal into smaller pieces. What's the tiniest step you can take right now?"
        elif 'consistency' in query or 'maintain' in query:
            return "⏰ **Building Consistency:** Consistency beats perfection every time! Focus on showing up daily, even if it's just for a few minutes. Small daily actions compound into massive results."
        elif 'goal' in query or 'target' in query:
            return "🎯 **Goal Setting:** Break big goals into tiny, actionable steps. What's the smallest thing you can do today that moves you forward? Remember, progress is progress, no matter how small!"
        else:
            return "💡 **Personal Guidance:** Based on your current progress, I recommend focusing on one area at a time. What feels most important to you right now?"
    
    def _generate_analysis_response(self, user_context: Dict) -> str:
        """Generate analysis response based on user context"""
        if user_context['recent_progress'] == 'improving':
            return "📈 **Progress Analysis:** Great news! You're on an upward trend. Your consistency is paying off, and you're building momentum. Keep up the excellent work!"
        elif user_context['recent_progress'] == 'declining':
            return "📉 **Progress Analysis:** I notice you've been struggling lately. This is completely normal and happens to everyone. Let's identify what's changed and get you back on track."
        else:
            return "📊 **Progress Analysis:** Your progress has been stable. This is actually a good foundation! Now let's work on building momentum and taking it to the next level."
    
    def _generate_habit_formation_response(self, query: str, user_context: Dict) -> str:
        """Generate habit formation response based on query and context"""
        if 'morning' in query or 'start' in query:
            return "🌅 **Morning Habits:** Morning routines set the tone for your entire day! Start with something simple like making your bed or drinking water. Small wins create momentum."
        elif 'evening' in query or 'night' in query:
            return "🌙 **Evening Habits:** Evening routines help you wind down and prepare for tomorrow. Try reading, journaling, or gentle stretching. Consistency in sleep schedule is key!"
        elif 'exercise' in query or 'workout' in query:
            return "🏃‍♂️ **Exercise Habits:** Movement habits work best when scheduled at the same time daily. Start with just 5-10 minutes and gradually increase. Your body will thank you!"
        else:
            return "🔧 **Habit Formation:** The key to building habits is starting small and being consistent. Choose one habit, commit to 2 minutes daily, and build from there!"
    
    def _generate_general_response(self, query: str, user_context: Dict, entities: Dict) -> str:
        """Generate general response for unrecognized queries"""
        if 'hello' in query or 'hi' in query:
            return "👋 **Greeting:** Hello! I'm here to help you build better habits and achieve your goals. What would you like to work on today?"
        elif 'help' in query or 'support' in query:
            return "🤝 **Support:** I'm here to help! I can assist with habit building, motivation, goal setting, progress tracking, and much more. What specific area do you need help with?"
        elif 'thank' in query or 'thanks' in query:
            return "🙏 **Gratitude:** You're welcome! I'm glad I could help. Remember, you're doing great work on yourself, and that's something to be proud of!"
        elif 'how' in query and 'are' in query:
            return "😊 **Status:** I'm doing well and ready to help you! How are you feeling today? What's on your mind regarding your habits and goals?"
        else:
            return "💭 **Personal Reflection:** That's an interesting question! While I'm processing it, take a moment to reflect on what you really want to achieve. Sometimes the best answers come from within."
    
    def _get_guidance_suggestions(self, entities: Dict, user_context: Dict) -> List[str]:
        """Get personalized guidance suggestions"""
        suggestions = []
        
        if entities.get('habits'):
            habit = entities['habits'][0]
            if habit.lower() in ['exercise', 'workout']:
                suggestions.extend([
                    "Start with 10 minutes and gradually increase",
                    "Find an exercise buddy for accountability",
                    "Schedule exercise at your most energetic time of day"
                ])
            elif habit.lower() in ['study', 'learning']:
                suggestions.extend([
                    "Use the Pomodoro technique (25 min focus, 5 min break)",
                    "Create a dedicated study space",
                    "Review material within 24 hours for better retention"
                ])
        
        # Add general suggestions based on context
        if user_context.get('recent_progress') == 'declining':
            suggestions.append("Consider reducing your goals temporarily to rebuild momentum")
        
        if user_context.get('habit_streak', 0) > 7:
            suggestions.append("Great job on your streak! Consider adding a new habit")
        
        return suggestions[:5]  # Limit to top 5 suggestions
    
    def _generate_progress_analysis(self, user_context: Dict) -> Dict:
        """Generate progress analysis for user"""
        analysis = {
            'overall_progress': user_context.get('recent_progress', 'stable'),
            'current_streak': user_context.get('habit_streak', 0),
            'success_rate': 'calculating...',
            'recommendations': []
        }
        
        if user_context.get('recent_success'):
            analysis['recommendations'].append("Keep up the great work!")
        else:
            analysis['recommendations'].append("Focus on consistency over perfection")
        
        return analysis
    
    def add_habit_for_user(self, user_id: int, habit_name: str, **kwargs) -> int:
        """Add a new habit for a user"""
        return self.data_manager.add_habit(user_id, habit_name, **kwargs)
    
    def log_habit_completion(self, habit_id: int, completed: bool, **kwargs):
        """Log habit completion status"""
        self.data_manager.log_habit_completion(habit_id, completed, **kwargs)
    
    def get_user_insights(self, user_id: int) -> Dict:
        """Get comprehensive insights for a user"""
        habit_data = self.data_manager.get_habit_data(user_id, days=30)
        analysis = self.analyzer.analyze_habit_patterns(habit_data)
        
        insights = {
            'habit_analysis': analysis,
            'recommendations': analysis.get('recommendations', []),
            'best_times': analysis.get('best_times', {}),
            'consistency_scores': analysis.get('consistency_score', {})
        }
        
        return insights
    
    def _learn_from_interactions(self):
        """Learn from user interactions to improve responses"""
        # This is a simplified learning mechanism
        # In a real implementation, you'd use more sophisticated ML techniques
        print("AI Teacher is learning from interactions...")

    def _generate_enhanced_response(self, intent: str, user_context: Dict, 
                                   entities: Dict, original_query: str) -> Dict:
        """Generate enhanced, more accurate responses based on intent and context"""
        response = {
            'message': '',
            'suggestions': [],
            'reminders': [],
            'motivation': '',
            'analysis': None
        }
        
        query_lower = original_query.lower()
        
        # Enhanced intent-based responses with better accuracy
        if intent == 'motivation':
            response['message'] = self._generate_enhanced_motivational_response(query_lower, user_context)
            response['motivation'] = self.coach.get_motivational_quote(original_query)
            
        elif intent == 'guidance':
            response['message'] = self._generate_enhanced_guidance_response(query_lower, user_context, entities)
            response['suggestions'] = self._get_enhanced_guidance_suggestions(entities, user_context)
            
        elif intent == 'reminder':
            response['message'] = self._generate_enhanced_reminder_response(query_lower, user_context, entities)
            
        elif intent == 'analysis':
            response['message'] = self._generate_enhanced_analysis_response(user_context)
            response['analysis'] = self._generate_progress_analysis(user_context)
            
        elif intent == 'habit_formation':
            response['message'] = self._generate_enhanced_habit_formation_response(query_lower, user_context)
            response['suggestions'] = self._get_enhanced_habit_suggestions(query_lower, user_context)
            
        else:
            response['message'] = self._generate_enhanced_general_response(query_lower, user_context, entities)
        
        return response
    
    def _generate_enhanced_motivational_response(self, query: str, user_context: Dict) -> str:
        """Generate highly accurate motivational responses"""
        if 'exercise' in query or 'workout' in query or 'gym' in query:
            return """💪 **Exercise Motivation - Let's Get Moving!**

I know starting can be the hardest part, but here's what I want you to remember:

**Why Exercise Matters:**
• Boosts your mood and energy levels
• Improves sleep quality
• Reduces stress and anxiety
• Builds confidence and self-discipline

**Start Small Strategy:**
1. **Day 1-3:** Just 5 minutes of any movement (walking, stretching, dancing)
2. **Day 4-7:** Increase to 10 minutes
3. **Week 2:** Try 15-20 minutes
4. **Build gradually** - consistency beats intensity every time!

**Pro Tips:**
• Schedule exercise at your most energetic time
• Prepare your workout clothes the night before
• Find an exercise buddy for accountability
• Track your progress to see improvement

Remember: You don't have to be perfect, you just have to start! What's the smallest step you can take today?"""
            
        elif 'habit' in query or 'routine' in query:
            return """🔥 **Building Habits That Stick - Your Complete Guide**

**The Science of Habit Formation:**
Habits form through a 3-step loop: Cue → Routine → Reward

**Step-by-Step Process:**
1. **Choose ONE habit** to focus on (don't overwhelm yourself)
2. **Start with 2 minutes** - yes, just 2 minutes!
3. **Stack it** on an existing habit (after brushing teeth, do 2 min meditation)
4. **Track it** - use a simple calendar or app
5. **Celebrate wins** - even tiny ones!

**Common Mistakes to Avoid:**
• Trying to change too many things at once
• Setting unrealistic goals
• Not having a clear trigger/cue
• Skipping the celebration/reward

**Your Action Plan:**
What ONE habit would make the biggest difference in your life right now? Start there, and let's build it together!"""
            
        elif 'sleep' in query or 'bedtime' in query:
            return """😴 **Sleep Optimization - Your Path to Better Rest**

**Why Sleep is Your Superpower:**
• Improves memory and learning
• Boosts immune system
• Regulates mood and emotions
• Enhances physical performance

**Create Your Sleep Sanctuary:**
1. **Environment:**
   • Keep room cool (65-68°F/18-20°C)
   • Use blackout curtains
   • White noise machine or fan
   • Comfortable mattress and pillows

2. **Evening Routine (1 hour before bed):**
   • Dim lights
   • No screens (blue light blocks melatonin)
   • Read a book or journal
   • Gentle stretching or meditation
   • Warm bath or shower

3. **Daily Habits:**
   • Get sunlight in the morning
   • Exercise (but not 3 hours before bed)
   • Avoid caffeine after 2 PM
   • Consistent sleep/wake times

**Tonight's Action:**
Start with just one change - maybe dimming your lights 1 hour before bed. Small changes create big results!"""
            
        else:
            return """🌟 **General Motivation - You've Got This!**

**The Truth About Motivation:**
Motivation is like a muscle - it gets stronger with use, but it's not always there when you need it. That's why we build systems and habits!

**Your 3-Step Action Plan:**
1. **Identify Your Why:** What's the deeper reason behind your goal?
2. **Break It Down:** What's the smallest possible step you can take today?
3. **Schedule It:** Put it in your calendar like a meeting with yourself

**Remember These Truths:**
• Progress is progress, no matter how small
• Every expert was once a beginner
• Your future self is watching and cheering you on
• Consistency beats perfection every single time

**Right Now:**
Take a deep breath. You're already ahead of most people just by reading this and wanting to improve. What's one tiny thing you can do in the next 5 minutes to move forward?"""

    def _generate_enhanced_guidance_response(self, query: str, user_context: Dict, entities: Dict) -> str:
        """Generate enhanced guidance responses"""
        if 'start' in query or 'begin' in query:
            return """🚀 **Getting Started - Your Action Plan**

**The #1 Rule:** Start smaller than you think you should!

**Your 7-Day Launch Plan:**
• **Day 1:** Choose ONE habit and commit to 2 minutes
• **Day 2:** Do it again, same time, same place
• **Day 3:** Increase to 3 minutes
• **Day 4-7:** Build to 5 minutes

**Why This Works:**
• 2 minutes feels doable even on bad days
• Small wins build momentum
• Consistency creates automaticity
• You'll naturally want to do more

**Pro Tip:** Link your new habit to something you already do daily (like after brushing teeth or before checking phone).

**Right Now:** What's the ONE habit that would make the biggest difference? Write it down and commit to 2 minutes today!"""
            
        elif 'stuck' in query or 'struggle' in query:
            return """🔄 **Breaking Through Obstacles - Let's Get You Unstuck!**

**First, Let's Identify What's Holding You Back:**
• Are you overwhelmed by the size of your goal?
• Are you trying to be perfect?
• Are you comparing yourself to others?
• Are you lacking a clear plan?

**The Unstuck Strategy:**
1. **Break it down** - What's the tiniest possible step?
2. **Lower the bar** - Make it so easy you can't fail
3. **Find your why** - What's the deeper reason?
4. **Get support** - Who can help you?

**Common Stuck Points & Solutions:**
• **"I don't have time"** → Start with 1 minute
• **"I'm not motivated"** → Motivation follows action
• **"I keep failing"** → Failure is data, not defeat
• **"It's too hard"** → Make it easier, not harder

**Your Action:** What's the smallest thing you can do right now to move forward? Even if it's just opening a book or putting on workout clothes!"""
            
        else:
            return """💡 **Personalized Guidance - Let's Find Your Path**

**Based on your current situation, here's what I recommend:**

**Immediate Focus:**
• Choose ONE area to improve (don't spread yourself thin)
• Start with the habit that will have the biggest impact
• Build momentum before adding complexity

**Your Success Formula:**
1. **Clarity** - Know exactly what you want
2. **Simplicity** - Start with the basics
3. **Consistency** - Show up daily, no matter what
4. **Patience** - Trust the process

**This Week's Challenge:**
Pick one habit and commit to it for just 5 minutes daily. Track your progress and celebrate every win, no matter how small!

**Remember:** You don't have to figure everything out today. Just take the next step, and the path will become clearer!"""
    
    def _generate_enhanced_reminder_response(self, query: str, user_context: Dict, entities: Dict) -> str:
        """Generate enhanced reminder responses"""
        if entities.get('habits'):
            habit = entities['habits'][0]
            return f"""⏰ **Smart Reminder for {habit.title()}**

**Your Personalized Reminder Strategy:**

**Optimal Timing:** Based on your patterns, try to do this habit at the same time daily

**Reminder Message:** "Time for {habit}! You've got this! 💪"

**Pro Tips:**
• Set multiple gentle reminders (don't overwhelm yourself)
• Use habit stacking (after [existing habit], do {habit})
• Prepare everything the night before
• Have a backup plan for busy days

**Right Now:** What time would work best for your {habit} routine? Set a reminder and commit to showing up!"""
        else:
            return """⏰ **Smart Reminder System - Let's Set You Up!**

**What would you like me to remind you about?**
• Exercise or workout routines
• Meditation or mindfulness practice
• Reading or learning sessions
• Planning or reflection time
• Health habits (water, sleep, etc.)

**How I Can Help:**
• Send gentle, motivational reminders
• Adapt timing based on your schedule
• Provide context and encouragement
• Help you build consistency

**Your Action:** Tell me what habit you want to build, and I'll help you create the perfect reminder system!"""
    
    def _generate_enhanced_analysis_response(self, user_context: Dict) -> str:
        """Generate enhanced analysis responses"""
        if user_context['recent_progress'] == 'improving':
            return """📈 **Progress Analysis - You're Crushing It!**

**Your Current Status: UPWARD TREND! 🚀**

**What's Working:**
• Your consistency is paying off
• You're building positive momentum
• Small wins are compounding
• You're developing discipline

**Keep the Momentum Going:**
• Don't change what's working
• Gradually increase your goals
• Celebrate your progress
• Share your success with others

**Next Level Strategies:**
• Add one new habit (but only after 21 days of current habit)
• Increase duration or intensity gradually
• Set bigger goals for next month
• Mentor someone else on their journey

**You're doing amazing! Keep up the excellent work! 💪"""
            
        elif user_context['recent_progress'] == 'declining':
            return """📉 **Progress Analysis - Let's Get You Back on Track!**

**Current Status:** Temporary setback (this happens to everyone!)

**What This Means:**
• You're human, and that's perfectly okay
• Setbacks are part of the growth process
• This is a learning opportunity
• You can bounce back stronger

**Recovery Strategy:**
1. **Don't beat yourself up** - Self-compassion is key
2. **Identify what changed** - What disrupted your routine?
3. **Start smaller** - Reduce your goals temporarily
4. **Rebuild momentum** - Focus on consistency over intensity

**Your Comeback Plan:**
• Pick ONE habit to focus on
• Start with just 2 minutes daily
• Track your progress
• Celebrate every small win

**Remember:** Every successful person has faced setbacks. What matters is getting back up!"""
            
        else:
            return """📊 **Progress Analysis - Solid Foundation!**

**Your Current Status: STABLE & STEADY**

**What This Means:**
• You have a good foundation to build on
• Consistency is your strength
• You're ready for the next level
• This is actually a great position to be in!

**Next Steps to Build Momentum:**
• Add one new habit (but keep it simple)
• Increase the challenge gradually
• Set specific, measurable goals
• Create a weekly review routine

**Momentum Building Tips:**
• Track your progress visually
• Set weekly mini-goals
• Find an accountability partner
• Celebrate weekly wins

**You're doing great! Now let's take it to the next level! 🚀"""
    
    def _generate_enhanced_habit_formation_response(self, query: str, user_context: Dict) -> str:
        """Generate enhanced habit formation responses"""
        if 'morning' in query or 'start' in query:
            return """🌅 **Morning Habits - Your Day's Foundation**

**Why Morning Routines Matter:**
• Set the tone for your entire day
• Build momentum and confidence
• Create space for what matters most
• Reduce decision fatigue

**Your 21-Day Morning Habit Plan:**

**Week 1 (Foundation):**
• Wake up 15 minutes earlier
• Drink a glass of water
• Make your bed
• 2 minutes of stretching

**Week 2 (Build):**
• Add 5 minutes of meditation
• Write 3 things you're grateful for
• Plan your top 3 priorities

**Week 3 (Optimize):**
• Add 10 minutes of reading
• Review your goals
• Prepare for the day ahead

**Pro Tips:**
• Prepare everything the night before
• Start with just one habit
• Same time, same place daily
• Track your progress

**Today's Action:** What's the ONE morning habit you want to start with? Commit to it for just 2 minutes!"""
            
        elif 'evening' in query or 'night' in query:
            return """🌙 **Evening Habits - Your Recovery & Preparation Time**

**Why Evening Routines Matter:**
• Help you wind down and relax
• Prepare your mind and body for sleep
• Set you up for tomorrow's success
• Create peaceful transitions

**Your Evening Routine Blueprint:**

**1 Hour Before Bed:**
• Dim the lights
• No screens (blue light blocks melatonin)
• Gentle stretching or yoga
• Read a book (not on phone/tablet)
• Write in your journal

**30 Minutes Before Bed:**
• Warm bath or shower
• Prepare clothes for tomorrow
• Set your intentions for tomorrow
• Practice gratitude

**15 Minutes Before Bed:**
• Gentle breathing exercises
• Progressive muscle relaxation
• Listen to calming music
• Final bathroom visit

**Sleep Optimization:**
• Keep room cool (65-68°F)
• Use blackout curtains
• White noise if needed
• Comfortable bedding

**Tonight's Start:** Choose ONE evening habit to begin with. Maybe just dimming your lights 1 hour before bed!"""
            
        else:
            return """🔧 **Habit Formation Mastery - Your Complete Guide**

**The Science of Building Habits That Stick:**

**Habit Loop (Cue → Routine → Reward):**
1. **Cue:** What triggers your habit? (time, location, emotion, other habit)
2. **Routine:** What action do you take?
3. **Reward:** What benefit do you get?

**Your 4-Phase Habit Building Process:**

**Phase 1: Foundation (Days 1-7)**
• Choose ONE habit to focus on
• Start with 2 minutes maximum
• Same time, same place daily
• Track every day

**Phase 2: Building (Days 8-21)**
• Gradually increase duration
• Add complexity slowly
• Focus on consistency
• Celebrate small wins

**Phase 3: Optimization (Days 22-66)**
• Fine-tune timing and environment
• Add supporting habits
• Build momentum
• Set bigger goals

**Phase 4: Mastery (Day 67+)**
• Habit becomes automatic
• Add new habits
• Help others
• Continuous improvement

**Your Action Plan:**
What ONE habit would make the biggest difference in your life? Start there, and let's build it together!"""
    
    def _generate_enhanced_general_response(self, query: str, user_context: Dict, entities: Dict) -> str:
        """Generate enhanced general responses"""
        if 'hello' in query or 'hi' in query:
            return """👋 **Welcome to Your AI Teacher!**

**I'm here to help you:**
• Build better habits and routines
• Stay motivated and focused
• Overcome obstacles and challenges
• Track your progress and growth
• Achieve your personal goals

**What I Can Do:**
• Provide personalized coaching and advice
• Help you create actionable plans
• Give you motivation when you need it
• Analyze your progress and patterns
• Answer questions about habit formation

**Let's Get Started:**
What would you like to work on today? You can ask me about:
• Building specific habits (exercise, reading, meditation, etc.)
• Getting motivated or unstuck
• Creating better routines
• Tracking your progress
• Any personal development topic

**Remember:** I'm here to support your journey. What's on your mind?"""
            
        elif 'help' in query or 'support' in query:
            return """🤝 **How I Can Help You - Your Complete Support Guide**

**My Core Capabilities:**

**1. Habit Building & Formation**
• Create personalized habit plans
• Help you start small and build gradually
• Teach you the science of habit formation
• Provide accountability and tracking

**2. Motivation & Mindset**
• Give you personalized motivation
• Help you overcome obstacles
• Build confidence and resilience
• Keep you focused on your goals

**3. Progress Analysis**
• Track your habit completion
• Identify patterns and trends
• Provide insights and recommendations
• Help you optimize your routines

**4. Personal Coaching**
• Answer your specific questions
• Provide actionable advice
• Help you create action plans
• Support you through challenges

**How to Get the Most from Me:**
• Ask specific questions
• Share your current situation
• Tell me what you're struggling with
• Ask for step-by-step guidance

**What would you like help with today?** I'm ready to support your growth!"""
            
        elif 'thank' in query or 'thanks' in query:
            return """🙏 **You're Welcome! I'm Glad I Could Help!**

**Your gratitude means a lot to me! Here's what I want you to remember:**

**You're Doing Great Because:**
• You're actively working on self-improvement
• You're seeking help and guidance
• You're committed to building better habits
• You're showing up for yourself

**Keep Up the Amazing Work:**
• Stay consistent with your habits
• Celebrate your progress, no matter how small
• Be patient with yourself
• Keep asking questions and learning

**My Commitment to You:**
• I'll always be here to support you
• I'll provide honest, helpful guidance
• I'll celebrate your wins with you
• I'll help you overcome any obstacles

**Next Steps:**
What would you like to work on next? I'm here to help you continue growing and improving!

**Remember:** You're already ahead of most people just by being here and wanting to improve! 🌟"""
            
        else:
            return """💭 **Let's Explore This Together!**

**I'm here to help you with any questions about:**
• Personal development and growth
• Building better habits and routines
• Staying motivated and focused
• Overcoming challenges and obstacles
• Creating positive change in your life

**To give you the best help possible:**
• Tell me more about what you're looking for
• Share your current situation or challenge
• Ask specific questions
• Let me know what type of guidance you need

**I can provide:**
• Step-by-step action plans
• Personalized advice and strategies
• Motivation and encouragement
• Practical tips and techniques
• Answers to your specific questions

**What would you like to explore or work on?** I'm excited to help you on your journey! 🚀"""
    
    def _get_enhanced_guidance_suggestions(self, entities: Dict, user_context: Dict) -> List[str]:
        """Get enhanced guidance suggestions"""
        suggestions = []
        
        if entities.get('habits'):
            habit = entities['habits'][0]
            if habit.lower() in ['exercise', 'workout', 'gym']:
                suggestions.extend([
                    "Start with just 5 minutes and gradually increase",
                    "Schedule exercise at your most energetic time of day",
                    "Prepare your workout clothes the night before",
                    "Find an exercise buddy for accountability",
                    "Track your progress to see improvement"
                ])
            elif habit.lower() in ['study', 'learning', 'reading']:
                suggestions.extend([
                    "Use the Pomodoro technique (25 min focus, 5 min break)",
                    "Create a dedicated study space free from distractions",
                    "Review material within 24 hours for better retention",
                    "Break large topics into smaller, manageable chunks",
                    "Teach someone else to reinforce your learning"
                ])
            elif habit.lower() in ['meditation', 'mindfulness']:
                suggestions.extend([
                    "Start with just 2 minutes of focused breathing",
                    "Use guided meditation apps for beginners",
                    "Practice at the same time daily to build routine",
                    "Find a quiet, comfortable space",
                    "Be patient - it's a skill that develops over time"
                ])
        
        # Add context-based suggestions
        if user_context.get('recent_progress') == 'declining':
            suggestions.append("Consider reducing your goals temporarily to rebuild momentum")
            suggestions.append("Focus on one habit at a time until it becomes automatic")
        
        if user_context.get('habit_streak', 0) > 7:
            suggestions.append("Great job on your streak! Consider adding a new habit")
            suggestions.append("Share your success to inspire others")
        
        return suggestions[:5]  # Limit to top 5 suggestions
    
    def _get_enhanced_habit_suggestions(self, query: str, user_context: Dict) -> List[str]:
        """Get enhanced habit formation suggestions"""
        query_lower = query.lower()
        
        if 'morning' in query_lower:
            return [
                "Start by waking up just 15 minutes earlier",
                "Begin with making your bed - it's a quick win",
                "Add a glass of water to start your day hydrated",
                "Include 2 minutes of gentle stretching",
                "Write down your top 3 priorities for the day"
            ]
        elif 'evening' in query_lower:
            return [
                "Dim your lights 1 hour before bedtime",
                "Create a relaxing bedtime routine",
                "Avoid screens 30 minutes before sleep",
                "Prepare your clothes for tomorrow",
                "Practice gratitude by writing 3 good things"
            ]
        elif 'exercise' in query_lower or 'workout' in query_lower:
            return [
                "Start with just 5 minutes of movement",
                "Schedule exercise at your most energetic time",
                "Prepare everything the night before",
                "Find an exercise buddy for accountability",
                "Track your progress to see improvement"
            ]
        else:
            return [
                "Choose ONE habit to focus on initially",
                "Start with just 2 minutes daily",
                "Use habit stacking to link to existing routines",
                "Track your progress consistently",
                "Celebrate every small win and milestone"
            ]

# Example usage and testing
def main():
    """Example usage of the AI Teacher system"""
    ai_teacher = AITeacher()
    
    # Create a test user
    user_id = ai_teacher.data_manager.add_user("Test User", {
        "preferred_time": "morning",
        "coaching_style": "motivational"
    })
    
    # Add some test habits
    exercise_habit = ai_teacher.add_habit_for_user(user_id, "Exercise", 
                                                  description="Daily workout",
                                                  reminder_time="morning")
    
    study_habit = ai_teacher.add_habit_for_user(user_id, "Study", 
                                               description="Learning new skills",
                                               reminder_time="afternoon")
    
    # Test some queries
    test_queries = [
        "I need motivation to exercise",
        "Help me build better study habits",
        "Remind me to meditate",
        "How am I doing with my habits?",
        "I'm feeling stressed about my progress"
    ]
    
    print("🤖 AI Teacher System Demo")
    print("=" * 50)
    
    for query in test_queries:
        print(f"\n👤 User: {query}")
        response = ai_teacher.process_query(user_id, query)
        
        print(f"🤖 AI Teacher: {response['message']}")
        
        if response.get('motivation'):
            print(f"💪 Motivation: {response['motivation']}")
        
        if response.get('suggestions'):
            print("💡 Suggestions:")
            for suggestion in response['suggestions']:
                print(f"   • {suggestion}")
        
        if response.get('reminders'):
            print("⏰ Reminders:")
            for reminder in response['reminders']:
                print(f"   • {reminder['message']}")
    
    # Get user insights
    print("\n📊 User Insights:")
    insights = ai_teacher.get_user_insights(user_id)
    print(f"Recommendations: {insights['recommendations']}")

if __name__ == "__main__":
    main()
