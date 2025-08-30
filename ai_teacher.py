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
    
    def _call_openrouter_api(self, messages: List[Dict[str, str]], model: str = "x-ai/grok-code-fast-1") -> str:
        """Call OpenRouter API to get AI response"""
        try:
            headers = {
                "Authorization": f"Bearer {self.openrouter_api_key}",
                "Content-Type": "application/json",
                "HTTP-Referer": "https://habit-tracker-app.com",
                "X-Title": "Habit Tracker AI Teacher",
            }
            
            data = {
                "model": model,
                "messages": messages,
                "max_tokens": 500,
                "temperature": 0.7
            }
            
            response = requests.post(
                url=self.openrouter_url,
                headers=headers,
                data=json.dumps(data),
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                return result['choices'][0]['message']['content']
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
        The user has the following context: {user_context}
        Provide helpful, encouraging, and practical advice. Be concise but thorough."""
        
        messages = [
            {"role": "system", "content": system_message},
            {"role": "user", "content": query}
        ]
        
        ai_response = self._call_openrouter_api(messages)
        
        if ai_response:
            # Use AI response from OpenRouter
            response = {
                'message': ai_response,
                'suggestions': [],
                'reminders': [],
                'motivation': '',
                'analysis': None
            }
        else:
            # Fallback to local processing if API fails
            primary_intent = max(intent_scores.items(), key=lambda x: x[1])[0] if intent_scores else 'general'
            response = self._generate_response(primary_intent, user_context, entities, query)
        
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
        
        if intent == 'motivation':
            response['motivation'] = self.coach.get_motivational_quote(original_query)
            response['message'] = self.coach.get_personalized_message(user_context, intent)
            
        elif intent == 'guidance':
            response['message'] = self.coach.get_personalized_message(user_context, intent)
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
            response['message'] = "Here's your progress analysis:"
            response['analysis'] = self._generate_progress_analysis(user_context)
            
        elif intent == 'habit_formation':
            response['message'] = "Let's work on building better habits!"
            response['suggestions'] = [
                "Start with one small habit and build from there",
                "Use habit stacking to link new habits to existing routines",
                "Track your progress to stay motivated",
                "Set specific, measurable goals"
            ]
            
        else:
            response['message'] = self.coach.get_personalized_message(user_context, 'supportive')
            response['motivation'] = self.coach.get_motivational_quote()
        
        return response
    
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
