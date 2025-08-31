import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AIService {
  static const String baseUrl = 'http://localhost:8000'; // Change this to your server URL
  static const Duration timeout = Duration(seconds: 15);
  
  // Get AI response for a user query
  static Future<Map<String, dynamic>> askAI(String userId, String question) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'question': question,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'response': data['response'] ?? _getOfflineResponse(question),
          'timestamp': data['timestamp'],
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('Connection failed. Please check your internet connection.');
    } on SocketException {
      throw Exception('Unable to reach the AI server. Please try again later.');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timed out. Please try again.');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  // Get AI insights for a user
  static Future<Map<String, dynamic>> getInsights(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/insights'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'insights': data['insights'] ?? _getDefaultInsights(),
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'insights': _getDefaultInsights(),
        'error': e.toString(),
      };
    }
  }

  // Get motivational quote
  static Future<Map<String, dynamic>> getMotivationalQuote([String? context]) async {
    try {
      final uri = context != null 
          ? Uri.parse('$baseUrl/ai/motivational-quote?context=$context')
          : Uri.parse('$baseUrl/ai/motivational-quote');
      
      final response = await http.get(uri).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'quote': data['quote'] ?? _getDefaultMotivationalQuote(),
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'quote': _getDefaultMotivationalQuote(),
        'error': e.toString(),
      };
    }
  }

  // Start coaching session
  static Future<Map<String, dynamic>> getCoachingSession(String userId, String sessionType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/coaching-session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'session_type': sessionType,
        }),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'session': data['session'] ?? _getDefaultCoachingSession(),
        };
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'session': _getDefaultCoachingSession(),
        'error': e.toString(),
      };
    }
  }

  // Check if AI server is available
  static Future<bool> isServerAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Offline fallback responses
  static String _getOfflineResponse(String question) {
    final q = question.toLowerCase();
    
    // Enhanced context-aware responses
    if (q.contains('hello') || q.contains('hi') || q.contains('hey')) {
      return "👋 **Greeting:** Hello! I'm here to help you build better habits and achieve your goals. What would you like to work on today?";
    } else if (q.contains('habit') || q.contains('routine')) {
      if (q.contains('start') || q.contains('begin')) {
        return "🚀 **Getting Started:** The best way to start is to start small! Choose one habit and commit to it for just 2 minutes a day. Once that becomes automatic, gradually increase the time.";
      } else if (q.contains('morning')) {
        return "🌅 **Morning Habits:** Morning routines set the tone for your entire day! Start with something simple like making your bed or drinking water. Small wins create momentum.";
      } else if (q.contains('evening') || q.contains('night')) {
        return "🌙 **Evening Habits:** Evening routines help you wind down and prepare for tomorrow. Try reading, journaling, or gentle stretching. Consistency in sleep schedule is key!";
      } else {
        return "💡 **Habit Building Tip:** Start small! Choose one habit and commit to it for just 2 minutes a day. Once that becomes automatic, gradually increase the time. Remember, consistency beats perfection every time!";
      }
    } else if (q.contains('motivation') || q.contains('motivated')) {
      if (q.contains('exercise') || q.contains('workout')) {
        return "💪 **Exercise Motivation:** Movement is medicine! Even 10 minutes of walking can boost your mood and energy. Start with what feels good and build from there. Your body will thank you!";
      } else if (q.contains('habit') || q.contains('routine')) {
        return "🔥 **Habit Building:** You don't need motivation to start - you need discipline to continue! Think about your future self. What would they thank you for doing today?";
      } else {
        return "🌟 **General Motivation:** Every step forward, no matter how small, is progress. Your future self is watching and cheering you on! What will you do today to make them proud?";
      }
    } else if (q.contains('exercise') || q.contains('workout')) {
      if (q.contains('start') || q.contains('begin')) {
        return "🏃‍♂️ **Exercise Start:** Start with just 5-10 minutes of movement daily. Walking, stretching, or simple bodyweight exercises are perfect to begin with. Build consistency first, then intensity!";
      } else if (q.contains('time') || q.contains('schedule')) {
        return "⏰ **Exercise Timing:** Exercise habits work best when scheduled at the same time daily. Morning workouts often have the highest completion rates. Find what works for your schedule!";
      } else {
        return "🏃‍♂️ **Exercise Motivation:** Movement is medicine! Even 10 minutes of walking can boost your mood and energy. Start with what feels good and build from there. Your body will thank you!";
      }
    } else if (q.contains('sleep') || q.contains('bedtime')) {
      if (q.contains('routine')) {
        return "😴 **Sleep Routine:** Create a relaxing bedtime routine. Avoid screens 1 hour before bed, try reading or meditation. Consistency in sleep schedule is key to better rest!";
      } else if (q.contains('quality') || q.contains('better')) {
        return "🌙 **Better Sleep:** Focus on sleep hygiene: consistent bedtime, cool room, no screens before bed, and a relaxing routine. Quality sleep is the foundation of everything else!";
      } else {
        return "😴 **Sleep Tips:** Create a relaxing bedtime routine. Avoid screens 1 hour before bed, try reading or meditation. Consistency in sleep schedule is key to better rest!";
      }
    } else if (q.contains('diet') || q.contains('food') || q.contains('eat')) {
      if (q.contains('start') || q.contains('begin')) {
        return "🥗 **Healthy Eating Start:** Focus on adding good foods rather than restricting. Start your day with protein, stay hydrated, and remember - progress, not perfection!";
      } else if (q.contains('plan') || q.contains('meal')) {
        return "📋 **Meal Planning:** Start simple! Plan 2-3 meals a week and gradually increase. Focus on whole foods, protein, and vegetables. Small changes create lasting habits!";
      } else {
        return "🥗 **Healthy Eating:** Focus on adding good foods rather than restricting. Start your day with protein, stay hydrated, and remember - progress, not perfection!";
      }
    } else if (q.contains('goal') || q.contains('target')) {
      if (q.contains('set') || q.contains('create')) {
        return "🎯 **Goal Setting:** Break big goals into tiny, actionable steps. What's the smallest thing you can do today that moves you forward? Remember, progress is progress, no matter how small!";
      } else if (q.contains('achieve') || q.contains('reach')) {
        return "🚀 **Goal Achievement:** Focus on daily actions, not just the end result. Break your goal into weekly milestones and celebrate small wins along the way!";
      } else {
        return "🎯 **Goal Setting:** Break big goals into tiny, actionable steps. What's the smallest thing you can do today that moves you forward? Remember, progress is progress, no matter how small!";
      }
    } else if (q.contains('stress') || q.contains('anxiety')) {
      if (q.contains('manage') || q.contains('reduce')) {
        return "🧘‍♀️ **Stress Management:** Take deep breaths. Inhale for 4 counts, hold for 4, exhale for 6. Focus on what you can control right now. Small actions create big changes over time.";
      } else if (q.contains('routine') || q.contains('habit')) {
        return "🌿 **Stress-Relief Habits:** Build daily stress-relief habits: 5 minutes of deep breathing, short walks, or journaling. Consistency is key to managing stress effectively!";
      } else {
        return "🧘‍♀️ **Stress Management:** Take deep breaths. Inhale for 4 counts, hold for 4, exhale for 6. Focus on what you can control right now. Small actions create big changes over time.";
      }
    } else if (q.contains('consistency') || q.contains('maintain')) {
      return "⏰ **Building Consistency:** Consistency beats perfection every time! Focus on showing up daily, even if it's just for a few minutes. Small daily actions compound into massive results.";
    } else if (q.contains('stuck') || q.contains('struggle')) {
      return "🔄 **Overcoming Obstacles:** It's normal to struggle! When you feel stuck, break your goal into smaller pieces. What's the tiniest step you can take right now?";
    } else if (q.contains('help') || q.contains('support')) {
      return "🤝 **Support:** I'm here to help! I can assist with habit building, motivation, goal setting, progress tracking, and much more. What specific area do you need help with?";
    } else if (q.contains('thank') || q.contains('thanks')) {
      return "🙏 **Gratitude:** You're welcome! I'm glad I could help. Remember, you're doing great work on yourself, and that's something to be proud of!";
    } else if (q.contains('how') && q.contains('are')) {
      return "😊 **Status:** I'm doing well and ready to help you! How are you feeling today? What's on your mind regarding your habits and goals?";
    } else {
      return "💭 **Personal Reflection:** That's an interesting question! While I'm processing it, take a moment to reflect on what you really want to achieve. Sometimes the best answers come from within. What's your gut feeling?";
    }
  }

  static String _getDefaultInsights() {
    return "🔍 **Quick Habit Insights:**\n\n"
           "📊 **Focus Areas:**\n"
           "• Morning routines are most successful when done consistently\n"
           "• Exercise habits work best when scheduled at the same time daily\n"
           "• Small wins build momentum - celebrate every step forward\n\n"
           "💡 **Pro Tips:**\n"
           "• Stack new habits onto existing ones\n"
           "• Use visual cues and reminders\n"
           "• Track progress to stay motivated\n\n"
           "🎯 **Next Steps:** Pick one area to focus on this week!";
  }

  static String _getDefaultMotivationalQuote() {
    return "💪 **Daily Motivation:**\n\n"
           "\"The only bad workout is the one that didn't happen.\"\n\n"
           "Every step forward, no matter how small, is progress. "
           "Your future self is watching and cheering you on! "
           "What will you do today to make them proud?";
  }

  static String _getDefaultCoachingSession() {
    return "🎓 **Coaching Session: Building Your Foundation**\n\n"
           "Let's create a solid foundation for your habit journey:\n\n"
           "1️⃣ **Identify Your Why:** What's driving you to change?\n"
           "2️⃣ **Choose Your Keystone Habit:** What one habit will improve everything else?\n"
           "3️⃣ **Set Up Your Environment:** Remove obstacles, add reminders\n"
           "4️⃣ **Start Small:** 2 minutes a day to begin\n"
           "5️⃣ **Track Progress:** Use your habit tracker consistently\n\n"
           "Ready to begin? What's your biggest challenge right now?";
  }
}
