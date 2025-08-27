import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum RippleType {
  health,
  fitness,
  learning,
  productivity,
  mindfulness,
  social,
  finance,
  creativity,
  environmental,
  kindness,
}

enum RippleIntensity {
  gentle,
  moderate,
  strong,
  powerful,
  legendary,
}

enum RippleStatus {
  active,
  spreading,
  amplified,
  completed,
  expired,
}

class CommunityRipple {
  final String id;
  final String userId;
  final String userName;
  final RippleType type;
  final RippleIntensity intensity;
  final String description;
  final DateTime createdAt;
  final DateTime expiresAt;
  final double impactValue;
  final List<String> tags;
  final List<String> affectedUsers;
  final RippleStatus status;
  final Map<String, dynamic> metadata;
  final int spreadCount;
  final int amplificationCount;

  CommunityRipple({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.intensity,
    required this.description,
    required this.createdAt,
    required this.expiresAt,
    required this.impactValue,
    required this.tags,
    required this.affectedUsers,
    required this.status,
    required this.metadata,
    required this.spreadCount,
    required this.amplificationCount,
  });

  CommunityRipple copyWith({
    String? id,
    String? userId,
    String? userName,
    RippleType? type,
    RippleIntensity? intensity,
    String? description,
    DateTime? createdAt,
    DateTime? expiresAt,
    double? impactValue,
    List<String>? tags,
    List<String>? affectedUsers,
    RippleStatus? status,
    Map<String, dynamic>? metadata,
    int? spreadCount,
    int? amplificationCount,
  }) {
    return CommunityRipple(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      impactValue: impactValue ?? this.impactValue,
      tags: tags ?? this.tags,
      affectedUsers: affectedUsers ?? this.affectedUsers,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      spreadCount: spreadCount ?? this.spreadCount,
      amplificationCount: amplificationCount ?? this.amplificationCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'type': type.index,
      'intensity': intensity.index,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'impactValue': impactValue,
      'tags': tags,
      'affectedUsers': affectedUsers,
      'status': status.index,
      'metadata': metadata,
      'spreadCount': spreadCount,
      'amplificationCount': amplificationCount,
    };
  }

  factory CommunityRipple.fromJson(Map<String, dynamic> json) {
    return CommunityRipple(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      type: RippleType.values[json['type']],
      intensity: RippleIntensity.values[json['intensity']],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      impactValue: json['impactValue'].toDouble(),
      tags: List<String>.from(json['tags']),
      affectedUsers: List<String>.from(json['affectedUsers']),
      status: RippleStatus.values[json['status']],
      metadata: Map<String, dynamic>.from(json['metadata']),
      spreadCount: json['spreadCount'],
      amplificationCount: json['amplificationCount'],
    );
  }

  factory CommunityRipple.createFromHabit({
    required String userId,
    required String userName,
    required Habit habit,
    required RippleIntensity intensity,
  }) {
    final now = DateTime.now();
    final rippleType = _mapHabitCategoryToRippleType(habit.category);
    final impactValue = _calculateImpactValue(intensity, habit.category);
    final description = _generateRippleDescription(habit, intensity);
    final tags = _generateTags(habit, intensity);
    
    return CommunityRipple(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      type: rippleType,
      intensity: intensity,
      description: description,
      createdAt: now,
      expiresAt: now.add(const Duration(days: 7)),
      impactValue: impactValue,
      tags: tags,
      affectedUsers: [userId],
      status: RippleStatus.active,
      metadata: {
        'habitId': habit.id,
        'habitTitle': habit.title,
        'habitCategory': habit.category.name,
        'completionTime': now.toIso8601String(),
        'streak': habit.currentStreak,
      },
      spreadCount: 0,
      amplificationCount: 0,
    );
  }

  static RippleType _mapHabitCategoryToRippleType(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return RippleType.health;
      case HabitCategory.fitness:
        return RippleType.fitness;
      case HabitCategory.learning:
        return RippleType.learning;
      case HabitCategory.productivity:
        return RippleType.productivity;
      case HabitCategory.mindfulness:
        return RippleType.mindfulness;
      case HabitCategory.social:
        return RippleType.social;
      case HabitCategory.finance:
        return RippleType.finance;
      case HabitCategory.creativity:
        return RippleType.creativity;
      case HabitCategory.other:
        return RippleType.kindness;
    }
  }

  static double _calculateImpactValue(RippleIntensity intensity, HabitCategory category) {
    double baseValue = 10.0;
    
    // Intensity multiplier
    switch (intensity) {
      case RippleIntensity.gentle:
        baseValue *= 1.0;
        break;
      case RippleIntensity.moderate:
        baseValue *= 1.5;
        break;
      case RippleIntensity.strong:
        baseValue *= 2.0;
        break;
      case RippleIntensity.powerful:
        baseValue *= 3.0;
        break;
      case RippleIntensity.legendary:
        baseValue *= 5.0;
        break;
    }
    
    // Category multiplier
    switch (category) {
      case HabitCategory.health:
        baseValue *= 1.2;
        break;
      case HabitCategory.fitness:
        baseValue *= 1.1;
        break;
      case HabitCategory.learning:
        baseValue *= 1.3;
        break;
      case HabitCategory.productivity:
        baseValue *= 1.4;
        break;
      case HabitCategory.mindfulness:
        baseValue *= 1.5;
        break;
      case HabitCategory.social:
        baseValue *= 1.6;
        break;
      case HabitCategory.finance:
        baseValue *= 1.2;
        break;
      case HabitCategory.creativity:
        baseValue *= 1.3;
        break;
      case HabitCategory.other:
        baseValue *= 1.0;
        break;
    }
    
    return baseValue;
  }

  static String _generateRippleDescription(Habit habit, RippleIntensity intensity) {
    final intensityText = intensity.name;
    final categoryName = habit.category.name;
    
    switch (intensity) {
      case RippleIntensity.gentle:
        return 'A gentle ripple of $categoryName energy spreads from ${habit.title}';
      case RippleIntensity.moderate:
        return 'A moderate wave of $categoryName inspiration flows from ${habit.title}';
      case RippleIntensity.strong:
        return 'A strong surge of $categoryName motivation radiates from ${habit.title}';
      case RippleIntensity.powerful:
        return 'A powerful explosion of $categoryName energy erupts from ${habit.title}';
      case RippleIntensity.legendary:
        return 'A legendary storm of $categoryName power transforms the world through ${habit.title}';
    }
  }

  static List<String> _generateTags(Habit habit, RippleIntensity intensity) {
    final tags = <String>[];
    
    // Add category tag
    tags.add(habit.category.name);
    
    // Add intensity tag
    tags.add(intensity.name);
    
    // Add habit-specific tags
    if (habit.currentStreak > 7) {
      tags.add('streak_master');
    }
    if (habit.currentStreak > 30) {
      tags.add('legendary_streak');
    }
    
    // Add motivational tags
    tags.add('inspiration');
    tags.add('community');
    tags.add('positive_impact');
    
    return tags;
  }

  bool get isActive => status == RippleStatus.active;
  bool get isSpreading => status == RippleStatus.spreading;
  bool get isAmplified => status == RippleStatus.amplified;
  bool get isCompleted => status == RippleStatus.completed;
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Color getRippleTypeColor() {
    switch (type) {
      case RippleType.health:
        return Colors.green;
      case RippleType.fitness:
        return Colors.blue;
      case RippleType.learning:
        return Colors.purple;
      case RippleType.productivity:
        return Colors.orange;
      case RippleType.mindfulness:
        return Colors.teal;
      case RippleType.social:
        return Colors.pink;
      case RippleType.finance:
        return Colors.amber;
      case RippleType.creativity:
        return Colors.indigo;
      case RippleType.environmental:
        return Colors.lightGreen;
      case RippleType.kindness:
        return Colors.red;
    }
  }

  IconData getRippleTypeIcon() {
    switch (type) {
      case RippleType.health:
        return Icons.favorite;
      case RippleType.fitness:
        return Icons.fitness_center;
      case RippleType.learning:
        return Icons.school;
      case RippleType.productivity:
        return Icons.work;
      case RippleType.mindfulness:
        return Icons.spa;
      case RippleType.social:
        return Icons.people;
      case RippleType.finance:
        return Icons.attach_money;
      case RippleType.creativity:
        return Icons.brush;
      case RippleType.environmental:
        return Icons.eco;
      case RippleType.kindness:
        return Icons.favorite_border;
    }
  }

  Color getIntensityColor() {
    switch (intensity) {
      case RippleIntensity.gentle:
        return Colors.lightBlue;
      case RippleIntensity.moderate:
        return Colors.blue;
      case RippleIntensity.strong:
        return Colors.indigo;
      case RippleIntensity.powerful:
        return Colors.purple;
      case RippleIntensity.legendary:
        return Colors.amber;
    }
  }

  String getIntensityText() {
    switch (intensity) {
      case RippleIntensity.gentle:
        return 'Gentle';
      case RippleIntensity.moderate:
        return 'Moderate';
      case RippleIntensity.strong:
        return 'Strong';
      case RippleIntensity.powerful:
        return 'Powerful';
      case RippleIntensity.legendary:
        return 'Legendary';
    }
  }

  CommunityRipple spread(String newUserId) {
    if (isExpired || isCompleted) return this;
    
    final newAffectedUsers = List<String>.from(affectedUsers);
    if (!newAffectedUsers.contains(newUserId)) {
      newAffectedUsers.add(newUserId);
    }
    
    RippleStatus newStatus = status;
    if (newAffectedUsers.length >= 5 && status == RippleStatus.active) {
      newStatus = RippleStatus.spreading;
    }
    
    return copyWith(
      affectedUsers: newAffectedUsers,
      status: newStatus,
      spreadCount: spreadCount + 1,
    );
  }

  CommunityRipple amplify() {
    if (isExpired || isCompleted) return this;
    
    final newImpactValue = impactValue * 1.5;
    final newStatus = status == RippleStatus.spreading ? RippleStatus.amplified : status;
    
    return copyWith(
      impactValue: newImpactValue,
      status: newStatus,
      amplificationCount: amplificationCount + 1,
    );
  }

  CommunityRipple complete() {
    return copyWith(status: RippleStatus.completed);
  }

  String getRippleStatusDescription() {
    switch (status) {
      case RippleStatus.active:
        return 'Creating positive impact';
      case RippleStatus.spreading:
        return 'Spreading through community';
      case RippleStatus.amplified:
        return 'Amplified by community';
      case RippleStatus.completed:
        return 'Mission accomplished';
      case RippleStatus.expired:
        return 'Ripple expired';
    }
  }

  Duration getRemainingTime() {
    if (isExpired) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }

  String getRemainingTimeText() {
    final remaining = getRemainingTime();
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d remaining';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h remaining';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m remaining';
    } else {
      return 'Expiring soon';
    }
  }
}

class GlobalRippleEffect {
  final String id;
  final RippleType type;
  final int totalRipples;
  final int activeRipples;
  final double totalImpact;
  final double averageImpact;
  final List<String> topContributors;
  final List<String> recentRipples;
  final DateTime lastUpdated;
  final String globalStatus;
  final Map<String, dynamic> statistics;

  GlobalRippleEffect({
    required this.id,
    required this.type,
    required this.totalRipples,
    required this.activeRipples,
    required this.totalImpact,
    required this.averageImpact,
    required this.topContributors,
    required this.recentRipples,
    required this.lastUpdated,
    required this.globalStatus,
    required this.statistics,
  });

  GlobalRippleEffect copyWith({
    String? id,
    RippleType? type,
    int? totalRipples,
    int? activeRipples,
    double? totalImpact,
    double? averageImpact,
    List<String>? topContributors,
    List<String>? recentRipples,
    DateTime? lastUpdated,
    String? globalStatus,
    Map<String, dynamic>? statistics,
  }) {
    return GlobalRippleEffect(
      id: id ?? this.id,
      type: type ?? this.type,
      totalRipples: totalRipples ?? this.totalRipples,
      activeRipples: activeRipples ?? this.activeRipples,
      totalImpact: totalImpact ?? this.totalImpact,
      averageImpact: averageImpact ?? this.averageImpact,
      topContributors: topContributors ?? this.topContributors,
      recentRipples: recentRipples ?? this.recentRipples,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      globalStatus: globalStatus ?? this.globalStatus,
      statistics: statistics ?? this.statistics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'totalRipples': totalRipples,
      'activeRipples': activeRipples,
      'totalImpact': totalImpact,
      'averageImpact': averageImpact,
      'topContributors': topContributors,
      'recentRipples': recentRipples,
      'lastUpdated': lastUpdated.toIso8601String(),
      'globalStatus': globalStatus,
      'statistics': statistics,
    };
  }

  factory GlobalRippleEffect.fromJson(Map<String, dynamic> json) {
    return GlobalRippleEffect(
      id: json['id'],
      type: RippleType.values[json['type']],
      totalRipples: json['totalRipples'],
      activeRipples: json['activeRipples'],
      totalImpact: json['totalImpact'].toDouble(),
      averageImpact: json['averageImpact'].toDouble(),
      topContributors: List<String>.from(json['topContributors']),
      recentRipples: List<String>.from(json['recentRipples']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      globalStatus: json['globalStatus'],
      statistics: Map<String, dynamic>.from(json['statistics']),
    );
  }

  factory GlobalRippleEffect.createForType(RippleType type) {
    return GlobalRippleEffect(
      id: '${type.name}_global_effect',
      type: type,
      totalRipples: 0,
      activeRipples: 0,
      totalImpact: 0.0,
      averageImpact: 0.0,
      topContributors: [],
      recentRipples: [],
      lastUpdated: DateTime.now(),
      globalStatus: 'Building momentum',
      statistics: {
        'daily_average': 0.0,
        'weekly_growth': 0.0,
        'monthly_trend': 'stable',
        'peak_hours': [],
        'geographic_spread': [],
      },
    );
  }

  GlobalRippleEffect addRipple(CommunityRipple ripple) {
    final newTotalRipples = totalRipples + 1;
    final newActiveRipples = activeRipples + (ripple.isActive ? 1 : 0);
    final newTotalImpact = totalImpact + ripple.impactValue;
    final newAverageImpact = newTotalImpact / newTotalRipples;
    
    final newTopContributors = List<String>.from(topContributors);
    if (!newTopContributors.contains(ripple.userName)) {
      newTopContributors.add(ripple.userName);
      if (newTopContributors.length > 10) {
        newTopContributors.removeAt(0);
      }
    }
    
    final newRecentRipples = List<String>.from(recentRipples);
    newRecentRipples.add(ripple.id);
    if (newRecentRipples.length > 20) {
      newRecentRipples.removeAt(0);
    }
    
    String newGlobalStatus = globalStatus;
    if (newTotalRipples >= 1000) {
      newGlobalStatus = 'Global phenomenon!';
    } else if (newTotalRipples >= 500) {
      newGlobalStatus = 'Worldwide impact';
    } else if (newTotalRipples >= 100) {
      newGlobalStatus = 'Growing community';
    } else if (newTotalRipples >= 50) {
      newGlobalStatus = 'Building momentum';
    }
    
    return copyWith(
      totalRipples: newTotalRipples,
      activeRipples: newActiveRipples,
      totalImpact: newTotalImpact,
      averageImpact: newAverageImpact,
      topContributors: newTopContributors,
      recentRipples: newRecentRipples,
      lastUpdated: DateTime.now(),
      globalStatus: newGlobalStatus,
    );
  }

  String getImpactDescription() {
    if (totalImpact >= 10000) {
      return 'Transformative impact on the world! 🌍';
    } else if (totalImpact >= 5000) {
      return 'Massive positive change spreading globally! 🌟';
    } else if (totalImpact >= 1000) {
      return 'Significant community transformation! ✨';
    } else if (totalImpact >= 500) {
      return 'Growing positive influence! 🌱';
    } else if (totalImpact >= 100) {
      return 'Building positive momentum! 💫';
    } else {
      return 'Starting to make a difference! 🌱';
    }
  }

  Color getImpactColor() {
    if (totalImpact >= 10000) return Colors.amber;
    if (totalImpact >= 5000) return Colors.purple;
    if (totalImpact >= 1000) return Colors.blue;
    if (totalImpact >= 500) return Colors.green;
    if (totalImpact >= 100) return Colors.orange;
    return Colors.grey;
  }
}

class RippleGenerator {
  static CommunityRipple generateRippleFromHabit({
    required String userId,
    required String userName,
    required Habit habit,
    required int streak,
    required int totalCompletions,
  }) {
    RippleIntensity intensity;
    
    // Determine intensity based on streak and completions
    if (streak >= 100 || totalCompletions >= 1000) {
      intensity = RippleIntensity.legendary;
    } else if (streak >= 50 || totalCompletions >= 500) {
      intensity = RippleIntensity.powerful;
    } else if (streak >= 30 || totalCompletions >= 200) {
      intensity = RippleIntensity.strong;
    } else if (streak >= 7 || totalCompletions >= 50) {
      intensity = RippleIntensity.moderate;
    } else {
      intensity = RippleIntensity.gentle;
    }
    
    return CommunityRipple.createFromHabit(
      userId: userId,
      userName: userName,
      habit: habit,
      intensity: intensity,
    );
  }

  static List<CommunityRipple> generateDailyRipples({
    required String userId,
    required String userName,
    required List<Habit> completedHabits,
  }) {
    final ripples = <CommunityRipple>[];
    
    for (final habit in completedHabits) {
      final ripple = generateRippleFromHabit(
        userId: userId,
        userName: userName,
        habit: habit,
        streak: habit.currentStreak,
        totalCompletions: habit.totalCompletions,
      );
      ripples.add(ripple);
    }
    
    return ripples;
  }

  static String generateMotivationalMessage(List<CommunityRipple> ripples) {
    if (ripples.isEmpty) return 'Start your ripple effect today!';
    
    final totalImpact = ripples.fold(0.0, (sum, ripple) => sum + ripple.impactValue);
    final rippleCount = ripples.length;
    
    if (totalImpact >= 100) {
      return 'You\'re creating waves of positive change! 🌊';
    } else if (rippleCount >= 5) {
      return 'Your habits are spreading inspiration everywhere! ✨';
    } else if (rippleCount >= 3) {
      return 'You\'re building a ripple of positive energy! 🌟';
    } else {
      return 'Every habit creates a ripple of change! 💫';
    }
  }
}
