import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AIService {
  static const String baseUrl = 'http://localhost:8000'; // Change this to your server URL
  
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
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to AI server: $e');
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
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get insights: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting insights: $e');
    }
  }

  // Get motivational quote
  static Future<Map<String, dynamic>> getMotivationalQuote([String? context]) async {
    try {
      final uri = context != null 
          ? Uri.parse('$baseUrl/ai/motivational-quote?context=$context')
          : Uri.parse('$baseUrl/ai/motivational-quote');
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get motivational quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting motivational quote: $e');
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
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to start coaching session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting coaching session: $e');
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
}
