import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum SynergyType {
  healthFitness,
  mindBody,
  productivityLearning,
  creativityWellness,
  socialFinance,
  environmentalMindfulness,
  strengthWisdom,
  balanceHarmony,
  growthTransformation,
  masteryExcellence,
}

enum SynergyLevel {
  basic,
  enhanced,
  powerful,
  legendary,
  transcendent,
}

enum SynergyStatus {
  inactive,
  building,
  active,
  amplified,
  mastered,
}

class HabitSynergy {
  final String id;
  final String name;
  final String description;
  final SynergyType type;
  final SynergyLevel level;
  final SynergyStatus status;
  final List<String> requiredHabitIds;
  final List<String> requiredHabitCategories;
  final Map<String, int> habitRequirements;
  final double synergyBonus;
  final List<String> benefits;
  final List<String> unlockedAchievements;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final DateTime lastUpdated;
  final int activationCount;
  final double totalBonusEarned;
  final Map<String, dynamic> metadata;

  HabitSynergy({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.level,
    required this.status,
    required this.requiredHabitIds,
    required this.requiredHabitCategories,
    required this.habitRequirements,
    required this.synergyBonus,
    required this.benefits,
    required this.unlockedAchievements,
    required this.createdAt,
    this.activatedAt,
    required this.lastUpdated,
    required this.activationCount,
    required this.totalBonusEarned,
    required this.metadata,
  });

  HabitSynergy copyWith({
    String? id,
    String? name,
    String? description,
    SynergyType? type,
    SynergyLevel? level,
    SynergyStatus? status,
    List<String>? requiredHabitIds,
    List<String>? requiredHabitCategories,
    Map<String, int>? habitRequirements,
    double? synergyBonus,
    List<String>? benefits,
    List<String>? unlockedAchievements,
    DateTime? createdAt,
    DateTime? activatedAt,
    DateTime? lastUpdated,
    int? activationCount,
    double? totalBonusEarned,
    Map<String, dynamic>? metadata,
  }) {
    return HabitSynergy(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      level: level ?? this.level,
      status: status ?? this.status,
      requiredHabitIds: requiredHabitIds ?? this.requiredHabitIds,
      requiredHabitCategories: requiredHabitCategories ?? this.requiredHabitCategories,
      habitRequirements: habitRequirements ?? this.habitRequirements,
      synergyBonus: synergyBonus ?? this.synergyBonus,
      benefits: benefits ?? this.benefits,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      activationCount: activationCount ?? this.activationCount,
      totalBonusEarned: totalBonusEarned ?? this.totalBonusEarned,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'level': level.index,
      'status': status.index,
      'requiredHabitIds': requiredHabitIds,
      'requiredHabitCategories': requiredHabitCategories,
      'habitRequirements': habitRequirements,
      'synergyBonus': synergyBonus,
      'benefits': benefits,
      'unlockedAchievements': unlockedAchievements,
      'createdAt': createdAt.toIso8601String(),
      'activatedAt': activatedAt?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'activationCount': activationCount,
      'totalBonusEarned': totalBonusEarned,
      'metadata': metadata,
    };
  }

  factory HabitSynergy.fromJson(Map<String, dynamic> json) {
    return HabitSynergy(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: SynergyType.values[json['type']],
      level: SynergyLevel.values[json['level']],
      status: SynergyStatus.values[json['status']],
      requiredHabitIds: List<String>.from(json['requiredHabitIds']),
      requiredHabitCategories: List<String>.from(json['requiredHabitCategories']),
      habitRequirements: Map<String, int>.from(json['habitRequirements']),
      synergyBonus: json['synergyBonus'].toDouble(),
      benefits: List<String>.from(json['benefits']),
      unlockedAchievements: List<String>.from(json['unlockedAchievements']),
      createdAt: DateTime.parse(json['createdAt']),
      activatedAt: json['activatedAt'] != null ? DateTime.parse(json['activatedAt']) : null,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      activationCount: json['activationCount'],
      totalBonusEarned: json['totalBonusEarned'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  bool get isActive => status == SynergyStatus.active;
  bool get isBuilding => status == SynergyStatus.building;
  bool get isAmplified => status == SynergyStatus.amplified;
  bool get isMastered => status == SynergyStatus.mastered;

  Color getSynergyTypeColor() {
    switch (type) {
      case SynergyType.healthFitness:
        return Colors.green;
      case SynergyType.mindBody:
        return Colors.blue;
      case SynergyType.productivityLearning:
        return Colors.orange;
      case SynergyType.creativityWellness:
        return Colors.purple;
      case SynergyType.socialFinance:
        return Colors.teal;
      case SynergyType.environmentalMindfulness:
        return Colors.lightGreen;
      case SynergyType.strengthWisdom:
        return Colors.indigo;
      case SynergyType.balanceHarmony:
        return Colors.pink;
      case SynergyType.growthTransformation:
        return Colors.amber;
      case SynergyType.masteryExcellence:
        return Colors.deepPurple;
    }
  }

  IconData getSynergyTypeIcon() {
    switch (type) {
      case SynergyType.healthFitness:
        return Icons.favorite;
      case SynergyType.mindBody:
        return Icons.psychology;
      case SynergyType.productivityLearning:
        return Icons.school;
      case SynergyType.creativityWellness:
        return Icons.brush;
      case SynergyType.socialFinance:
        return Icons.people;
      case SynergyType.environmentalMindfulness:
        return Icons.eco;
      case SynergyType.strengthWisdom:
        return Icons.fitness_center;
      case SynergyType.balanceHarmony:
        return Icons.balance;
      case SynergyType.growthTransformation:
        return Icons.trending_up;
      case SynergyType.masteryExcellence:
        return Icons.emoji_events;
    }
  }

  Color getSynergyLevelColor() {
    switch (level) {
      case SynergyLevel.basic:
        return Colors.grey;
      case SynergyLevel.enhanced:
        return Colors.green;
      case SynergyLevel.powerful:
        return Colors.blue;
      case SynergyLevel.legendary:
        return Colors.purple;
      case SynergyLevel.transcendent:
        return Colors.amber;
    }
  }

  String getSynergyLevelText() {
    switch (level) {
      case SynergyLevel.basic:
        return 'Basic';
      case SynergyLevel.enhanced:
        return 'Enhanced';
      case SynergyLevel.powerful:
        return 'Powerful';
      case SynergyLevel.legendary:
        return 'Legendary';
      case SynergyLevel.transcendent:
        return 'Transcendent';
    }
  }

  String getSynergyStatusDescription() {
    switch (status) {
      case SynergyStatus.inactive:
        return 'Synergy not yet discovered';
      case SynergyStatus.building:
        return 'Building synergy momentum';
      case SynergyStatus.active:
        return 'Synergy is active!';
      case SynergyStatus.amplified:
        return 'Synergy amplified!';
      case SynergyStatus.mastered:
        return 'Synergy mastered!';
    }
  }

  HabitSynergy activate() {
    if (status == SynergyStatus.inactive) {
      return copyWith(
        status: SynergyStatus.active,
        activatedAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        activationCount: activationCount + 1,
      );
    }
    return this;
  }

  HabitSynergy amplify() {
    if (status == SynergyStatus.active) {
      return copyWith(
        status: SynergyStatus.amplified,
        lastUpdated: DateTime.now(),
        activationCount: activationCount + 1,
      );
    }
    return this;
  }

  HabitSynergy master() {
    if (status == SynergyStatus.amplified) {
      return copyWith(
        status: SynergyStatus.mastered,
        lastUpdated: DateTime.now(),
        activationCount: activationCount + 1,
      );
    }
    return this;
  }

  HabitSynergy addBonus(double bonus) {
    return copyWith(
      totalBonusEarned: totalBonusEarned + bonus,
      lastUpdated: DateTime.now(),
    );
  }

  bool canActivate(List<Habit> userHabits) {
    // Check if user has habits in required categories
    final userCategories = userHabits.map((h) => h.category.name).toSet();
    if (!requiredHabitCategories.every((cat) => userCategories.contains(cat))) {
      return false;
    }
    
    // Check if user meets habit requirements
    for (final entry in habitRequirements.entries) {
      final category = HabitCategory.values.firstWhere((c) => c.name == entry.key);
      final requiredCount = entry.value;
      final userHabitsInCategory = userHabits.where((h) => h.category == category).length;
      
      if (userHabitsInCategory < requiredCount) {
        return false;
      }
    }
    
    return true;
  }

  double getProgressPercentage(List<Habit> userHabits) {
    if (canActivate(userHabits)) return 100.0;
    
    int totalRequirements = 0;
    int metRequirements = 0;
    
    // Count category requirements
    totalRequirements += requiredHabitCategories.length;
    final userCategories = userHabits.map((h) => h.category.name).toSet();
    metRequirements += requiredHabitCategories.where((cat) => userCategories.contains(cat)).length;
    
    // Count habit requirements
    for (final entry in habitRequirements.entries) {
      final category = HabitCategory.values.firstWhere((c) => c.name == entry.key);
      final requiredCount = entry.value;
      final userHabitsInCategory = userHabits.where((h) => h.category == category).length;
      
      totalRequirements += requiredCount;
      metRequirements += userHabitsInCategory.clamp(0, requiredCount);
    }
    
    if (totalRequirements == 0) return 0.0;
    return (metRequirements / totalRequirements) * 100;
  }
}

class SynergyManager {
  static final List<HabitSynergy> _availableSynergies = [
    // Health & Fitness Synergy
    HabitSynergy(
      id: 'health_fitness_synergy',
      name: 'Body & Soul Harmony',
      description: 'Combine health and fitness habits for enhanced physical well-being',
      type: SynergyType.healthFitness,
      level: SynergyLevel.basic,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['health', 'fitness'],
      habitRequirements: {'health': 2, 'fitness': 2},
      synergyBonus: 25.0,
      benefits: [
        'Enhanced physical performance',
        'Faster recovery times',
        'Improved energy levels',
        'Better sleep quality',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'physical_wellness',
        'difficulty': 'easy',
        'category': 'health',
      },
    ),
    
    // Mind & Body Synergy
    HabitSynergy(
      id: 'mind_body_synergy',
      name: 'Mind-Body Connection',
      description: 'Unite mental and physical practices for holistic wellness',
      type: SynergyType.mindBody,
      level: SynergyLevel.enhanced,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['mindfulness', 'fitness'],
      habitRequirements: {'mindfulness': 1, 'fitness': 1, 'health': 1},
      synergyBonus: 35.0,
      benefits: [
        'Enhanced mental clarity',
        'Better stress management',
        'Improved focus and concentration',
        'Balanced energy flow',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'holistic_wellness',
        'difficulty': 'medium',
        'category': 'wellness',
      },
    ),
    
    // Productivity & Learning Synergy
    HabitSynergy(
      id: 'productivity_learning_synergy',
      name: 'Knowledge & Efficiency',
      description: 'Combine learning and productivity habits for accelerated growth',
      type: SynergyType.productivityLearning,
      level: SynergyLevel.powerful,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['learning', 'productivity'],
      habitRequirements: {'learning': 2, 'productivity': 2},
      synergyBonus: 50.0,
      benefits: [
        'Faster skill acquisition',
        'Improved problem-solving',
        'Enhanced creativity',
        'Better time management',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'intellectual_growth',
        'difficulty': 'medium',
        'category': 'development',
      },
    ),
    
    // Creativity & Wellness Synergy
    HabitSynergy(
      id: 'creativity_wellness_synergy',
      name: 'Creative Wellness',
      description: 'Merge creative and wellness practices for inspired living',
      type: SynergyType.creativityWellness,
      level: SynergyLevel.enhanced,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['creativity', 'mindfulness'],
      habitRequirements: {'creativity': 1, 'mindfulness': 1, 'health': 1},
      synergyBonus: 40.0,
      benefits: [
        'Enhanced creative flow',
        'Better emotional balance',
        'Improved self-expression',
        'Deeper artistic insight',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'artistic_wellness',
        'difficulty': 'medium',
        'category': 'creativity',
      },
    ),
    
    // Social & Finance Synergy
    HabitSynergy(
      id: 'social_finance_synergy',
      name: 'Social Prosperity',
      description: 'Combine social and financial habits for community wealth',
      type: SynergyType.socialFinance,
      level: SynergyLevel.powerful,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['social', 'finance'],
      habitRequirements: {'social': 2, 'finance': 2},
      synergyBonus: 45.0,
      benefits: [
        'Better networking opportunities',
        'Improved financial literacy',
        'Enhanced social capital',
        'Stronger community bonds',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'community_prosperity',
        'difficulty': 'medium',
        'category': 'social',
      },
    ),
    
    // Environmental & Mindfulness Synergy
    HabitSynergy(
      id: 'environmental_mindfulness_synergy',
      name: 'Earth Consciousness',
      description: 'Unite environmental awareness with mindful living',
      type: SynergyType.environmentalMindfulness,
      level: SynergyLevel.legendary,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['mindfulness', 'other'],
      habitRequirements: {'mindfulness': 2, 'other': 2},
      synergyBonus: 75.0,
      benefits: [
        'Deep environmental awareness',
        'Sustainable living practices',
        'Enhanced spiritual connection',
        'Global impact consciousness',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'environmental_consciousness',
        'difficulty': 'hard',
        'category': 'sustainability',
      },
    ),
    
    // Strength & Wisdom Synergy
    HabitSynergy(
      id: 'strength_wisdom_synergy',
      name: 'Warrior Sage',
      description: 'Combine physical strength with mental wisdom',
      type: SynergyType.strengthWisdom,
      level: SynergyLevel.legendary,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['fitness', 'learning'],
      habitRequirements: {'fitness': 3, 'learning': 3},
      synergyBonus: 80.0,
      benefits: [
        'Enhanced physical prowess',
        'Deep intellectual insight',
        'Balanced strength and wisdom',
        'Legendary status potential',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'warrior_sage',
        'difficulty': 'hard',
        'category': 'mastery',
      },
    ),
    
    // Balance & Harmony Synergy
    HabitSynergy(
      id: 'balance_harmony_synergy',
      name: 'Life Harmony',
      description: 'Achieve perfect balance across all life areas',
      type: SynergyType.balanceHarmony,
      level: SynergyLevel.transcendent,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['health', 'mindfulness', 'social'],
      habitRequirements: {'health': 1, 'mindfulness': 1, 'social': 1, 'fitness': 1, 'learning': 1},
      synergyBonus: 100.0,
      benefits: [
        'Perfect life balance',
        'Enhanced inner peace',
        'Harmonious relationships',
        'Transcendent consciousness',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'life_harmony',
        'difficulty': 'very_hard',
        'category': 'enlightenment',
      },
    ),
    
    // Growth & Transformation Synergy
    HabitSynergy(
      id: 'growth_transformation_synergy',
      name: 'Phoenix Rising',
      description: 'Transform yourself through continuous growth habits',
      type: SynergyType.growthTransformation,
      level: SynergyLevel.transcendent,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['learning', 'creativity', 'productivity'],
      habitRequirements: {'learning': 2, 'creativity': 2, 'productivity': 2},
      synergyBonus: 90.0,
      benefits: [
        'Accelerated personal growth',
        'Transformative breakthroughs',
        'Enhanced innovation capacity',
        'Legendary achievement potential',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'personal_transformation',
        'difficulty': 'very_hard',
        'category': 'evolution',
      },
    ),
    
    // Mastery & Excellence Synergy
    HabitSynergy(
      id: 'mastery_excellence_synergy',
      name: 'Master of All',
      description: 'Achieve mastery across multiple life domains',
      type: SynergyType.masteryExcellence,
      level: SynergyLevel.transcendent,
      status: SynergyStatus.inactive,
      requiredHabitIds: [],
      requiredHabitCategories: ['health', 'fitness', 'learning', 'productivity'],
      habitRequirements: {'health': 2, 'fitness': 2, 'learning': 2, 'productivity': 2},
      synergyBonus: 150.0,
      benefits: [
        'Mastery of multiple domains',
        'Unstoppable excellence',
        'Legendary status',
        'Transcendent achievement',
      ],
      unlockedAchievements: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      activationCount: 0,
      totalBonusEarned: 0.0,
      metadata: {
        'theme': 'ultimate_mastery',
        'difficulty': 'legendary',
        'category': 'transcendence',
      },
    ),
  ];

  static List<HabitSynergy> getAvailableSynergies() {
    return List.from(_availableSynergies);
  }

  static HabitSynergy? getSynergyById(String id) {
    try {
      return _availableSynergies.firstWhere((synergy) => synergy.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<HabitSynergy> getSynergiesByLevel(SynergyLevel level) {
    return _availableSynergies.where((synergy) => synergy.level == level).toList();
  }

  static List<HabitSynergy> getSynergiesByType(SynergyType type) {
    return _availableSynergies.where((synergy) => synergy.type == type).toList();
  }

  static List<HabitSynergy> getActiveSynergies(List<HabitSynergy> userSynergies) {
    return userSynergies.where((synergy) => synergy.isActive).toList();
  }

  static List<HabitSynergy> getBuildingSynergies(List<HabitSynergy> userSynergies) {
    return userSynergies.where((synergy) => synergy.isBuilding).toList();
  }

  static double calculateTotalSynergyBonus(List<HabitSynergy> activeSynergies) {
    return activeSynergies.fold(0.0, (sum, synergy) => sum + synergy.synergyBonus);
  }

  static String generateSynergyMotivationalMessage(List<HabitSynergy> activeSynergies) {
    if (activeSynergies.isEmpty) {
      return 'Discover your first habit synergy to unlock powerful bonuses! 🌟';
    }
    
    final totalBonus = calculateTotalSynergyBonus(activeSynergies);
    final synergyCount = activeSynergies.length;
    
    if (totalBonus >= 200) {
      return 'You\'re a synergy master! Multiple habits working in perfect harmony! 🎭';
    } else if (totalBonus >= 100) {
      return 'Incredible synergy power! Your habits are creating magic together! ✨';
    } else if (synergyCount >= 3) {
      return 'Amazing synergy network! Your habits are amplifying each other! 🌊';
    } else if (synergyCount >= 2) {
      return 'Great synergy! Your habits are working together beautifully! 🌈';
    } else {
      return 'Synergy activated! Your habits are more powerful together! 💪';
    }
  }
}
