import 'package:flutter/material.dart';

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

enum HabitFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

class Habit {
  final String id;
  final String title;
  final String description;
  final HabitCategory category;
  final HabitFrequency frequency;
  final Color color;
  final int targetCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<DateTime, bool> completionHistory;
  final bool isActive;
  final String? iconName;
  final TimeOfDay? reminderTime;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.color,
    required this.targetCount,
    required this.createdAt,
    this.updatedAt,
    this.completionHistory = const {},
    this.isActive = true,
    this.iconName,
    this.reminderTime,
  });

  // Getters for computed properties
  int get currentStreak {
    if (completionHistory.isEmpty) return 0;
    
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime currentDate = todayDate;
    
    // Check if completed today
    if (isCompletedToday()) {
      streak = 1;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    
    // Count consecutive days
    while (completionHistory.containsKey(currentDate) && completionHistory[currentDate] == true) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    
    return streak;
  }

  int get totalCompletions => completionHistory.values.where((completed) => completed).length;

  double getCompletionRate() {
    if (completionHistory.isEmpty) return 0.0;
    
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    final expectedCompletions = _getExpectedCompletions(daysSinceCreation);
    
    if (expectedCompletions == 0) return 0.0;
    
    return (totalCompletions / expectedCompletions).clamp(0.0, 1.0);
  }

  int _getExpectedCompletions(int days) {
    switch (frequency) {
      case HabitFrequency.daily:
        return days;
      case HabitFrequency.weekly:
        return (days / 7).ceil();
      case HabitFrequency.monthly:
        return (days / 30).ceil();
      case HabitFrequency.custom:
        return days; // For custom, assume daily
    }
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return completionHistory.containsKey(todayDate) && completionHistory[todayDate] == true;
  }

  bool isCompletedOnDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    
    return completionHistory.containsKey(targetDate) && completionHistory[targetDate] == true;
  }

  // Additional methods that were referenced in the code
  void markCompleted([DateTime? date]) {
    final targetDate = date ?? DateTime.now();
    final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    completionHistory[dateOnly] = true;
  }

  void markIncomplete([DateTime? date]) {
    final targetDate = date ?? DateTime.now();
    final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    completionHistory.remove(dateOnly);
  }

  int get longestStreak {
    if (completionHistory.isEmpty) return 0;
    
    final sortedDates = completionHistory.keys.where((date) => completionHistory[date] == true).toList()
      ..sort((a, b) => a.compareTo(b));
    
    if (sortedDates.isEmpty) return 0;
    
    int maxStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final prevDate = DateTime(sortedDates[i - 1].year, sortedDates[i - 1].month, sortedDates[i - 1].day);
      final currentDate = DateTime(sortedDates[i].year, sortedDates[i].month, sortedDates[i].day);
      
      if (currentDate.difference(prevDate).inDays == 1) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 1;
      }
    }
    
    return maxStreak;
  }

  // Properties that were referenced in the code
  DateTime? get lastTriggered => null; // Placeholder for reminder system

  // Static methods for UI helpers
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

  static IconData getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.health_and_safety;
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
        return Icons.palette;
      case HabitCategory.other:
        return Icons.category;
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'frequency': frequency.name,
      'color': color.value,
      'targetCount': targetCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completionHistory': completionHistory.map((date, completed) => MapEntry(date.toIso8601String(), completed)),
      'isActive': isActive,
      'iconName': iconName,
      'reminderTime': reminderTime != null ? '${reminderTime!.hour}:${reminderTime!.minute}' : null,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: HabitCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => HabitCategory.other,
      ),
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      color: Color(json['color'] as int),
      targetCount: json['targetCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      completionHistory: (json['completionHistory'] as Map<String, dynamic>?)
          ?.map((dateStr, completed) => MapEntry(DateTime.parse(dateStr), completed as bool))
          ?? {},
      isActive: json['isActive'] as bool? ?? true,
      iconName: json['iconName'] as String?,
      reminderTime: json['reminderTime'] != null 
          ? TimeOfDay(
              hour: int.parse(json['reminderTime'].split(':')[0]),
              minute: int.parse(json['reminderTime'].split(':')[1]),
            )
          : null,
    );
  }

  // Copy with method for updates
  Habit copyWith({
    String? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    Color? color,
    int? targetCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<DateTime, bool>? completionHistory,
    bool? isActive,
    String? iconName,
    TimeOfDay? reminderTime,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      color: color ?? this.color,
      targetCount: targetCount ?? this.targetCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completionHistory: completionHistory ?? this.completionHistory,
      isActive: isActive ?? this.isActive,
      iconName: iconName ?? this.iconName,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Habit && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, category: $category, frequency: $frequency)';
  }
}
