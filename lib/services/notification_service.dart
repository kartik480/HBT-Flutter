import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';
import 'dart:convert';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _remindersKey = 'scheduled_reminders';

  Future<void> initialize() async {
    // Simple initialization - no complex setup needed
    debugPrint('NotificationService initialized');
  }

  Future<bool> scheduleReminder(Reminder reminder) async {
    try {
      // Save reminder to local storage
      await _saveReminder(reminder);
      debugPrint('Reminder scheduled: ${reminder.title}');
      return true;
    } catch (e) {
      debugPrint('Error scheduling reminder: $e');
      return false;
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    try {
      await _removeReminder(reminderId);
      debugPrint('Reminder cancelled: $reminderId');
    } catch (e) {
      debugPrint('Error cancelling reminder: $e');
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await _clearAllReminders();
      debugPrint('All reminders cancelled');
    } catch (e) {
      debugPrint('Error cancelling all reminders: $e');
    }
  }

  Future<List<Reminder>> getAllReminders() async {
    try {
      return await _getStoredReminders();
    } catch (e) {
      debugPrint('Error getting reminders: $e');
      return [];
    }
  }

  Future<Reminder?> getReminder(String reminderId) async {
    try {
      final reminders = await _getStoredReminders();
      return reminders.firstWhere((r) => r.id == reminderId);
    } catch (e) {
      debugPrint('Error getting reminder: $e');
      return null;
    }
  }

  Future<bool> updateReminder(Reminder reminder) async {
    try {
      await _removeReminder(reminder.id);
      await _saveReminder(reminder);
      return true;
    } catch (e) {
      debugPrint('Error updating reminder: $e');
      return false;
    }
  }

  Future<bool> toggleReminder(String reminderId, bool isActive) async {
    try {
      final reminder = await getReminder(reminderId);
      if (reminder != null) {
        final updatedReminder = reminder.copyWith(isActive: isActive);
        await updateReminder(updatedReminder);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling reminder: $e');
      return false;
    }
  }

  Future<void> _saveReminder(Reminder reminder) async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = await _getStoredReminders();
    
    // Remove existing reminder with same ID if it exists
    reminders.removeWhere((r) => r.id == reminder.id);
    reminders.add(reminder);
    
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await prefs.setString(_remindersKey, jsonEncode(remindersJson));
  }

  Future<void> _removeReminder(String reminderId) async {
    final prefs = await SharedPreferences.getInstance();
    final reminders = await _getStoredReminders();
    
    reminders.removeWhere((r) => r.id == reminderId);
    
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await prefs.setString(_remindersKey, jsonEncode(remindersJson));
  }

  Future<void> _clearAllReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_remindersKey);
  }

  Future<List<Reminder>> _getStoredReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersString = prefs.getString(_remindersKey);
    
    if (remindersString == null || remindersString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> remindersJson = jsonDecode(remindersString);
      return remindersJson.map((json) => Reminder.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error parsing stored reminders: $e');
      return [];
    }
  }

  // Simple method to show a test notification using SnackBar
  void showTestNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
