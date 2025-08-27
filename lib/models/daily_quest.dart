import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum QuestDifficulty {
  easy,
  medium,
  hard,
  epic,
  legendary,
}

enum QuestType {
  physical,
  mental,
  creative,
  social,
  wellness,
  adventure,
  learning,
  mindfulness,
}

class DailyQuest {
  final String id;
  final String title;
  final String description;
  final QuestDifficulty difficulty;
  final QuestType type;
  final HabitCategory category;
  final int timeRequired; // in minutes
  final int energyCost;
  final int rewardCoins;
  final double experienceGain;
  final List<String> requirements;
  final List<String> tips;
  final bool isCompleted;
  final DateTime assignedDate;
  final DateTime? completedDate;
  final String? completionNotes;

  DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.type,
    required this.category,
    required this.timeRequired,
    required this.energyCost,
    required this.rewardCoins,
    required this.experienceGain,
    required this.requirements,
    required this.tips,
    required this.isCompleted,
    required this.assignedDate,
    this.completedDate,
    this.completionNotes,
  });

  DailyQuest copyWith({
    String? id,
    String? title,
    String? description,
    QuestDifficulty? difficulty,
    QuestType? type,
    HabitCategory? category,
    int? timeRequired,
    int? energyCost,
    int? rewardCoins,
    double? experienceGain,
    List<String>? requirements,
    List<String>? tips,
    bool? isCompleted,
    DateTime? assignedDate,
    DateTime? completedDate,
    String? completionNotes,
  }) {
    return DailyQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      category: category ?? this.category,
      timeRequired: timeRequired ?? this.timeRequired,
      energyCost: energyCost ?? this.energyCost,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      experienceGain: experienceGain ?? this.experienceGain,
      requirements: requirements ?? this.requirements,
      tips: tips ?? this.tips,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedDate: assignedDate ?? this.assignedDate,
      completedDate: completedDate ?? this.completedDate,
      completionNotes: completionNotes ?? this.completionNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty.index,
      'type': type.index,
      'category': category.index,
      'timeRequired': timeRequired,
      'energyCost': energyCost,
      'rewardCoins': rewardCoins,
      'experienceGain': experienceGain,
      'requirements': requirements,
      'tips': tips,
      'isCompleted': isCompleted,
      'assignedDate': assignedDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'completionNotes': completionNotes,
    };
  }

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      difficulty: QuestDifficulty.values[json['difficulty']],
      type: QuestType.values[json['type']],
      category: HabitCategory.values[json['category']],
      timeRequired: json['timeRequired'],
      energyCost: json['energyCost'],
      rewardCoins: json['rewardCoins'],
      experienceGain: json['experienceGain'].toDouble(),
      requirements: List<String>.from(json['requirements']),
      tips: List<String>.from(json['tips']),
      isCompleted: json['isCompleted'],
      assignedDate: DateTime.parse(json['assignedDate']),
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
      completionNotes: json['completionNotes'],
    );
  }

  Color getDifficultyColor() {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return Colors.green;
      case QuestDifficulty.medium:
        return Colors.orange;
      case QuestDifficulty.hard:
        return Colors.red;
      case QuestDifficulty.epic:
        return Colors.purple;
      case QuestDifficulty.legendary:
        return Colors.amber;
    }
  }

  String getDifficultyText() {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 'Easy';
      case QuestDifficulty.medium:
        return 'Medium';
      case QuestDifficulty.hard:
        return 'Hard';
      case QuestDifficulty.epic:
        return 'Epic';
      case QuestDifficulty.legendary:
        return 'Legendary';
    }
  }

  IconData getTypeIcon() {
    switch (type) {
      case QuestType.physical:
        return Icons.fitness_center;
      case QuestType.mental:
        return Icons.psychology;
      case QuestType.creative:
        return Icons.brush;
      case QuestType.social:
        return Icons.people;
      case QuestType.wellness:
        return Icons.self_improvement;
      case QuestType.adventure:
        return Icons.explore;
      case QuestType.learning:
        return Icons.school;
      case QuestType.mindfulness:
        return Icons.spa;
    }
  }

  DailyQuest complete({String? notes}) {
    return copyWith(
      isCompleted: true,
      completedDate: DateTime.now(),
      completionNotes: notes,
    );
  }
}

class QuestGenerator {
  static final List<Map<String, dynamic>> _questTemplates = [
    // Physical Quests
    {
      'title': 'Drink water in a fancy glass',
      'description': 'Make hydration special by using your most elegant glassware',
      'type': QuestType.physical,
      'category': HabitCategory.health,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 5,
      'energyCost': 5,
      'rewardCoins': 10,
      'experienceGain': 15.0,
      'requirements': ['Find a fancy glass', 'Fill with water', 'Drink mindfully'],
      'tips': ['Use crystal glassware if available', 'Add lemon or cucumber for flavor'],
    },
    {
      'title': 'Do pushups in a new place',
      'description': 'Break the routine by doing pushups somewhere unexpected',
      'type': QuestType.physical,
      'category': HabitCategory.fitness,
      'difficulty': QuestDifficulty.medium,
      'timeRequired': 15,
      'energyCost': 20,
      'rewardCoins': 25,
      'experienceGain': 30.0,
      'requirements': ['Choose a new location', 'Do 10-20 pushups', 'Take a photo'],
      'tips': ['Try the park, beach, or even your office', 'Challenge yourself with variations'],
    },
    {
      'title': 'Take the scenic route',
      'description': 'Walk or drive a different path to discover new sights',
      'type': QuestType.adventure,
      'category': HabitCategory.fitness,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 30,
      'energyCost': 15,
      'rewardCoins': 20,
      'experienceGain': 25.0,
      'requirements': ['Choose a different route', 'Notice new things', 'Take photos'],
      'tips': ['Look for hidden alleys, parks, or viewpoints', 'Walk slower to observe more'],
    },
    
    // Mental Quests
    {
      'title': 'Learn a new word in another language',
      'description': 'Expand your vocabulary with a word from a language you don\'t know',
      'type': QuestType.learning,
      'category': HabitCategory.learning,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 10,
      'energyCost': 10,
      'rewardCoins': 15,
      'experienceGain': 20.0,
      'requirements': ['Choose a language', 'Learn one new word', 'Practice pronunciation'],
      'tips': ['Use language apps or online dictionaries', 'Try to use it in a sentence'],
    },
    {
      'title': 'Solve a puzzle in under 10 minutes',
      'description': 'Challenge your mind with a quick brain teaser',
      'type': QuestType.mental,
      'category': HabitCategory.learning,
      'difficulty': QuestDifficulty.medium,
      'timeRequired': 10,
      'energyCost': 15,
      'rewardCoins': 20,
      'experienceGain': 25.0,
      'requirements': ['Find a puzzle', 'Set 10-minute timer', 'Solve it'],
      'tips': ['Try crosswords, Sudoku, or online puzzles', 'Don\'t stress about time'],
    },
    
    // Creative Quests
    {
      'title': 'Draw something with your non-dominant hand',
      'description': 'Unlock creativity by using your less dominant hand',
      'type': QuestType.creative,
      'category': HabitCategory.creativity,
      'difficulty': QuestDifficulty.medium,
      'timeRequired': 20,
      'energyCost': 20,
      'rewardCoins': 25,
      'experienceGain': 30.0,
      'requirements': ['Get paper and pen', 'Choose a simple subject', 'Draw with non-dominant hand'],
      'tips': ['Start with simple shapes', 'Embrace the imperfections', 'Have fun with it'],
    },
    {
      'title': 'Write a haiku about your day',
      'description': 'Capture today\'s essence in 17 syllables',
      'type': QuestType.creative,
      'category': HabitCategory.creativity,
      'difficulty': QuestDifficulty.medium,
      'timeRequired': 15,
      'energyCost': 15,
      'rewardCoins': 20,
      'experienceGain': 25.0,
      'requirements': ['Write 3 lines', '5-7-5 syllable pattern', 'About your day'],
      'tips': ['Focus on one moment or feeling', 'Don\'t worry about perfection'],
    },
    
    // Social Quests
    {
      'title': 'Give a genuine compliment',
      'description': 'Brighten someone\'s day with a sincere compliment',
      'type': QuestType.social,
      'category': HabitCategory.social,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 5,
      'energyCost': 10,
      'rewardCoins': 15,
      'experienceGain': 20.0,
      'requirements': ['Find someone to compliment', 'Be specific and genuine', 'See their reaction'],
      'tips': ['Notice something unique about them', 'Compliment actions, not just appearance'],
    },
    {
      'title': 'Call someone you haven\'t talked to in a while',
      'description': 'Reconnect with an old friend or family member',
      'type': QuestType.social,
      'category': HabitCategory.social,
      'difficulty': QuestDifficulty.medium,
      'timeRequired': 20,
      'energyCost': 15,
      'rewardCoins': 25,
      'experienceGain': 30.0,
      'requirements': ['Choose someone to call', 'Have a meaningful conversation', 'Plan to stay in touch'],
      'tips': ['Ask about their life updates', 'Share your recent experiences', 'Be present in the conversation'],
    },
    
    // Wellness Quests
    {
      'title': 'Meditate in a new position',
      'description': 'Try meditating in a different posture or location',
      'type': QuestType.mindfulness,
      'category': HabitCategory.mindfulness,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 15,
      'energyCost': 10,
      'rewardCoins': 20,
      'experienceGain': 25.0,
      'requirements': ['Choose new position', 'Set timer for 15 minutes', 'Focus on breath'],
      'tips': ['Try lying down, walking, or standing', 'Don\'t worry about perfect posture'],
    },
    {
      'title': 'Practice gratitude with 5 things',
      'description': 'List 5 things you\'re grateful for today',
      'type': QuestType.mindfulness,
      'category': HabitCategory.mindfulness,
      'difficulty': QuestDifficulty.easy,
      'timeRequired': 10,
      'energyCost': 5,
      'rewardCoins': 15,
      'experienceGain': 20.0,
      'requirements': ['Find quiet space', 'Write down 5 things', 'Feel the gratitude'],
      'tips': ['Be specific about why you\'re grateful', 'Include both big and small things'],
    },
    
    // Epic Quests
    {
      'title': 'Complete a 30-day challenge',
      'description': 'Commit to a month-long habit transformation',
      'type': QuestType.physical,
      'category': HabitCategory.fitness,
      'difficulty': QuestDifficulty.epic,
      'timeRequired': 1440, // 24 hours over 30 days
      'energyCost': 100,
      'rewardCoins': 500,
      'experienceGain': 200.0,
      'requirements': ['Choose a challenge', 'Track daily progress', 'Complete all 30 days'],
      'tips': ['Start with something manageable', 'Find an accountability partner', 'Celebrate milestones'],
    },
    {
      'title': 'Learn a new skill from scratch',
      'description': 'Master something completely new to you',
      'type': QuestType.learning,
      'category': HabitCategory.learning,
      'difficulty': QuestDifficulty.epic,
      'timeRequired': 600, // 10 hours over time
      'energyCost': 80,
      'rewardCoins': 400,
      'experienceGain': 150.0,
      'requirements': ['Choose a skill', 'Practice daily', 'Track progress', 'Achieve basic proficiency'],
      'tips': ['Break it into small steps', 'Practice consistently', 'Don\'t fear mistakes'],
    },
    
    // Legendary Quests
    {
      'title': 'Transform your life in 100 days',
      'description': 'Undertake a comprehensive life transformation journey',
      'type': QuestType.adventure,
      'category': HabitCategory.other,
      'difficulty': QuestDifficulty.legendary,
      'timeRequired': 2400, // 40 hours over 100 days
      'energyCost': 200,
      'rewardCoins': 1000,
      'experienceGain': 500.0,
      'requirements': ['Set major life goals', 'Create daily action plan', 'Track progress', 'Achieve transformation'],
      'tips': ['Start with one area of life', 'Build momentum gradually', 'Celebrate every victory'],
    },
  ];

  static DailyQuest generateRandomQuest({
    QuestDifficulty? preferredDifficulty,
    QuestType? preferredType,
    HabitCategory? preferredCategory,
  }) {
    List<Map<String, dynamic>> filteredTemplates = _questTemplates;
    
    if (preferredDifficulty != null) {
      filteredTemplates = filteredTemplates.where((q) => q['difficulty'] == preferredDifficulty.index).toList();
    }
    
    if (preferredType != null) {
      filteredTemplates = filteredTemplates.where((q) => q['type'] == preferredType.index).toList();
    }
    
    if (preferredCategory != null) {
      filteredTemplates = filteredTemplates.where((q) => q['category'] == preferredCategory.index).toList();
    }
    
    if (filteredTemplates.isEmpty) {
      filteredTemplates = _questTemplates;
    }
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final selectedTemplate = filteredTemplates[random % filteredTemplates.length];
    
    return DailyQuest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: selectedTemplate['title'],
      description: selectedTemplate['description'],
      difficulty: QuestDifficulty.values[selectedTemplate['difficulty']],
      type: QuestType.values[selectedTemplate['type']],
      category: HabitCategory.values[selectedTemplate['category']],
      timeRequired: selectedTemplate['timeRequired'],
      energyCost: selectedTemplate['energyCost'],
      rewardCoins: selectedTemplate['rewardCoins'],
      experienceGain: selectedTemplate['experienceGain'],
      requirements: List<String>.from(selectedTemplate['requirements']),
      tips: List<String>.from(selectedTemplate['tips']),
      isCompleted: false,
      assignedDate: DateTime.now(),
    );
  }

  static List<DailyQuest> generateDailyQuests(int count) {
    final quests = <DailyQuest>[];
    final usedTypes = <QuestType>{};
    
    for (int i = 0; i < count; i++) {
      QuestType preferredType;
      
      // Try to get a different type each time
      if (usedTypes.length < QuestType.values.length) {
        final availableTypes = QuestType.values.where((t) => !usedTypes.contains(t)).toList();
        preferredType = availableTypes[DateTime.now().millisecondsSinceEpoch % availableTypes.length];
        usedTypes.add(preferredType);
      } else {
        preferredType = QuestType.values[DateTime.now().millisecondsSinceEpoch % QuestType.values.length];
      }
      
      quests.add(generateRandomQuest(preferredType: preferredType));
    }
    
    return quests;
  }

  static DailyQuest generatePersonalizedQuest({
    required HabitCategory category,
    required QuestDifficulty difficulty,
    required int timeAvailable,
  }) {
    final filteredTemplates = _questTemplates.where((q) => 
      q['category'] == category.index && 
      q['difficulty'] == difficulty.index &&
      q['timeRequired'] <= timeAvailable
    ).toList();
    
    if (filteredTemplates.isEmpty) {
      return generateRandomQuest();
    }
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final selectedTemplate = filteredTemplates[random % filteredTemplates.length];
    
    return DailyQuest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: selectedTemplate['title'],
      description: selectedTemplate['description'],
      difficulty: QuestDifficulty.values[selectedTemplate['difficulty']],
      type: QuestType.values[selectedTemplate['type']],
      category: HabitCategory.values[selectedTemplate['category']],
      timeRequired: selectedTemplate['timeRequired'],
      energyCost: selectedTemplate['energyCost'],
      rewardCoins: selectedTemplate['rewardCoins'],
      experienceGain: selectedTemplate['experienceGain'],
      requirements: List<String>.from(selectedTemplate['requirements']),
      tips: List<String>.from(selectedTemplate['tips']),
      isCompleted: false,
      assignedDate: DateTime.now(),
    );
  }
}
