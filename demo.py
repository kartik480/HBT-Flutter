#!/usr/bin/env python3
"""
AI Teacher Demo Script
Test the AI Teacher system with sample interactions
"""

import time
from ai_teacher import AITeacher

def print_separator(title=""):
    """Print a formatted separator"""
    if title:
        print(f"\n{'='*20} {title} {'='*20}")
    else:
        print("\n" + "="*60)

def demo_basic_functionality():
    """Demonstrate basic AI Teacher functionality"""
    print_separator("🤖 AI Teacher System Demo")
    
    # Initialize AI Teacher
    print("Initializing AI Teacher...")
    ai_teacher = AITeacher()
    print("✅ AI Teacher initialized successfully!")
    
    # Create a test user
    print("\nCreating test user...")
    user_id = ai_teacher.data_manager.add_user("Demo User", {
        "preferred_time": "morning",
        "coaching_style": "motivational"
    })
    print(f"✅ User created with ID: {user_id}")
    
    # Add some test habits
    print("\nAdding test habits...")
    exercise_habit = ai_teacher.add_habit_for_user(user_id, "Exercise", 
                                                  description="Daily workout",
                                                  reminder_time="morning")
    study_habit = ai_teacher.add_habit_for_user(user_id, "Study", 
                                               description="Learning new skills",
                                               reminder_time="afternoon")
    meditation_habit = ai_teacher.add_habit_for_user(user_id, "Meditation", 
                                                    description="Mindfulness practice",
                                                    reminder_time="evening")
    print(f"✅ Added habits: Exercise (ID: {exercise_habit}), Study (ID: {study_habit}), Meditation (ID: {meditation_habit})")
    
    # Log some habit completions
    print("\nLogging habit completions...")
    ai_teacher.log_habit_completion(exercise_habit, True, mood="positive", notes="Great workout!")
    ai_teacher.log_habit_completion(study_habit, True, mood="focused", notes="Learned Python basics")
    ai_teacher.log_habit_completion(meditation_habit, False, mood="tired", notes="Too tired today")
    print("✅ Logged habit completions")
    
    return ai_teacher, user_id

def demo_chat_interactions(ai_teacher, user_id):
    """Demonstrate chat interactions with AI Teacher"""
    print_separator("💬 Chat Interactions Demo")
    
    # Sample queries to test different intents
    test_queries = [
        {
            "query": "I need motivation to exercise",
            "context": {"mood": "neutral"},
            "description": "Motivation request"
        },
        {
            "query": "Help me build better study habits",
            "context": {"mood": "positive"},
            "description": "Guidance request"
        },
        {
            "query": "Remind me to meditate",
            "context": {"mood": "neutral"},
            "description": "Reminder request"
        },
        {
            "query": "How am I doing with my habits?",
            "context": {"mood": "positive"},
            "description": "Progress analysis request"
        },
        {
            "query": "I'm feeling stressed about my progress",
            "context": {"mood": "negative"},
            "description": "Support request"
        },
        {
            "query": "What's the best time to work out?",
            "context": {"mood": "neutral"},
            "description": "Advice request"
        }
    ]
    
    for i, test_case in enumerate(test_queries, 1):
        print(f"\n--- Test Case {i}: {test_case['description']} ---")
        print(f"👤 User: {test_case['query']}")
        print(f"😊 Mood: {test_case['context']['mood']}")
        
        # Process the query
        response = ai_teacher.process_query(
            user_id=user_id,
            query=test_case['query'],
            context=test_case['context']
        )
        
        # Display the response
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
        
        if response.get('analysis'):
            print("📊 Analysis:")
            analysis = response['analysis']
            if analysis.get('overall_progress'):
                print(f"   • Overall Progress: {analysis['overall_progress']}")
            if analysis.get('current_streak'):
                print(f"   • Current Streak: {analysis['current_streak']} days")
            if analysis.get('recommendations'):
                print("   • Recommendations:")
                for rec in analysis['recommendations']:
                    print(f"     - {rec}")
        
        print("-" * 50)
        time.sleep(1)  # Small delay for readability

def demo_insights_and_analysis(ai_teacher, user_id):
    """Demonstrate insights and analysis features"""
    print_separator("📊 Insights & Analysis Demo")
    
    # Get user insights
    print("Getting user insights...")
    insights = ai_teacher.get_user_insights(user_id)
    
    print("\n🔍 Habit Analysis:")
    habit_analysis = insights.get('habit_analysis', {})
    
    if habit_analysis.get('best_times'):
        print("   📅 Best Times:")
        for time_slot, success_rate in habit_analysis['best_times'].items():
            print(f"     • {time_slot}: {success_rate:.1%} success rate")
    
    if habit_analysis.get('consistency_score'):
        print("   📈 Consistency Scores:")
        for habit, score in habit_analysis['consistency_score'].items():
            print(f"     • {habit}: {score:.1%} consistency")
    
    if habit_analysis.get('recommendations'):
        print("   💡 Recommendations:")
        for rec in habit_analysis['recommendations']:
            print(f"     • {rec}")
    
    # Get progress data
    print("\n📊 Progress Data:")
    habit_data = ai_teacher.data_manager.get_habit_data(user_id, days=7)
    
    if habit_data:
        total_habits = len(habit_data)
        completed_habits = sum(1 for h in habit_data if h['completed'])
        completion_rate = (completed_habits / total_habits * 100) if total_habits > 0 else 0
        
        print(f"   • Total habits logged: {total_habits}")
        print(f"   • Completed habits: {completed_habits}")
        print(f"   • Completion rate: {completion_rate:.1f}%")
        
        # Show recent habits
        print("   • Recent habit entries:")
        for entry in habit_data[:5]:  # Show last 5 entries
            status = "✅" if entry['completed'] else "❌"
            mood = entry.get('mood', 'unknown')
            print(f"     {status} {entry['habit_name']} - Mood: {mood}")

def demo_smart_reminders(ai_teacher, user_id):
    """Demonstrate smart reminder system"""
    print_separator("⏰ Smart Reminders Demo")
    
    # Test different reminder scenarios
    reminder_scenarios = [
        {"habit": "Exercise", "context": {"mood": "positive", "streak": 5, "recent_success": True}},
        {"habit": "Study", "context": {"mood": "neutral", "streak": 0, "recent_success": False}},
        {"habit": "Meditation", "context": {"mood": "negative", "streak": 2, "recent_success": True}},
    ]
    
    for scenario in reminder_scenarios:
        print(f"\n📝 Generating reminder for: {scenario['habit']}")
        print(f"   Context: Mood={scenario['context']['mood']}, Streak={scenario['context']['streak']}")
        
        reminder_msg = ai_teacher.reminder.generate_reminder(
            scenario['habit'], 
            scenario['context']
        )
        
        optimal_time = ai_teacher.reminder.get_optimal_reminder_time(
            scenario['habit'], 
            {"preferred_time": "morning"}
        )
        
        print(f"   🤖 Reminder: {reminder_msg}")
        print(f"   ⏰ Optimal Time: {optimal_time}")
        print("-" * 40)

def demo_coaching_sessions(ai_teacher, user_id):
    """Demonstrate coaching sessions"""
    print_separator("🎯 Coaching Sessions Demo")
    
    # Test different coaching approaches
    coaching_types = ["motivational", "analytical", "supportive", "challenging"]
    
    for coaching_type in coaching_types:
        print(f"\n🎭 {coaching_type.title()} Coaching Session:")
        
        # Get user context
        user_context = ai_teacher._get_user_context(user_id)
        
        # Generate coaching message
        coaching_message = ai_teacher.coach.get_personalized_message(user_context, coaching_type)
        
        # Get motivational quote
        motivation = ai_teacher.coach.get_motivational_quote()
        
        print(f"   💬 Message: {coaching_message}")
        print(f"   💪 Motivation: {motivation}")
        print("-" * 40)

def demo_motivational_quotes(ai_teacher):
    """Demonstrate motivational quote system"""
    print_separator("🌟 Motivational Quotes Demo")
    
    # Test different contexts
    contexts = [None, "exercise", "study", "health", "learning"]
    
    for context in contexts:
        context_desc = context if context else "general"
        print(f"\n📖 {context_desc.title()} Context:")
        
        quote = ai_teacher.coach.get_motivational_quote(context)
        print(f"   💬 Quote: {quote}")
        print("-" * 30)

def main():
    """Main demo function"""
    try:
        # Run all demos
        ai_teacher, user_id = demo_basic_functionality()
        
        demo_chat_interactions(ai_teacher, user_id)
        demo_insights_and_analysis(ai_teacher, user_id)
        demo_smart_reminders(ai_teacher, user_id)
        demo_coaching_sessions(ai_teacher, user_id)
        demo_motivational_quotes(ai_teacher)
        
        print_separator("🎉 Demo Complete!")
        print("The AI Teacher system is working perfectly!")
        print("\nNext steps:")
        print("1. Start the API server: python ai_teacher_api.py")
        print("2. Start the web interface: python web_interface.py")
        print("3. Open http://localhost:5000 in your browser")
        print("4. Check API docs at http://localhost:8000/docs")
        
    except Exception as e:
        print(f"\n❌ Demo failed with error: {e}")
        print("Please check that all dependencies are installed:")
        print("pip install -r requirements.txt")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
