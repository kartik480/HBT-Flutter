import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum EvolutionStage {
  basic,
  improved,
  advanced,
  expert,
  master,
  legendary,
  transcendent,
  divine,
}

enum EvolutionTrigger {
  streak,
  completionCount,
  consistency,
  timeBased,
  achievement,
  synergy,
  community,
  special,
}

enum EvolutionType {
  power,
  efficiency,
  wisdom,
  creativity,
  resilience,
  adaptability,
  influence,
  transformation,
}

class HabitEvolution {
  final String id;
  final String habitId;
  final String habitTitle;
  final EvolutionStage currentStage;
  final EvolutionStage nextStage;
  final EvolutionType type;
  final List<EvolutionTrigger> triggers;
  final Map<String, dynamic> requirements;
  final Map<String, dynamic> benefits;
  final List<String> unlockedAbilities;
  final List<String> evolutionHistory;
  final DateTime createdAt;
  final DateTime? lastEvolved;
  final DateTime lastUpdated;
  final int evolutionCount;
  final double evolutionProgress;
  final Map<String, dynamic> metadata;

  HabitEvolution({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.currentStage,
    required this.nextStage,
    required this.type,
    required this.triggers,
    required this.requirements,
    required this.benefits,
    required this.unlockedAbilities,
    required this.evolutionHistory,
    required this.createdAt,
    this.lastEvolved,
    required this.lastUpdated,
    required this.evolutionCount,
    required this.evolutionProgress,
    required this.metadata,
  });

  HabitEvolution copyWith({
    String? id,
    String? habitId,
    String? habitTitle,
    EvolutionStage? currentStage,
    EvolutionStage? nextStage,
    EvolutionType? type,
    List<EvolutionTrigger>? triggers,
    Map<String, dynamic>? requirements,
    Map<String, dynamic>? benefits,
    List<String>? unlockedAbilities,
    List<String>? evolutionHistory,
    DateTime? createdAt,
    DateTime? lastEvolved,
    DateTime? lastUpdated,
    int? evolutionCount,
    double? evolutionProgress,
    Map<String, dynamic>? metadata,
  }) {
    return HabitEvolution(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitTitle: habitTitle ?? this.habitTitle,
      currentStage: currentStage ?? this.currentStage,
      nextStage: nextStage ?? this.nextStage,
      type: type ?? this.type,
      triggers: triggers ?? this.triggers,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      unlockedAbilities: unlockedAbilities ?? this.unlockedAbilities,
      evolutionHistory: evolutionHistory ?? this.evolutionHistory,
      createdAt: createdAt ?? this.createdAt,
      lastEvolved: lastEvolved ?? this.lastEvolved,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      evolutionCount: evolutionCount ?? this.evolutionCount,
      evolutionProgress: evolutionProgress ?? this.evolutionProgress,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'habitTitle': habitTitle,
      'currentStage': currentStage.index,
      'nextStage': nextStage.index,
      'type': type.index,
      'triggers': triggers.map((t) => t.index).toList(),
      'requirements': requirements,
      'benefits': benefits,
      'unlockedAbilities': unlockedAbilities,
      'evolutionHistory': evolutionHistory,
      'createdAt': createdAt.toIso8601String(),
      'lastEvolved': lastEvolved?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'evolutionCount': evolutionCount,
      'evolutionProgress': evolutionProgress,
      'metadata': metadata,
    };
  }

  factory HabitEvolution.fromJson(Map<String, dynamic> json) {
    return HabitEvolution(
      id: json['id'],
      habitId: json['habitId'],
      habitTitle: json['habitTitle'],
      currentStage: EvolutionStage.values[json['currentStage']],
      nextStage: EvolutionStage.values[json['nextStage']],
      type: EvolutionType.values[json['type']],
      triggers: (json['triggers'] as List).map((t) => EvolutionTrigger.values[t]).toList(),
      requirements: Map<String, dynamic>.from(json['requirements']),
      benefits: Map<String, dynamic>.from(json['benefits']),
      unlockedAbilities: List<String>.from(json['unlockedAbilities']),
      evolutionHistory: List<String>.from(json['evolutionHistory']),
      createdAt: DateTime.parse(json['createdAt']),
      lastEvolved: json['lastEvolved'] != null ? DateTime.parse(json['lastEvolved']) : null,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      evolutionCount: json['evolutionCount'],
      evolutionProgress: json['evolutionProgress'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  factory HabitEvolution.createFromHabit(Habit habit) {
    final evolutionType = _determineEvolutionType(habit.category);
    final initialStage = EvolutionStage.basic;
    final nextStage = _getNextStage(initialStage);
    
    return HabitEvolution(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      habitId: habit.id,
      habitTitle: habit.title,
      currentStage: initialStage,
      nextStage: nextStage,
      type: evolutionType,
      triggers: _getDefaultTriggers(evolutionType),
      requirements: _getStageRequirements(nextStage, evolutionType),
      benefits: _getStageBenefits(nextStage, evolutionType),
      unlockedAbilities: _getStageAbilities(initialStage, evolutionType),
      evolutionHistory: ['Habit ${habit.title} began its evolution journey'],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      evolutionCount: 0,
      evolutionProgress: 0.0,
      metadata: {
        'category': habit.category.name,
        'initial_streak': habit.currentStreak,
        'initial_completions': habit.totalCompletions,
        'evolution_path': evolutionType.name,
      },
    );
  }

  static EvolutionType _determineEvolutionType(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return EvolutionType.resilience;
      case HabitCategory.fitness:
        return EvolutionType.power;
      case HabitCategory.learning:
        return EvolutionType.wisdom;
      case HabitCategory.productivity:
        return EvolutionType.efficiency;
      case HabitCategory.mindfulness:
        return EvolutionType.transformation;
      case HabitCategory.social:
        return EvolutionType.influence;
      case HabitCategory.finance:
        return EvolutionType.adaptability;
      case HabitCategory.creativity:
        return EvolutionType.creativity;
      case HabitCategory.other:
        return EvolutionType.adaptability;
    }
  }

  static List<EvolutionTrigger> _getDefaultTriggers(EvolutionType type) {
    switch (type) {
      case EvolutionType.power:
        return [EvolutionTrigger.streak, EvolutionTrigger.completionCount];
      case EvolutionType.efficiency:
        return [EvolutionTrigger.consistency, EvolutionTrigger.timeBased];
      case EvolutionType.wisdom:
        return [EvolutionTrigger.completionCount, EvolutionTrigger.achievement];
      case EvolutionType.creativity:
        return [EvolutionTrigger.consistency, EvolutionTrigger.synergy];
      case EvolutionType.resilience:
        return [EvolutionTrigger.streak, EvolutionTrigger.consistency];
      case EvolutionType.adaptability:
        return [EvolutionTrigger.achievement, EvolutionTrigger.community];
      case EvolutionType.influence:
        return [EvolutionTrigger.community, EvolutionTrigger.synergy];
      case EvolutionType.transformation:
        return [EvolutionTrigger.achievement, EvolutionTrigger.special];
    }
  }

  static EvolutionStage _getNextStage(EvolutionStage currentStage) {
    switch (currentStage) {
      case EvolutionStage.basic:
        return EvolutionStage.improved;
      case EvolutionStage.improved:
        return EvolutionStage.advanced;
      case EvolutionStage.advanced:
        return EvolutionStage.expert;
      case EvolutionStage.expert:
        return EvolutionStage.master;
      case EvolutionStage.master:
        return EvolutionStage.legendary;
      case EvolutionStage.legendary:
        return EvolutionStage.transcendent;
      case EvolutionStage.transcendent:
        return EvolutionStage.divine;
      case EvolutionStage.divine:
        return EvolutionStage.divine; // Max stage
    }
  }

  static Map<String, dynamic> _getStageRequirements(EvolutionStage stage, EvolutionType type) {
    final baseRequirements = <String, dynamic>{};
    
    switch (stage) {
      case EvolutionStage.improved:
        baseRequirements['streak'] = 7;
        baseRequirements['completions'] = 50;
        break;
      case EvolutionStage.advanced:
        baseRequirements['streak'] = 21;
        baseRequirements['completions'] = 150;
        baseRequirements['consistency'] = 0.8;
        break;
      case EvolutionStage.expert:
        baseRequirements['streak'] = 50;
        baseRequirements['completions'] = 300;
        baseRequirements['consistency'] = 0.9;
        break;
      case EvolutionStage.master:
        baseRequirements['streak'] = 100;
        baseRequirements['completions'] = 500;
        baseRequirements['consistency'] = 0.95;
        baseRequirements['achievements'] = 3;
        break;
      case EvolutionStage.legendary:
        baseRequirements['streak'] = 200;
        baseRequirements['completions'] = 1000;
        baseRequirements['consistency'] = 0.98;
        baseRequirements['achievements'] = 5;
        break;
      case EvolutionStage.transcendent:
        baseRequirements['streak'] = 365;
        baseRequirements['completions'] = 2000;
        baseRequirements['consistency'] = 0.99;
        baseRequirements['achievements'] = 10;
        break;
      case EvolutionStage.divine:
        baseRequirements['streak'] = 1000;
        baseRequirements['completions'] = 5000;
        baseRequirements['consistency'] = 1.0;
        baseRequirements['achievements'] = 20;
        break;
      default:
        baseRequirements['streak'] = 0;
        baseRequirements['completions'] = 0;
    }
    
    // Add type-specific requirements
    switch (type) {
      case EvolutionType.power:
        baseRequirements['strength_bonus'] = baseRequirements['streak'] * 0.1;
        break;
      case EvolutionType.efficiency:
        baseRequirements['time_efficiency'] = baseRequirements['completions'] * 0.05;
        break;
      case EvolutionType.wisdom:
        baseRequirements['knowledge_gain'] = baseRequirements['completions'] * 0.1;
        break;
      case EvolutionType.creativity:
        baseRequirements['creative_output'] = baseRequirements['completions'] * 0.08;
        break;
      case EvolutionType.resilience:
        baseRequirements['recovery_rate'] = baseRequirements['streak'] * 0.15;
        break;
      case EvolutionType.adaptability:
        baseRequirements['flexibility_score'] = baseRequirements['achievements'] * 0.2;
        break;
      case EvolutionType.influence:
        baseRequirements['community_impact'] = baseRequirements['completions'] * 0.12;
        break;
      case EvolutionType.transformation:
        baseRequirements['transformation_level'] = baseRequirements['achievements'] * 0.25;
        break;
    }
    
    return baseRequirements;
  }

  static Map<String, dynamic> _getStageBenefits(EvolutionStage stage, EvolutionType type) {
    final benefits = <String, dynamic>{};
    
    switch (stage) {
      case EvolutionStage.improved:
        benefits['bonus_multiplier'] = 1.2;
        benefits['unlock_ability'] = 'Enhanced Focus';
        break;
      case EvolutionStage.advanced:
        benefits['bonus_multiplier'] = 1.5;
        benefits['unlock_ability'] = 'Advanced Techniques';
        break;
      case EvolutionStage.expert:
        benefits['bonus_multiplier'] = 2.0;
        benefits['unlock_ability'] = 'Expert Mastery';
        break;
      case EvolutionStage.master:
        benefits['bonus_multiplier'] = 3.0;
        benefits['unlock_ability'] = 'Master Techniques';
        break;
      case EvolutionStage.legendary:
        benefits['bonus_multiplier'] = 5.0;
        benefits['unlock_ability'] = 'Legendary Powers';
        break;
      case EvolutionStage.transcendent:
        benefits['bonus_multiplier'] = 10.0;
        benefits['unlock_ability'] = 'Transcendent Abilities';
        break;
      case EvolutionStage.divine:
        benefits['bonus_multiplier'] = 25.0;
        benefits['unlock_ability'] = 'Divine Powers';
        break;
      default:
        benefits['bonus_multiplier'] = 1.0;
        benefits['unlock_ability'] = 'Basic Abilities';
    }
    
    // Add type-specific benefits
    switch (type) {
      case EvolutionType.power:
        benefits['strength_boost'] = stage.index * 0.5;
        benefits['endurance_enhancement'] = stage.index * 0.3;
        break;
      case EvolutionType.efficiency:
        benefits['time_savings'] = stage.index * 0.4;
        benefits['productivity_boost'] = stage.index * 0.6;
        break;
      case EvolutionType.wisdom:
        benefits['knowledge_retention'] = stage.index * 0.5;
        benefits['insight_gain'] = stage.index * 0.4;
        break;
      case EvolutionType.creativity:
        benefits['creative_flow'] = stage.index * 0.6;
        benefits['inspiration_rate'] = stage.index * 0.5;
        break;
      case EvolutionType.resilience:
        benefits['stress_resistance'] = stage.index * 0.4;
        benefits['recovery_speed'] = stage.index * 0.6;
        break;
      case EvolutionType.adaptability:
        benefits['flexibility'] = stage.index * 0.5;
        benefits['adaptation_speed'] = stage.index * 0.5;
        break;
      case EvolutionType.influence:
        benefits['leadership_aura'] = stage.index * 0.6;
        benefits['inspiration_power'] = stage.index * 0.4;
        break;
      case EvolutionType.transformation:
        benefits['transformation_speed'] = stage.index * 0.7;
        benefits['evolution_potential'] = stage.index * 0.8;
        break;
    }
    
    return benefits;
  }

  static List<String> _getStageAbilities(EvolutionStage stage, EvolutionType type) {
    final abilities = <String>[];
    
    switch (stage) {
      case EvolutionStage.basic:
        abilities.add('Basic Habit Execution');
        break;
      case EvolutionStage.improved:
        abilities.add('Enhanced Focus');
        abilities.add('Better Consistency');
        break;
      case EvolutionStage.advanced:
        abilities.add('Advanced Techniques');
        abilities.add('Efficiency Optimization');
        break;
      case EvolutionStage.expert:
        abilities.add('Expert Mastery');
        abilities.add('Skill Specialization');
        break;
      case EvolutionStage.master:
        abilities.add('Master Techniques');
        abilities.add('Innovation Creation');
        break;
      case EvolutionStage.legendary:
        abilities.add('Legendary Powers');
        abilities.add('Reality Manipulation');
        break;
      case EvolutionStage.transcendent:
        abilities.add('Transcendent Abilities');
        abilities.add('Cosmic Awareness');
        break;
      case EvolutionStage.divine:
        abilities.add('Divine Powers');
        abilities.add('Omnipotent Control');
        break;
    }
    
    // Add type-specific abilities
    switch (type) {
      case EvolutionType.power:
        abilities.add('Strength Amplification');
        abilities.add('Endurance Enhancement');
        break;
      case EvolutionType.efficiency:
        abilities.add('Time Optimization');
        abilities.add('Resource Management');
        break;
      case EvolutionType.wisdom:
        abilities.add('Knowledge Synthesis');
        abilities.add('Insight Generation');
        break;
      case EvolutionType.creativity:
        abilities.add('Creative Flow State');
        abilities.add('Inspiration Generation');
        break;
      case EvolutionType.resilience:
        abilities.add('Stress Resistance');
        abilities.add('Recovery Acceleration');
        break;
      case EvolutionType.adaptability:
        abilities.add('Flexible Adaptation');
        abilities.add('Change Integration');
        break;
      case EvolutionType.influence:
        abilities.add('Leadership Aura');
        abilities.add('Inspiration Power');
        break;
      case EvolutionType.transformation:
        abilities.add('Rapid Evolution');
        abilities.add('Form Shifting');
        break;
    }
    
    return abilities;
  }

  bool get canEvolve => evolutionProgress >= 100.0;
  bool get isMaxStage => currentStage == EvolutionStage.divine;

  Color getEvolutionStageColor() {
    switch (currentStage) {
      case EvolutionStage.basic:
        return Colors.grey;
      case EvolutionStage.improved:
        return Colors.green;
      case EvolutionStage.advanced:
        return Colors.blue;
      case EvolutionStage.expert:
        return Colors.indigo;
      case EvolutionStage.master:
        return Colors.purple;
      case EvolutionStage.legendary:
        return Colors.amber;
      case EvolutionStage.transcendent:
        return Colors.deepPurple;
      case EvolutionStage.divine:
        return Colors.amber;
    }
  }

  String getEvolutionStageText() {
    switch (currentStage) {
      case EvolutionStage.basic:
        return 'Basic';
      case EvolutionStage.improved:
        return 'Improved';
      case EvolutionStage.advanced:
        return 'Advanced';
      case EvolutionStage.expert:
        return 'Expert';
      case EvolutionStage.master:
        return 'Master';
      case EvolutionStage.legendary:
        return 'Legendary';
      case EvolutionStage.transcendent:
        return 'Transcendent';
      case EvolutionStage.divine:
        return 'Divine';
    }
  }

  Color getEvolutionTypeColor() {
    switch (type) {
      case EvolutionType.power:
        return Colors.red;
      case EvolutionType.efficiency:
        return Colors.orange;
      case EvolutionType.wisdom:
        return Colors.blue;
      case EvolutionType.creativity:
        return Colors.purple;
      case EvolutionType.resilience:
        return Colors.green;
      case EvolutionType.adaptability:
        return Colors.teal;
      case EvolutionType.influence:
        return Colors.pink;
      case EvolutionType.transformation:
        return Colors.indigo;
    }
  }

  IconData getEvolutionTypeIcon() {
    switch (type) {
      case EvolutionType.power:
        return Icons.flash_on;
      case EvolutionType.efficiency:
        return Icons.speed;
      case EvolutionType.wisdom:
        return Icons.psychology;
      case EvolutionType.creativity:
        return Icons.auto_awesome;
      case EvolutionType.resilience:
        return Icons.shield;
      case EvolutionType.adaptability:
        return Icons.transform;
      case EvolutionType.influence:
        return Icons.people;
      case EvolutionType.transformation:
        return Icons.change_circle;
    }
  }

  HabitEvolution evolve() {
    if (!canEvolve || isMaxStage) return this;
    
    final newStage = nextStage;
    final newNextStage = _getNextStage(newStage);
    final newAbilities = _getStageAbilities(newStage, type);
    final newBenefits = _getStageBenefits(newStage, type);
    final newRequirements = _getStageRequirements(newNextStage, type);
    
    final newHistory = List<String>.from(evolutionHistory);
    newHistory.add('${habitTitle} evolved to ${newStage.name} stage!');
    
    return copyWith(
      currentStage: newStage,
      nextStage: newNextStage,
      unlockedAbilities: newAbilities,
      benefits: newBenefits,
      requirements: newRequirements,
      evolutionHistory: newHistory,
      lastEvolved: DateTime.now(),
      lastUpdated: DateTime.now(),
      evolutionCount: evolutionCount + 1,
      evolutionProgress: 0.0,
    );
  }

  HabitEvolution updateProgress(double progress) {
    return copyWith(
      evolutionProgress: progress.clamp(0.0, 100.0),
      lastUpdated: DateTime.now(),
    );
  }

  String getEvolutionDescription() {
    switch (currentStage) {
      case EvolutionStage.basic:
        return 'A basic habit with potential for growth';
      case EvolutionStage.improved:
        return 'An improved habit showing consistent progress';
      case EvolutionStage.advanced:
        return 'An advanced habit with sophisticated techniques';
      case EvolutionStage.expert:
        return 'An expert habit demonstrating mastery';
      case EvolutionStage.master:
        return 'A master habit with legendary capabilities';
      case EvolutionStage.legendary:
        return 'A legendary habit that defies normal limits';
      case EvolutionStage.transcendent:
        return 'A transcendent habit beyond mortal understanding';
      case EvolutionStage.divine:
        return 'A divine habit with godlike powers';
    }
  }

  String getNextStageDescription() {
    if (isMaxStage) return 'Maximum evolution achieved!';
    
    switch (nextStage) {
      case EvolutionStage.improved:
        return 'Ready to improve and enhance capabilities';
      case EvolutionStage.advanced:
        return 'Ready to advance to expert techniques';
      case EvolutionStage.expert:
        return 'Ready to achieve expert mastery';
      case EvolutionStage.master:
        return 'Ready to become a master';
      case EvolutionStage.legendary:
        return 'Ready to achieve legendary status';
      case EvolutionStage.transcendent:
        return 'Ready to transcend mortal limits';
      case EvolutionStage.divine:
        return 'Ready to achieve divine status';
      default:
        return 'Unknown evolution stage';
    }
  }
}

class EvolutionManager {
  static final Map<EvolutionType, String> _evolutionPaths = {
    EvolutionType.power: 'Path of Strength',
    EvolutionType.efficiency: 'Path of Optimization',
    EvolutionType.wisdom: 'Path of Knowledge',
    EvolutionType.creativity: 'Path of Inspiration',
    EvolutionType.resilience: 'Path of Endurance',
    EvolutionType.adaptability: 'Path of Flexibility',
    EvolutionType.influence: 'Path of Leadership',
    EvolutionType.transformation: 'Path of Change',
  };

  static String getEvolutionPathName(EvolutionType type) {
    return _evolutionPaths[type] ?? 'Unknown Path';
  }

  static List<EvolutionType> getEvolutionTypes() {
    return EvolutionType.values.toList();
  }

  static List<EvolutionStage> getEvolutionStages() {
    return EvolutionStage.values.toList();
  }

  static double calculateEvolutionProgress(Habit habit, HabitEvolution evolution) {
    double progress = 0.0;
    
    // Streak progress
    final streakRequirement = evolution.requirements['streak'] ?? 0;
    if (streakRequirement > 0) {
      final streakProgress = (habit.currentStreak / streakRequirement) * 100;
      progress += streakProgress * 0.4; // 40% weight
    }
    
    // Completion progress
    final completionRequirement = evolution.requirements['completions'] ?? 0;
    if (completionRequirement > 0) {
      final completionProgress = (habit.totalCompletions / completionRequirement) * 100;
      progress += completionProgress * 0.3; // 30% weight
    }
    
    // Consistency progress
    final consistencyRequirement = evolution.requirements['consistency'] ?? 0;
    if (consistencyRequirement > 0) {
      final consistency = habit.getConsistencyRate();
      final consistencyProgress = (consistency / consistencyRequirement) * 100;
      progress += consistencyProgress * 0.3; // 30% weight
    }
    
    return progress.clamp(0.0, 100.0);
  }

  static String generateEvolutionMotivationalMessage(HabitEvolution evolution) {
    if (evolution.isMaxStage) {
      return 'You\'ve achieved divine status! Your habit is truly legendary! 🌟';
    }
    
    if (evolution.canEvolve) {
      return 'Ready to evolve! Your habit is about to reach new heights! 🚀';
    }
    
    final progress = evolution.evolutionProgress;
    if (progress >= 80) {
      return 'Almost there! Your habit is on the verge of evolution! ⚡';
    } else if (progress >= 60) {
      return 'Great progress! Your habit is building evolution momentum! 💪';
    } else if (progress >= 40) {
      return 'Steady progress! Your habit is developing evolution potential! 🌱';
    } else if (progress >= 20) {
      return 'Building foundation! Your habit is starting its evolution journey! 🔨';
    } else {
      return 'Beginning the journey! Every step brings you closer to evolution! 🚶‍♂️';
    }
  }

  static List<String> getEvolutionTips(EvolutionType type) {
    switch (type) {
      case EvolutionType.power:
        return [
          'Focus on building consistent strength',
          'Push your limits gradually',
          'Maintain proper form and technique',
          'Build endurance alongside power',
        ];
      case EvolutionType.efficiency:
        return [
          'Optimize your routine and process',
          'Eliminate time-wasting activities',
          'Use technology and tools effectively',
          'Streamline your workflow',
        ];
      case EvolutionType.wisdom:
        return [
          'Learn from every experience',
          'Seek knowledge continuously',
          'Apply what you learn',
          'Share wisdom with others',
        ];
      case EvolutionType.creativity:
        return [
          'Embrace experimentation',
          'Find inspiration everywhere',
          'Break free from conventional thinking',
          'Express yourself authentically',
        ];
      case EvolutionType.resilience:
        return [
          'Build mental and physical toughness',
          'Learn to recover quickly',
          'Develop stress management skills',
          'Stay committed through challenges',
        ];
      case EvolutionType.adaptability:
        return [
          'Embrace change and uncertainty',
          'Learn new skills quickly',
          'Adjust your approach as needed',
          'Stay flexible in your thinking',
        ];
      case EvolutionType.influence:
        return [
          'Lead by example',
          'Inspire others through action',
          'Build meaningful relationships',
          'Share your positive impact',
        ];
      case EvolutionType.transformation:
        return [
          'Embrace radical change',
          'Let go of limiting beliefs',
          'Transform your entire being',
          'Become who you were meant to be',
        ];
    }
  }
}
