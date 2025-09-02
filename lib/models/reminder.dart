import 'package:flutter/material.dart';

enum ReminderFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

class Reminder {
  final String id;
  final String habitId;
  final String title;
  final String message;
  final int hour;
  final int minute;
  final ReminderFrequency frequency;
  final List<int> daysOfWeek; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? soundFile;
  final bool vibrate;
  final bool showNotification;
  final DateTime? lastTriggered;

  Reminder({
    required this.id,
    required this.habitId,
    required this.title,
    required this.message,
    required this.hour,
    required this.minute,
    required this.frequency,
    this.daysOfWeek = const [1, 2, 3, 4, 5], // Default to weekdays
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.soundFile,
    this.vibrate = true,
    this.showNotification = true,
    this.lastTriggered,
  });

  // Getters for computed properties
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  String get timeString {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

  List<String> get daysOfWeekNames {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return daysOfWeek.map((day) => dayNames[day]).toList();
  }

  String get frequencyText {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }

  String get scheduleDescription {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Every day at $timeString';
      case ReminderFrequency.weekly:
        if (daysOfWeek.length == 7) {
          return 'Every day at $timeString';
        } else if (daysOfWeek.length == 5 && 
                   daysOfWeek.contains(1) && daysOfWeek.contains(2) && 
                   daysOfWeek.contains(3) && daysOfWeek.contains(4) && 
                   daysOfWeek.contains(5)) {
          return 'Weekdays at $timeString';
        } else {
          return '${daysOfWeekNames.join(', ')} at $timeString';
        }
      case ReminderFrequency.monthly:
        return 'Monthly at $timeString';
      case ReminderFrequency.custom:
        return 'Custom schedule at $timeString';
    }
  }

  // Static methods for UI helpers
  static String getFrequencyText(ReminderFrequency frequency) {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }

  static List<String> getDayNames() {
    return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  }

  static List<String> getShortDayNames() {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'title': title,
      'message': message,
      'hour': hour,
      'minute': minute,
      'frequency': frequency.name,
      'daysOfWeek': daysOfWeek,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'soundFile': soundFile,
      'vibrate': vibrate,
      'showNotification': showNotification,
      'lastTriggered': lastTriggered?.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      frequency: ReminderFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => ReminderFrequency.daily,
      ),
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
          ?.map((day) => day as int)
          .toList() ?? [1, 2, 3, 4, 5],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      soundFile: json['soundFile'] as String?,
      vibrate: json['vibrate'] as bool? ?? true,
      showNotification: json['showNotification'] as bool? ?? true,
      lastTriggered: json['lastTriggered'] != null ? DateTime.parse(json['lastTriggered'] as String) : null,
    );
  }

  // Copy with method for updates
  Reminder copyWith({
    String? id,
    String? habitId,
    String? title,
    String? message,
    int? hour,
    int? minute,
    ReminderFrequency? frequency,
    List<int>? daysOfWeek,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? soundFile,
    bool? vibrate,
    bool? showNotification,
    DateTime? lastTriggered,
  }) {
    return Reminder(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      title: title ?? this.title,
      message: message ?? this.message,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      frequency: frequency ?? this.frequency,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      soundFile: soundFile ?? this.soundFile,
      vibrate: vibrate ?? this.vibrate,
      showNotification: showNotification ?? this.showNotification,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Reminder(id: $id, title: $title, time: $timeString, frequency: $frequency)';
  }
}
