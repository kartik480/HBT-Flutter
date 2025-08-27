import 'package:flutter/material.dart';

enum HabitFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

enum HabitCategory {
  health,
  fitness,
  learning,
  productivity,
  mindfulness,
  social,
  finance,
  creativity,
  other,
}

class Habit {
  final String id;
  final String title;
  final String description;
  final HabitCategory category;
  final HabitFrequency frequency;
  final int targetCount;
  final TimeOfDay? reminderTime;
  final Color color;
  final DateTime createdAt;
  final Map<DateTime, bool> completionHistory;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.targetCount,
    this.reminderTime,
    required this.color,
    required this.createdAt,
    Map<DateTime, bool>? completionHistory,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
  })  : completionHistory = completionHistory ?? {},
        currentStreak = currentStreak ?? 0,
        longestStreak = longestStreak ?? 0,
        totalCompletions = totalCompletions ?? 0;

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    int? targetCount,
    TimeOfDay? reminderTime,
    Color? color,
    DateTime? createdAt,
    Map<DateTime, bool>? completionHistory,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      reminderTime: reminderTime ?? this.reminderTime,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      completionHistory: completionHistory ?? this.completionHistory,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    return completionHistory[todayKey] ?? false;
  }

  bool isCompletedOnDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return completionHistory[dateKey] ?? false;
  }

  void markCompleted(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    completionHistory[dateKey] = true;
  }

  void markIncomplete(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    completionHistory[dateKey] = false;
  }

  double getCompletionRate() {
    if (completionHistory.isEmpty) return 0.0;
    
    final completedDays = completionHistory.values.where((completed) => completed).length;
    return completedDays / completionHistory.length;
  }

  int getDaysSinceCreation() {
    final now = DateTime.now();
    return now.difference(createdAt).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'frequency': frequency.index,
      'targetCount': targetCount,
      'reminderTime': reminderTime != null ? '${reminderTime!.hour}:${reminderTime!.minute}' : null,
      'color': color.value,
      'createdAt': createdAt.toIso8601String(),
      'completionHistory': completionHistory.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      ),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompletions': totalCompletions,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: HabitCategory.values[json['category']],
      frequency: HabitFrequency.values[json['frequency']],
      targetCount: json['targetCount'],
      reminderTime: json['reminderTime'] != null
          ? _parseTimeOfDay(json['reminderTime'])
          : null,
      color: Color(json['color']),
      createdAt: DateTime.parse(json['createdAt']),
      completionHistory: (json['completionHistory'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(DateTime.parse(key), value as bool),
      ),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      totalCompletions: json['totalCompletions'] ?? 0,
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String getCategoryName(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.mindfulness:
        return 'Mindfulness';
      case HabitCategory.social:
        return 'Social';
      case HabitCategory.finance:
        return 'Finance';
      case HabitCategory.creativity:
        return 'Creativity';
      case HabitCategory.other:
        return 'Other';
    }
  }

  static IconData getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.learning:
        return Icons.school;
      case HabitCategory.productivity:
        return Icons.work;
      case HabitCategory.mindfulness:
        return Icons.self_improvement;
      case HabitCategory.social:
        return Icons.people;
      case HabitCategory.finance:
        return Icons.account_balance_wallet;
      case HabitCategory.creativity:
        return Icons.brush;
      case HabitCategory.other:
        return Icons.star;
    }
  }

  static String getFrequencyName(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.custom:
        return 'Custom';
    }
  }
}
