import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  Map<String, Reminder> _reminders = {};
  bool _isLoading = false;

  Map<String, Reminder> get reminders => _reminders;
  List<Reminder> get allReminders => _reminders.values.toList();
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _loadReminders();
  }

  Future<void> _loadReminders() async {
    _setLoading(true);
    try {
      final reminders = await _notificationService.getAllReminders();
      _reminders = {
        for (var reminder in reminders) reminder.id: reminder
      };
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addReminder(Reminder reminder) async {
    try {
      final success = await _notificationService.scheduleReminder(reminder);
      if (success) {
        _reminders[reminder.id] = reminder;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding reminder: $e');
      return false;
    }
  }

  Future<bool> updateReminder(Reminder reminder) async {
    try {
      await _notificationService.updateReminder(reminder);
      _reminders[reminder.id] = reminder;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating reminder: $e');
      return false;
    }
  }

  Future<bool> deleteReminder(String reminderId) async {
    try {
      await _notificationService.cancelReminder(reminderId);
      _reminders.remove(reminderId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
      return false;
    }
  }

  Future<void> toggleReminder(String reminderId, bool isActive) async {
    try {
      await _notificationService.toggleReminder(reminderId, isActive);
      final reminder = _reminders[reminderId];
      if (reminder != null) {
        _reminders[reminderId] = reminder.copyWith(isActive: isActive);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling reminder: $e');
    }
  }

  List<Reminder> getRemindersForHabit(String habitId) {
    return _reminders.values
        .where((reminder) => reminder.habitId == habitId)
        .toList();
  }

  Reminder? getReminder(String reminderId) {
    return _reminders[reminderId];
  }

  Future<void> deleteAllReminders() async {
    try {
      await _notificationService.cancelAllReminders();
      _reminders.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting all reminders: $e');
    }
  }

  Future<void> deleteRemindersForHabit(String habitId) async {
    try {
      final habitReminders = getRemindersForHabit(habitId);
      for (final reminder in habitReminders) {
        await _notificationService.cancelReminder(reminder.id);
        _reminders.remove(reminder.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting reminders for habit: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Test notification
  void showTestNotification(BuildContext context, String message) {
    _notificationService.showTestNotification(context, message);
  }

  // Get reminders by time of day
  List<Reminder> getRemindersByTime(int hour, int minute) {
    return _reminders.values
        .where((reminder) => 
          reminder.hour == hour && 
          reminder.minute == minute)
        .toList();
  }

  // Get reminders by day of week
  List<Reminder> getRemindersByDay(int dayOfWeek) {
    return _reminders.values
        .where((reminder) => reminder.daysOfWeek.contains(dayOfWeek))
        .toList();
  }

  // Get active reminders
  List<Reminder> get activeReminders {
    return _reminders.values
        .where((reminder) => reminder.isActive)
        .toList();
  }

  // Get inactive reminders
  List<Reminder> get inactiveReminders {
    return _reminders.values
        .where((reminder) => !reminder.isActive)
        .toList();
  }

  // Get reminders count
  int get remindersCount => _reminders.length;
  int get activeRemindersCount => activeReminders.length;
  int get inactiveRemindersCount => inactiveReminders.length;
}
