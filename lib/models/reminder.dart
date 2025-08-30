import 'package:flutter/foundation.dart';

enum ReminderFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

enum ReminderTime {
  morning,
  afternoon,
  evening,
  night,
  custom,
}

class Reminder {
  final String id;
  final String habitId;
  final String title;
  final String message;
  final int hour;
  final int minute;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final ReminderFrequency frequency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastTriggered;

  const Reminder({
    required this.id,
    required this.habitId,
    required this.title,
    required this.message,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    required this.frequency,
    this.isActive = true,
    required this.createdAt,
    this.lastTriggered,
  });

  Reminder copyWith({
    String? id,
    String? habitId,
    String? title,
    String? message,
    int? hour,
    int? minute,
    List<int>? daysOfWeek,
    ReminderFrequency? frequency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return Reminder(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      title: title ?? this.title,
      message: message ?? this.message,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      frequency: frequency ?? this.frequency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'title': title,
      'message': message,
      'hour': hour,
      'minute': minute,
      'daysOfWeek': daysOfWeek,
      'frequency': frequency.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastTriggered': lastTriggered?.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      habitId: json['habitId'],
      title: json['title'],
      message: json['message'],
      hour: json['hour'],
      minute: json['minute'],
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      frequency: ReminderFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
      ),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastTriggered: json['lastTriggered'] != null
          ? DateTime.parse(json['lastTriggered'])
          : null,
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
    return 'Reminder(id: $id, habitId: $habitId, title: $title, hour: $hour, minute: $minute, daysOfWeek: $daysOfWeek, frequency: $frequency, isActive: $isActive)';
  }
}
