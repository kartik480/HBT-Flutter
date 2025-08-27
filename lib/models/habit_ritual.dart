import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum RitualType {
  morning,
  evening,
  midday,
  transition,
  preparation,
  reflection,
  celebration,
  recovery,
}

enum RitualIntensity {
  gentle,
  moderate,
  energizing,
  intense,
  transformative,
}

enum RitualStatus {
  inactive,
  active,
  completed,
  missed,
  paused,
}

class HabitRitual {
  final String id;
  final String name;
  final String description;
  final RitualType type;
  final RitualIntensity intensity;
  final RitualStatus status;
  final List<String> habitIds;
  final List<Habit> habits;
  final int estimatedDuration; // in minutes
  final String preferredTime;
  final List<String> prerequisites;
  final List<String> benefits;
  final List<String> tips;
  final Map<String, dynamic> ritualSteps;
  final DateTime createdAt;
  final DateTime? lastCompleted;
  final DateTime lastUpdated;
  final int completionCount;
  final int streakCount;
  final double successRate;
  final Map<String, dynamic> metadata;

  HabitRitual({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.intensity,
    required this.status,
    required this.habitIds,
    required this.habits,
    required this.estimatedDuration,
    required this.preferredTime,
    required this.prerequisites,
    required this.benefits,
    required this.tips,
    required this.ritualSteps,
    required this.createdAt,
    this.lastCompleted,
    required this.lastUpdated,
    required this.completionCount,
    required this.streakCount,
    required this.successRate,
    required this.metadata,
  });

  HabitRitual copyWith({
    String? id,
    String? name,
    String? description,
    RitualType? type,
    RitualIntensity? intensity,
    RitualStatus? status,
    List<String>? habitIds,
    List<Habit>? habits,
    int? estimatedDuration,
    String? preferredTime,
    List<String>? prerequisites,
    List<String>? benefits,
    List<String>? tips,
    Map<String, dynamic>? ritualSteps,
    DateTime? createdAt,
    DateTime? lastCompleted,
    DateTime? lastUpdated,
    int? completionCount,
    int? streakCount,
    double? successRate,
    Map<String, dynamic>? metadata,
  }) {
    return HabitRitual(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      status: status ?? this.status,
      habitIds: habitIds ?? this.habitIds,
      habits: habits ?? this.habits,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      preferredTime: preferredTime ?? this.preferredTime,
      prerequisites: prerequisites ?? this.prerequisites,
      benefits: benefits ?? this.benefits,
      tips: tips ?? this.tips,
      ritualSteps: ritualSteps ?? this.ritualSteps,
      createdAt: createdAt ?? this.createdAt,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      completionCount: completionCount ?? this.completionCount,
      streakCount: streakCount ?? this.streakCount,
      successRate: successRate ?? this.successRate,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'intensity': intensity.index,
      'status': status.index,
      'habitIds': habitIds,
      'estimatedDuration': estimatedDuration,
      'preferredTime': preferredTime,
      'prerequisites': prerequisites,
      'benefits': benefits,
      'tips': tips,
      'ritualSteps': ritualSteps,
      'createdAt': createdAt.toIso8601String(),
      'lastCompleted': lastCompleted?.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'completionCount': completionCount,
      'streakCount': streakCount,
      'successRate': successRate,
      'metadata': metadata,
    };
  }

  factory HabitRitual.fromJson(Map<String, dynamic> json) {
    return HabitRitual(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: RitualType.values[json['type']],
      intensity: RitualIntensity.values[json['intensity']],
      status: RitualStatus.values[json['status']],
      habitIds: List<String>.from(json['habitIds']),
      habits: [], // Will be populated separately
      estimatedDuration: json['estimatedDuration'],
      preferredTime: json['preferredTime'],
      prerequisites: List<String>.from(json['prerequisites']),
      benefits: List<String>.from(json['benefits']),
      tips: List<String>.from(json['tips']),
      ritualSteps: Map<String, dynamic>.from(json['ritualSteps']),
      createdAt: DateTime.parse(json['createdAt']),
      lastCompleted: json['lastCompleted'] != null ? DateTime.parse(json['lastCompleted']) : null,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      completionCount: json['completionCount'],
      streakCount: json['streakCount'],
      successRate: json['successRate'].toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  factory HabitRitual.create({
    required String name,
    required String description,
    required RitualType type,
    required RitualIntensity intensity,
    required List<Habit> habits,
    required int estimatedDuration,
    required String preferredTime,
  }) {
    final habitIds = habits.map((h) => h.id).toList();
    final ritualSteps = _generateRitualSteps(habits, type, intensity);
    final benefits = _generateBenefits(type, intensity);
    final tips = _generateTips(type, intensity);
    final prerequisites = _generatePrerequisites(type, intensity);
    
    return HabitRitual(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      type: type,
      intensity: intensity,
      status: RitualStatus.inactive,
      habitIds: habitIds,
      habits: habits,
      estimatedDuration: estimatedDuration,
      preferredTime: preferredTime,
      prerequisites: prerequisites,
      benefits: benefits,
      tips: tips,
      ritualSteps: ritualSteps,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      completionCount: 0,
      streakCount: 0,
      successRate: 0.0,
      metadata: {
        'ritual_theme': _getRitualTheme(type),
        'difficulty': _getDifficultyLevel(intensity),
        'category': type.name,
        'habit_categories': habits.map((h) => h.category.name).toList(),
      },
    );
  }

  static Map<String, dynamic> _generateRitualSteps(List<Habit> habits, RitualType type, RitualIntensity intensity) {
    final steps = <String, dynamic>{};
    
    // Add preparation step
    steps['preparation'] = {
      'title': 'Prepare Your Space',
      'description': 'Create the perfect environment for your ritual',
      'duration': 2,
      'tips': ['Clear distractions', 'Set the mood', 'Gather any needed items'],
    };
    
    // Add habit-specific steps
    for (int i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final stepNumber = i + 1;
      
      steps['step_$stepNumber'] = {
        'title': habit.title,
        'description': 'Complete: ${habit.description}',
        'duration': _estimateHabitDuration(habit, intensity),
        'category': habit.category.name,
        'tips': _getHabitTips(habit, type),
      };
    }
    
    // Add transition steps between habits
    for (int i = 0; i < habits.length - 1; i++) {
      final transitionNumber = i + 1;
      steps['transition_$transitionNumber'] = {
        'title': 'Mindful Transition',
        'description': 'Take a moment to transition mindfully to the next habit',
        'duration': 1,
        'tips': ['Take 3 deep breaths', 'Acknowledge your progress', 'Set intention for next step'],
      };
    }
    
    // Add completion step
    steps['completion'] = {
      'title': 'Ritual Completion',
      'description': 'Celebrate completing your ritual and set intentions for the day',
      'duration': 3,
      'tips': ['Express gratitude', 'Set positive intentions', 'Acknowledge your achievement'],
    };
    
    return steps;
  }

  static int _estimateHabitDuration(Habit habit, RitualIntensity intensity) {
    int baseDuration = 5; // Base 5 minutes
    
    // Adjust based on habit category
    switch (habit.category) {
      case HabitCategory.health:
        baseDuration = 3;
        break;
      case HabitCategory.fitness:
        baseDuration = 8;
        break;
      case HabitCategory.learning:
        baseDuration = 10;
        break;
      case HabitCategory.productivity:
        baseDuration = 6;
        break;
      case HabitCategory.mindfulness:
        baseDuration = 7;
        break;
      case HabitCategory.social:
        baseDuration = 5;
        break;
      case HabitCategory.finance:
        baseDuration = 4;
        break;
      case HabitCategory.creativity:
        baseDuration = 12;
        break;
      case HabitCategory.other:
        baseDuration = 5;
        break;
    }
    
    // Adjust based on intensity
    switch (intensity) {
      case RitualIntensity.gentle:
        baseDuration = (baseDuration * 0.8).round();
        break;
      case RitualIntensity.moderate:
        baseDuration = baseDuration;
        break;
      case RitualIntensity.energizing:
        baseDuration = (baseDuration * 1.2).round();
        break;
      case RitualIntensity.intense:
        baseDuration = (baseDuration * 1.5).round();
        break;
      case RitualIntensity.transformative:
        baseDuration = (baseDuration * 2.0).round();
        break;
    }
    
    return baseDuration;
  }

  static List<String> _getHabitTips(Habit habit, RitualType type) {
    final tips = <String>[];
    
    // Add category-specific tips
    switch (habit.category) {
      case HabitCategory.health:
        tips.add('Focus on your breathing');
        tips.add('Feel the energy flowing through you');
        break;
      case HabitCategory.fitness:
        tips.add('Maintain proper form');
        tips.add('Listen to your body');
        break;
      case HabitCategory.learning:
        tips.add('Stay curious and open-minded');
        tips.add('Connect new knowledge to existing understanding');
        break;
      case HabitCategory.productivity:
        tips.add('Stay focused on one task at a time');
        tips.add('Eliminate distractions');
        break;
      case HabitCategory.mindfulness:
        tips.add('Be present in the moment');
        tips.add('Observe without judgment');
        break;
      case HabitCategory.social:
        tips.add('Connect authentically');
        tips.add('Listen actively');
        break;
      case HabitCategory.finance:
        tips.add('Think long-term');
        tips.add('Make informed decisions');
        break;
      case HabitCategory.creativity:
        tips.add('Let go of perfectionism');
        tips.add('Embrace experimentation');
        break;
      case HabitCategory.other:
        tips.add('Stay committed to your goal');
        tips.add('Find joy in the process');
        break;
    }
    
    // Add ritual-type-specific tips
    switch (type) {
      case RitualType.morning:
        tips.add('Start your day with intention');
        tips.add('Build momentum for the day ahead');
        break;
      case RitualType.evening:
        tips.add('Wind down mindfully');
        tips.add('Prepare for restful sleep');
        break;
      case RitualType.midday:
        tips.add('Recharge your energy');
        tips.add('Maintain focus and clarity');
        break;
      case RitualType.transition:
        tips.add('Embrace the change');
        tips.add('Find balance in transition');
        break;
      case RitualType.preparation:
        tips.add('Set yourself up for success');
        tips.add('Create optimal conditions');
        break;
      case RitualType.reflection:
        tips.add('Look inward with honesty');
        tips.add('Learn from your experiences');
        break;
      case RitualType.celebration:
        tips.add('Acknowledge your achievements');
        tips.add('Express gratitude and joy');
        break;
      case RitualType.recovery:
        tips.add('Be gentle with yourself');
        tips.add('Allow healing to happen');
        break;
    }
    
    return tips;
  }

  static List<String> _generateBenefits(RitualType type, RitualIntensity intensity) {
    final benefits = <String>[];
    
    // Add type-specific benefits
    switch (type) {
      case RitualType.morning:
        benefits.add('Increased energy and focus');
        benefits.add('Better mood throughout the day');
        benefits.add('Improved productivity');
        benefits.add('Stronger willpower');
        break;
      case RitualType.evening:
        benefits.add('Better sleep quality');
        benefits.add('Reduced stress and anxiety');
        benefits.add('Improved relaxation');
        benefits.add('Better next-day preparation');
        break;
      case RitualType.midday:
        benefits.add('Sustained energy levels');
        benefits.add('Improved focus and clarity');
        benefits.add('Better stress management');
        benefits.add('Enhanced creativity');
        break;
      case RitualType.transition:
        benefits.add('Smoother life transitions');
        benefits.add('Better adaptability');
        benefits.add('Reduced resistance to change');
        benefits.add('Improved flow state');
        break;
      case RitualType.preparation:
        benefits.add('Better performance outcomes');
        benefits.add('Reduced anxiety');
        benefits.add('Increased confidence');
        benefits.add('Optimal mental state');
        break;
      case RitualType.reflection:
        benefits.add('Greater self-awareness');
        benefits.add('Better decision making');
        benefits.add('Personal growth acceleration');
        benefits.add('Improved relationships');
        break;
      case RitualType.celebration:
        benefits.add('Increased motivation');
        benefits.add('Better self-esteem');
        benefits.add('Positive mindset reinforcement');
        benefits.add('Joy and fulfillment');
        break;
      case RitualType.recovery:
        benefits.add('Faster healing');
        benefits.add('Better stress recovery');
        benefits.add('Improved resilience');
        benefits.add('Restored energy levels');
        break;
    }
    
    // Add intensity-specific benefits
    switch (intensity) {
      case RitualIntensity.gentle:
        benefits.add('Gentle introduction to new habits');
        benefits.add('Sustainable long-term practice');
        break;
      case RitualIntensity.moderate:
        benefits.add('Balanced challenge and comfort');
        benefits.add('Steady progress and growth');
        break;
      case RitualIntensity.energizing:
        benefits.add('Increased vitality and enthusiasm');
        benefits.add('Enhanced motivation and drive');
        break;
      case RitualIntensity.intense:
        benefits.add('Rapid skill development');
        benefits.add('Maximum growth potential');
        break;
      case RitualIntensity.transformative:
        benefits.add('Life-changing transformations');
        benefits.add('Breakthrough personal development');
        break;
    }
    
    return benefits;
  }

  static List<String> _generateTips(RitualType type, RitualIntensity intensity) {
    final tips = <String>[];
    
    // Add general ritual tips
    tips.add('Start with a clear intention');
    tips.add('Create a dedicated ritual space');
    tips.add('Eliminate distractions');
    tips.add('Practice consistently');
    tips.add('Listen to your body and mind');
    
    // Add type-specific tips
    switch (type) {
      case RitualType.morning:
        tips.add('Prepare the night before');
        tips.add('Start with gentle movements');
        tips.add('Set positive intentions for the day');
        break;
      case RitualType.evening:
        tips.add('Begin winding down early');
        tips.add('Avoid stimulating activities');
        tips.add('Create a peaceful atmosphere');
        break;
      case RitualType.midday:
        tips.add('Find a quiet space');
        tips.add('Take a short break from work');
        tips.add('Reconnect with your goals');
        break;
      case RitualType.transition:
        tips.add('Acknowledge the change');
        tips.add('Take time to adjust');
        tips.add('Be patient with yourself');
        break;
      case RitualType.preparation:
        tips.add('Plan ahead thoroughly');
        tips.add('Gather all necessary resources');
        tips.add('Create optimal conditions');
        break;
      case RitualType.reflection:
        tips.add('Be honest with yourself');
        tips.add('Write down your thoughts');
        tips.add('Look for patterns and insights');
        break;
      case RitualType.celebration:
        tips.add('Express genuine gratitude');
        tips.add('Share your joy with others');
        tips.add('Acknowledge your hard work');
        break;
      case RitualType.recovery:
        tips.add('Be gentle and patient');
        tips.add('Allow natural healing');
        tips.add('Seek support when needed');
        break;
    }
    
    // Add intensity-specific tips
    switch (intensity) {
      case RitualIntensity.gentle:
        tips.add('Start slowly and build gradually');
        tips.add('Focus on consistency over intensity');
        break;
      case RitualIntensity.moderate:
        tips.add('Find your optimal challenge level');
        tips.add('Balance effort with recovery');
        break;
      case RitualIntensity.energizing:
        tips.add('Channel your energy mindfully');
        tips.add('Use momentum to your advantage');
        break;
      case RitualIntensity.intense:
        tips.add('Push your limits safely');
        tips.add('Ensure adequate recovery time');
        break;
      case RitualIntensity.transformative:
        tips.add('Embrace the transformation process');
        tips.add('Trust in your ability to change');
        break;
    }
    
    return tips;
  }

  static List<String> _generatePrerequisites(RitualType type, RitualIntensity intensity) {
    final prerequisites = <String>[];
    
    // Add general prerequisites
    prerequisites.add('Dedicated time and space');
    prerequisites.add('Commitment to consistency');
    prerequisites.add('Open mind and heart');
    
    // Add type-specific prerequisites
    switch (type) {
      case RitualType.morning:
        prerequisites.add('Early wake-up time');
        prerequisites.add('Quiet morning environment');
        break;
      case RitualType.evening:
        prerequisites.add('Evening free time');
        prerequisites.add('Peaceful atmosphere');
        break;
      case RitualType.midday:
        prerequisites.add('Break time availability');
        prerequisites.add('Private or quiet space');
        break;
      case RitualType.transition:
        prerequisites.add('Awareness of transitions');
        prerequisites.add('Flexibility in schedule');
        break;
      case RitualType.preparation:
        prerequisites.add('Clear goals and objectives');
        prerequisites.add('Necessary resources');
        break;
      case RitualType.reflection:
        prerequisites.add('Honest self-assessment');
        prerequisites.add('Time for deep thinking');
        break;
      case RitualType.celebration:
        prerequisites.add('Achievements to celebrate');
        prerequisites.add('Positive mindset');
        break;
      case RitualType.recovery:
        prerequisites.add('Recovery time available');
        prerequisites.add('Gentle approach');
        break;
    }
    
    // Add intensity-specific prerequisites
    switch (intensity) {
      case RitualIntensity.gentle:
        prerequisites.add('Basic habit foundation');
        prerequisites.add('Gentle approach mindset');
        break;
      case RitualIntensity.moderate:
        prerequisites.add('Some habit experience');
        prerequisites.add('Moderate challenge tolerance');
        break;
      case RitualIntensity.energizing:
        prerequisites.add('Good energy levels');
        prerequisites.add('Enthusiasm for growth');
        break;
      case RitualIntensity.intense:
        prerequisites.add('Strong habit foundation');
        prerequisites.add('High energy and motivation');
        break;
      case RitualIntensity.transformative:
        prerequisites.add('Deep commitment to change');
        prerequisites.add('Support system in place');
        break;
    }
    
    return prerequisites;
  }

  static String _getRitualTheme(RitualType type) {
    switch (type) {
      case RitualType.morning:
        return 'Dawn Awakening';
      case RitualType.evening:
        return 'Twilight Serenity';
      case RitualType.midday:
        return 'Solar Recharge';
      case RitualType.transition:
        return 'Flow Transformation';
      case RitualType.preparation:
        return 'Foundation Building';
      case RitualType.reflection:
        return 'Inner Wisdom';
      case RitualType.celebration:
        return 'Joy Amplification';
      case RitualType.recovery:
        return 'Healing Restoration';
    }
  }

  static String _getDifficultyLevel(RitualIntensity intensity) {
    switch (intensity) {
      case RitualIntensity.gentle:
        return 'Beginner';
      case RitualIntensity.moderate:
        return 'Intermediate';
      case RitualIntensity.energizing:
        return 'Advanced';
      case RitualIntensity.intense:
        return 'Expert';
      case RitualIntensity.transformative:
        return 'Master';
    }
  }

  bool get isActive => status == RitualStatus.active;
  bool get isCompleted => status == RitualStatus.completed;
  bool get isMissed => status == RitualStatus.missed;
  bool get isPaused => status == RitualStatus.paused;

  Color getRitualTypeColor() {
    switch (type) {
      case RitualType.morning:
        return Colors.orange;
      case RitualType.evening:
        return Colors.indigo;
      case RitualType.midday:
        return Colors.yellow;
      case RitualType.transition:
        return Colors.teal;
      case RitualType.preparation:
        return Colors.blue;
      case RitualType.reflection:
        return Colors.purple;
      case RitualType.celebration:
        return Colors.pink;
      case RitualType.recovery:
        return Colors.green;
    }
  }

  IconData getRitualTypeIcon() {
    switch (type) {
      case RitualType.morning:
        return Icons.wb_sunny;
      case RitualType.evening:
        return Icons.nightlight;
      case RitualType.midday:
        return Icons.wb_sunny_outlined;
      case RitualType.transition:
        return Icons.transform;
      case RitualType.preparation:
        return Icons.build;
      case RitualType.reflection:
        return Icons.psychology;
      case RitualType.celebration:
        return Icons.celebration;
      case RitualType.recovery:
        return Icons.healing;
    }
  }

  Color getRitualIntensityColor() {
    switch (intensity) {
      case RitualIntensity.gentle:
        return Colors.lightGreen;
      case RitualIntensity.moderate:
        return Colors.green;
      case RitualIntensity.energizing:
        return Colors.orange;
      case RitualIntensity.intense:
        return Colors.red;
      case RitualIntensity.transformative:
        return Colors.purple;
    }
  }

  String getRitualIntensityText() {
    switch (intensity) {
      case RitualIntensity.gentle:
        return 'Gentle';
      case RitualIntensity.moderate:
        return 'Moderate';
      case RitualIntensity.energizing:
        return 'Energizing';
      case RitualIntensity.intense:
        return 'Intense';
      case RitualIntensity.transformative:
        return 'Transformative';
    }
  }

  HabitRitual activate() {
    return copyWith(
      status: RitualStatus.active,
      lastUpdated: DateTime.now(),
    );
  }

  HabitRitual complete() {
    final newStreakCount = streakCount + 1;
    final newCompletionCount = completionCount + 1;
    final newSuccessRate = (newCompletionCount / (newCompletionCount + 1)) * 100;
    
    return copyWith(
      status: RitualStatus.completed,
      lastCompleted: DateTime.now(),
      lastUpdated: DateTime.now(),
      completionCount: newCompletionCount,
      streakCount: newStreakCount,
      successRate: newSuccessRate,
    );
  }

  HabitRitual miss() {
    return copyWith(
      status: RitualStatus.missed,
      lastUpdated: DateTime.now(),
      streakCount: 0,
    );
  }

  HabitRitual pause() {
    return copyWith(
      status: RitualStatus.paused,
      lastUpdated: DateTime.now(),
    );
  }

  String getRitualStatusDescription() {
    switch (status) {
      case RitualStatus.inactive:
        return 'Ritual not yet started';
      case RitualStatus.active:
        return 'Ritual in progress';
      case RitualStatus.completed:
        return 'Ritual completed successfully';
      case RitualStatus.missed:
        return 'Ritual was missed';
      case RitualStatus.paused:
        return 'Ritual temporarily paused';
    }
  }

  String getRitualTypeDescription() {
    switch (type) {
      case RitualType.morning:
        return 'Morning Ritual - Start your day with purpose';
      case RitualType.evening:
        return 'Evening Ritual - Wind down mindfully';
      case RitualType.midday:
        return 'Midday Ritual - Recharge and refocus';
      case RitualType.transition:
        return 'Transition Ritual - Navigate change gracefully';
      case RitualType.preparation:
        return 'Preparation Ritual - Set yourself up for success';
      case RitualType.reflection:
        return 'Reflection Ritual - Gain insights and wisdom';
      case RitualType.celebration:
        return 'Celebration Ritual - Honor your achievements';
      case RitualType.recovery:
        return 'Recovery Ritual - Restore and heal';
    }
  }

  String getEstimatedDurationText() {
    if (estimatedDuration < 60) {
      return '${estimatedDuration} minutes';
    } else {
      final hours = estimatedDuration ~/ 60;
      final minutes = estimatedDuration % 60;
      if (minutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minutes';
      }
    }
  }

  bool get canStart {
    if (isActive || isCompleted) return false;
    
    // Check if it's the right time for the ritual
    final now = DateTime.now();
    final hour = now.hour;
    
    switch (type) {
      case RitualType.morning:
        return hour >= 5 && hour <= 10;
      case RitualType.evening:
        return hour >= 18 && hour <= 23;
      case RitualType.midday:
        return hour >= 11 && hour <= 15;
      case RitualType.transition:
        return true; // Can be done anytime
      case RitualType.preparation:
        return true; // Can be done anytime
      case RitualType.reflection:
        return hour >= 20 || hour <= 6; // Evening or early morning
      case RitualType.celebration:
        return true; // Can be done anytime
      case RitualType.recovery:
        return true; // Can be done anytime
    }
  }

  String getOptimalTimeDescription() {
    switch (type) {
      case RitualType.morning:
        return 'Best done between 5:00 AM - 10:00 AM';
      case RitualType.evening:
        return 'Best done between 6:00 PM - 11:00 PM';
      case RitualType.midday:
        return 'Best done between 11:00 AM - 3:00 PM';
      case RitualType.transition:
        return 'Can be done anytime during transitions';
      case RitualType.preparation:
        return 'Can be done before important events';
      case RitualType.reflection:
        return 'Best done in the evening or early morning';
      case RitualType.celebration:
        return 'Can be done anytime to celebrate achievements';
      case RitualType.recovery:
        return 'Can be done anytime you need restoration';
    }
  }
}

class RitualManager {
  static final Map<RitualType, String> _ritualThemes = {
    RitualType.morning: 'Dawn Awakening',
    RitualType.evening: 'Twilight Serenity',
    RitualType.midday: 'Solar Recharge',
    RitualType.transition: 'Flow Transformation',
    RitualType.preparation: 'Foundation Building',
    RitualType.reflection: 'Inner Wisdom',
    RitualType.celebration: 'Joy Amplification',
    RitualType.recovery: 'Healing Restoration',
  };

  static String getRitualTheme(RitualType type) {
    return _ritualThemes[type] ?? 'Unknown Theme';
  }

  static List<RitualType> getRitualTypes() {
    return RitualType.values.toList();
  }

  static List<RitualIntensity> getRitualIntensities() {
    return RitualIntensity.values.toList();
  }

  static List<HabitRitual> getActiveRituals(List<HabitRitual> userRituals) {
    return userRituals.where((ritual) => ritual.isActive).toList();
  }

  static List<HabitRitual> getCompletedRituals(List<HabitRitual> userRituals) {
    return userRituals.where((ritual) => ritual.isCompleted).toList();
  }

  static double calculateTotalRitualTime(List<HabitRitual> activeRituals) {
    return activeRituals.fold(0.0, (sum, ritual) => sum + ritual.estimatedDuration);
  }

  static String generateRitualMotivationalMessage(List<HabitRitual> activeRituals) {
    if (activeRituals.isEmpty) {
      return 'Create your first ritual to unlock powerful daily routines! 🌟';
    }
    
    final totalTime = calculateTotalRitualTime(activeRituals);
    final ritualCount = activeRituals.length;
    
    if (totalTime >= 120) {
      return 'You\'re a ritual master! Your daily routines are truly transformative! 🎭';
    } else if (totalTime >= 60) {
      return 'Amazing ritual power! Your daily practices are creating magic! ✨';
    } else if (ritualCount >= 3) {
      return 'Incredible ritual network! Your routines are amplifying each other! 🌊';
    } else if (ritualCount >= 2) {
      return 'Great ritual synergy! Your routines are working beautifully together! 🌈';
    } else {
      return 'Ritual activated! Your daily practice is becoming powerful! 💪';
    }
  }

  static List<String> getRitualCreationTips(RitualType type) {
    switch (type) {
      case RitualType.morning:
        return [
          'Start with gentle, energizing habits',
          'Include mindfulness or meditation',
          'Set positive intentions for the day',
          'Keep it under 30 minutes initially',
        ];
      case RitualType.evening:
        return [
          'Focus on calming and relaxing habits',
          'Include reflection or gratitude',
          'Avoid stimulating activities',
          'Create a peaceful atmosphere',
        ];
      case RitualType.midday:
        return [
          'Include energizing but not overwhelming habits',
          'Focus on recharging and refocusing',
          'Keep it short and impactful',
          'Find a quiet, private space',
        ];
      case RitualType.transition:
        return [
          'Include habits that help with change',
          'Focus on adaptability and flow',
          'Make it flexible and portable',
          'Include mindfulness practices',
        ];
      case RitualType.preparation:
        return [
          'Include habits that build confidence',
          'Focus on mental and physical readiness',
          'Make it specific to your goals',
          'Include visualization or affirmation',
        ];
      case RitualType.reflection:
        return [
          'Include journaling or meditation',
          'Focus on self-awareness and growth',
          'Create a quiet, contemplative space',
          'Include gratitude practices',
        ];
      case RitualType.celebration:
        return [
          'Include fun and enjoyable habits',
          'Focus on acknowledging achievements',
          'Make it social if desired',
          'Include gratitude and joy practices',
        ];
      case RitualType.recovery:
        return [
          'Include gentle, restorative habits',
          'Focus on healing and restoration',
          'Listen to your body\'s needs',
          'Include self-compassion practices',
        ];
    }
  }
}
