import 'package:flutter/material.dart';

enum AvatarMood {
  energetic,
  confident,
  focused,
  peaceful,
  determined,
  playful,
  wise,
  strong,
  creative,
  balanced,
}

enum AvatarState {
  weak,
  dull,
  average,
  growing,
  strong,
  powerful,
  legendary,
  enlightened,
}

class Avatar {
  final String id;
  final String name;
  final AvatarState state;
  final AvatarMood mood;
  final int level;
  final double experience;
  final double health;
  final double strength;
  final double wisdom;
  final double creativity;
  final double balance;
  final List<String> achievements;
  final DateTime lastUpdated;
  final String currentStory;

  Avatar({
    required this.id,
    required this.name,
    required this.state,
    required this.mood,
    required this.level,
    required this.experience,
    required this.health,
    required this.strength,
    required this.wisdom,
    required this.creativity,
    required this.balance,
    required this.achievements,
    required this.lastUpdated,
    required this.currentStory,
  });

  Avatar copyWith({
    String? id,
    String? name,
    AvatarState? state,
    AvatarMood? mood,
    int? level,
    double? experience,
    double? health,
    double? strength,
    double? wisdom,
    double? creativity,
    double? balance,
    List<String>? achievements,
    DateTime? lastUpdated,
    String? currentStory,
  }) {
    return Avatar(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      mood: mood ?? this.mood,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      health: health ?? this.health,
      strength: strength ?? this.strength,
      wisdom: wisdom ?? this.wisdom,
      creativity: creativity ?? this.creativity,
      balance: balance ?? this.balance,
      achievements: achievements ?? this.achievements,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currentStory: currentStory ?? this.currentStory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state.index,
      'mood': mood.index,
      'level': level,
      'experience': experience,
      'health': health,
      'strength': strength,
      'wisdom': wisdom,
      'creativity': creativity,
      'balance': balance,
      'achievements': achievements,
      'lastUpdated': lastUpdated.toIso8601String(),
      'currentStory': currentStory,
    };
  }

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      name: json['name'],
      state: AvatarState.values[json['state']],
      mood: AvatarMood.values[json['mood']],
      level: json['level'],
      experience: json['experience'].toDouble(),
      health: json['health'].toDouble(),
      strength: json['strength'].toDouble(),
      wisdom: json['wisdom'].toDouble(),
      creativity: json['creativity'].toDouble(),
      balance: json['balance'].toDouble(),
      achievements: List<String>.from(json['achievements']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      currentStory: json['currentStory'],
    );
  }

  factory Avatar.createDefault(String name) {
    return Avatar(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      state: AvatarState.average,
      mood: AvatarMood.determined,
      level: 1,
      experience: 0.0,
      health: 50.0,
      strength: 30.0,
      wisdom: 40.0,
      creativity: 35.0,
      balance: 45.0,
      achievements: ['First Steps'],
      lastUpdated: DateTime.now(),
      currentStory: 'A new hero begins their journey...',
    );
  }

  String getStateDescription() {
    switch (state) {
      case AvatarState.weak:
        return 'Starting your journey';
      case AvatarState.dull:
        return 'Need some motivation';
      case AvatarState.average:
        return 'Building momentum';
      case AvatarState.growing:
        return 'Getting stronger';
      case AvatarState.strong:
        return 'Impressive progress';
      case AvatarState.powerful:
        return 'Unstoppable force';
      case AvatarState.legendary:
        return 'Living legend';
      case AvatarState.enlightened:
        return 'Transcended limits';
    }
  }

  String getMoodDescription() {
    switch (mood) {
      case AvatarMood.energetic:
        return 'Full of energy and ready to conquer!';
      case AvatarMood.confident:
        return 'Feeling unstoppable today!';
      case AvatarMood.focused:
        return 'Laser-focused on goals!';
      case AvatarMood.peaceful:
        return 'Inner peace and tranquility';
      case AvatarMood.determined:
        return 'Nothing will stop you!';
      case AvatarMood.playful:
        return 'Having fun while growing!';
      case AvatarMood.wise:
        return 'Gaining wisdom through experience';
      case AvatarMood.strong:
        return 'Physical and mental strength';
      case AvatarMood.creative:
        return 'Creative juices flowing!';
      case AvatarMood.balanced:
        return 'Perfect harmony in life';
    }
  }

  double getOverallScore() {
    return (health + strength + wisdom + creativity + balance) / 5.0;
  }

  bool get canLevelUp => experience >= level * 100;

  Avatar levelUp() {
    if (!canLevelUp) return this;
    
    final newLevel = level + 1;
    final newExperience = experience - (level * 100);
    
    // Increase stats based on level
    final statIncrease = newLevel * 2.0;
    
    return copyWith(
      level: newLevel,
      experience: newExperience,
      health: (health + statIncrease).clamp(0, 100),
      strength: (strength + statIncrease).clamp(0, 100),
      wisdom: (wisdom + statIncrease).clamp(0, 100),
      creativity: (creativity + statIncrease).clamp(0, 100),
      balance: (balance + statIncrease).clamp(0, 100),
      lastUpdated: DateTime.now(),
    );
  }

  Avatar updateFromHabits(List<Habit> completedHabits, List<Habit> missedHabits) {
    double healthChange = 0;
    double strengthChange = 0;
    double wisdomChange = 0;
    double creativityChange = 0;
    double balanceChange = 0;
    double experienceGain = 0;
    AvatarMood newMood = mood;
    AvatarState newState = state;

    // Calculate changes from completed habits
    for (final habit in completedHabits) {
      experienceGain += 10;
      
      switch (habit.category) {
        case HabitCategory.health:
          healthChange += 2;
          break;
        case HabitCategory.fitness:
          strengthChange += 2;
          break;
        case HabitCategory.learning:
          wisdomChange += 2;
          break;
        case HabitCategory.creativity:
          creativityChange += 2;
          break;
        case HabitCategory.mindfulness:
          balanceChange += 2;
          break;
        default:
          balanceChange += 1;
          break;
      }
    }

    // Calculate penalties from missed habits
    for (final habit in missedHabits) {
      experienceGain -= 5;
      
      switch (habit.category) {
        case HabitCategory.health:
          healthChange -= 1;
          break;
        case HabitCategory.fitness:
          strengthChange -= 1;
          break;
        case HabitCategory.learning:
          wisdomChange -= 1;
          break;
        case HabitCategory.creativity:
          creativityChange -= 1;
          break;
        case HabitCategory.mindfulness:
          balanceChange -= 1;
          break;
        default:
          balanceChange -= 0.5;
          break;
      }
    }

    // Update mood based on overall performance
    if (completedHabits.length > missedHabits.length) {
      if (completedHabits.length >= 5) {
        newMood = AvatarMood.energetic;
      } else if (completedHabits.length >= 3) {
        newMood = AvatarMood.confident;
      } else {
        newMood = AvatarMood.determined;
      }
    } else if (missedHabits.length > completedHabits.length) {
      newMood = AvatarMood.determined; // Encourage improvement
    }

    // Update state based on overall score
    final newOverallScore = getOverallScore();
    if (newOverallScore >= 90) {
      newState = AvatarState.enlightened;
    } else if (newOverallScore >= 80) {
      newState = AvatarState.legendary;
    } else if (newOverallScore >= 70) {
      newState = AvatarState.powerful;
    } else if (newOverallScore >= 60) {
      newState = AvatarState.strong;
    } else if (newOverallScore >= 50) {
      newState = AvatarState.growing;
    } else if (newOverallScore >= 40) {
      newState = AvatarState.average;
    } else if (newOverallScore >= 30) {
      newState = AvatarState.dull;
    } else {
      newState = AvatarState.weak;
    }

    return copyWith(
      health: (health + healthChange).clamp(0, 100),
      strength: (strength + strengthChange).clamp(0, 100),
      wisdom: (wisdom + wisdomChange).clamp(0, 100),
      creativity: (creativity + creativityChange).clamp(0, 100),
      balance: (balance + balanceChange).clamp(0, 100),
      experience: (experience + experienceGain).clamp(0, double.infinity),
      mood: newMood,
      state: newState,
      lastUpdated: DateTime.now(),
    );
  }
}
