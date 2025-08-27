import 'package:flutter/material.dart';
import 'package:habit_tracker/models/avatar.dart';
import 'package:habit_tracker/models/habit.dart';

enum CoachPersonality {
  motivational,
  strict,
  funny,
  wise,
  supportive,
  challenging,
  playful,
  zen,
}

enum CoachMood {
  excited,
  determined,
  playful,
  serious,
  encouraging,
  challenging,
  proud,
  concerned,
}

class AICoach {
  final String id;
  final String name;
  final CoachPersonality personality;
  final CoachMood currentMood;
  final String currentMessage;
  final List<String> messageHistory;
  final DateTime lastInteraction;
  final int totalInteractions;
  final Map<String, int> personalityUsage;
  final bool isActive;

  AICoach({
    required this.id,
    required this.name,
    required this.personality,
    required this.currentMood,
    required this.currentMessage,
    required this.messageHistory,
    required this.lastInteraction,
    required this.totalInteractions,
    required this.personalityUsage,
    required this.isActive,
  });

  AICoach copyWith({
    String? id,
    String? name,
    CoachPersonality? personality,
    CoachMood? currentMood,
    String? currentMessage,
    List<String>? messageHistory,
    DateTime? lastInteraction,
    int? totalInteractions,
    Map<String, int>? personalityUsage,
    bool? isActive,
  }) {
    return AICoach(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      currentMood: currentMood ?? this.currentMood,
      currentMessage: currentMessage ?? this.currentMessage,
      messageHistory: messageHistory ?? this.messageHistory,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      personalityUsage: personalityUsage ?? this.personalityUsage,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'personality': personality.index,
      'currentMood': currentMood.index,
      'currentMessage': currentMessage,
      'messageHistory': messageHistory,
      'lastInteraction': lastInteraction.toIso8601String(),
      'totalInteractions': totalInteractions,
      'personalityUsage': personalityUsage,
      'isActive': isActive,
    };
  }

  factory AICoach.fromJson(Map<String, dynamic> json) {
    return AICoach(
      id: json['id'],
      name: json['name'],
      personality: CoachPersonality.values[json['personality']],
      currentMood: CoachMood.values[json['currentMood']],
      currentMessage: json['currentMessage'],
      messageHistory: List<String>.from(json['messageHistory']),
      lastInteraction: DateTime.parse(json['lastInteraction']),
      totalInteractions: json['totalInteractions'],
      personalityUsage: Map<String, int>.from(json['personalityUsage']),
      isActive: json['isActive'],
    );
  }

  factory AICoach.createDefault() {
    return AICoach(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Coach Max',
      personality: CoachPersonality.motivational,
      currentMood: CoachMood.excited,
      currentMessage: 'Ready to help you become your best self! 💪',
      messageHistory: ['Welcome to your habit journey!'],
      lastInteraction: DateTime.now(),
      totalInteractions: 0,
      personalityUsage: {
        'motivational': 1,
        'strict': 0,
        'funny': 0,
        'wise': 0,
        'supportive': 0,
        'challenging': 0,
        'playful': 0,
        'zen': 0,
      },
      isActive: true,
    );
  }

  String getPersonalityDescription() {
    switch (personality) {
      case CoachPersonality.motivational:
        return 'Energetic and inspiring, always pushing you to reach your potential';
      case CoachPersonality.strict:
        return 'No-nonsense and disciplined, keeping you accountable';
      case CoachPersonality.funny:
        return 'Witty and entertaining, making habit building fun';
      case CoachPersonality.wise:
        return 'Thoughtful and insightful, sharing wisdom and perspective';
      case CoachPersonality.supportive:
        return 'Gentle and encouraging, your biggest cheerleader';
      case CoachPersonality.challenging:
        return 'Pushes your limits and helps you grow stronger';
      case CoachPersonality.playful:
        return 'Light-hearted and fun, turning challenges into games';
      case CoachPersonality.zen:
        return 'Calm and centered, helping you find inner peace';
    }
  }

  IconData getPersonalityIcon() {
    switch (personality) {
      case CoachPersonality.motivational:
        return Icons.emoji_events;
      case CoachPersonality.strict:
        return Icons.gavel;
      case CoachPersonality.funny:
        return Icons.sentiment_satisfied;
      case CoachPersonality.wise:
        return Icons.psychology;
      case CoachPersonality.supportive:
        return Icons.favorite;
      case CoachPersonality.challenging:
        return Icons.trending_up;
      case CoachPersonality.playful:
        return Icons.sports_esports;
      case CoachPersonality.zen:
        return Icons.spa;
    }
  }

  Color getPersonalityColor() {
    switch (personality) {
      case CoachPersonality.motivational:
        return Colors.orange;
      case CoachPersonality.strict:
        return Colors.red;
      case CoachPersonality.funny:
        return Colors.yellow;
      case CoachPersonality.wise:
        return Colors.blue;
      case CoachPersonality.supportive:
        return Colors.pink;
      case CoachPersonality.challenging:
        return Colors.purple;
      case CoachPersonality.playful:
        return Colors.green;
      case CoachPersonality.zen:
        return Colors.teal;
    }
  }

  AICoach changePersonality(CoachPersonality newPersonality) {
    final newUsage = Map<String, int>.from(personalityUsage);
    newUsage[personality.name] = (newUsage[personality.name] ?? 0) + 1;
    
    return copyWith(
      personality: newPersonality,
      personalityUsage: newUsage,
      lastInteraction: DateTime.now(),
    );
  }

  AICoach updateMood(CoachMood newMood) {
    return copyWith(
      currentMood: newMood,
      lastInteraction: DateTime.now(),
    );
  }

  AICoach addMessage(String message) {
    final newHistory = [...messageHistory, message];
    if (newHistory.length > 50) {
      newHistory.removeAt(0);
    }
    
    return copyWith(
      currentMessage: message,
      messageHistory: newHistory,
      lastInteraction: DateTime.now(),
      totalInteractions: totalInteractions + 1,
    );
  }
}

class CoachMessageGenerator {
  static final Map<CoachPersonality, Map<CoachMood, List<String>>> _messages = {
    CoachPersonality.motivational: {
      CoachMood.excited: [
        '🔥 You\'re absolutely crushing it today!',
        '🚀 This is your moment to shine!',
        '💪 I can feel your energy from here!',
        '⭐ You\'re making magic happen!',
        '🎯 Nothing can stop you now!',
      ],
      CoachMood.determined: [
        'Let\'s turn those dreams into reality!',
        'Every step forward is a victory!',
        'Your future self is thanking you right now!',
        'This is where legends are made!',
        'You\'ve got the power within you!',
      ],
      CoachMood.encouraging: [
        'I believe in you, even when you don\'t!',
        'You\'re stronger than you think!',
        'Every expert was once a beginner!',
        'Your potential is limitless!',
        'You\'re building something amazing!',
      ],
    },
    
    CoachPersonality.strict: {
      CoachMood.serious: [
        'No excuses today. Get it done.',
        'Your goals don\'t care about your feelings.',
        'Discipline is choosing what you want most over what you want now.',
        'Stop talking about it. Start being about it.',
        'Your sofa is winning. Get up.',
      ],
      CoachMood.challenging: [
        'Are you going to let today beat you?',
        'Prove to yourself what you\'re capable of.',
        'Your comfort zone is killing your dreams.',
        'Stop making promises to yourself you don\'t keep.',
        'You\'re either getting better or getting worse.',
      ],
      CoachMood.determined: [
        'Focus. Execute. Dominate.',
        'Your habits are your future.',
        'Every choice matters. Choose wisely.',
        'Be the person your future self needs.',
        'Excellence is not an act, it\'s a habit.',
      ],
    },
    
    CoachPersonality.funny: {
      CoachMood.playful: [
        '🎭 Your habits are like a Netflix series - binge-worthy!',
        '🍕 Pizza is temporary, but good habits are forever!',
        '🦥 Are you a sloth or a cheetah today? Choose wisely!',
        '🎪 Welcome to the circus of self-improvement!',
        '🐌 Slow progress is still progress, my friend!',
      ],
      CoachMood.excited: [
        '🎉 Let\'s make today so awesome that yesterday gets jealous!',
        '🚀 You\'re not just building habits, you\'re building a legend!',
        '🎯 Your future self is like "Wow, past me was amazing!"',
        '🌟 You\'re basically a superhero in training!',
        '🎪 The habit circus is in town, and you\'re the star!',
      ],
      CoachMood.encouraging: [
        '💪 You\'re like a habit ninja - silent but deadly!',
        '🎭 Life is a stage, and you\'re the main character!',
        '🎪 Every day is a new episode of "The Amazing You"!',
        '🌟 You\'re not just improving, you\'re upgrading!',
        '🎯 Your habits are like a personal trainer that never sleeps!',
      ],
    },
    
    CoachPersonality.wise: {
      CoachMood.zen: [
        'In the garden of habits, patience is the water that makes dreams grow.',
        'Every morning is a new chapter in your story. What will you write today?',
        'The journey of a thousand miles begins with a single step, and continues with consistent steps.',
        'Your habits are the architects of your destiny.',
        'Wisdom comes from experience, and experience comes from consistent action.',
      ],
      CoachMood.encouraging: [
        'Remember, the oak tree was once a little nut that held its ground.',
        'Your potential is like a seed - it needs consistent care to bloom.',
        'Every habit you build is a brick in the foundation of your future.',
        'The best time to plant a tree was 20 years ago. The second best time is now.',
        'Your habits today are your character tomorrow.',
      ],
      CoachMood.determined: [
        'Focus on progress, not perfection. Every step forward is a victory.',
        'The difference between ordinary and extraordinary is that little extra.',
        'Your habits are your choices, and your choices shape your life.',
        'Success is not final, failure is not fatal: it is the courage to continue that counts.',
        'The only way to do great work is to love what you do.',
      ],
    },
    
    CoachPersonality.supportive: {
      CoachMood.encouraging: [
        'I\'m here for you every step of the way. You\'ve got this!',
        'Your progress, no matter how small, is worth celebrating.',
        'Remember to be kind to yourself today. You\'re doing great!',
        'Every effort you make is bringing you closer to your goals.',
        'You\'re not alone in this journey. I believe in you!',
      ],
      CoachMood.proud: [
        'Look at how far you\'ve come! I\'m so proud of you!',
        'You\'re showing incredible strength and determination.',
        'Your commitment to growth is inspiring.',
        'You\'re proving that change is possible, one day at a time.',
        'Your future self will thank you for today\'s efforts.',
      ],
      CoachMood.concerned: [
        'It\'s okay to have tough days. Tomorrow is a new opportunity.',
        'Remember, progress isn\'t always linear. Be patient with yourself.',
        'You\'re stronger than you think. This too shall pass.',
        'Every setback is a setup for a comeback.',
        'Take care of yourself today. You deserve it.',
      ],
    },
    
    CoachPersonality.challenging: {
      CoachMood.challenging: [
        'Are you ready to push beyond your limits today?',
        'Your comfort zone is expanding. Keep pushing!',
        'What would you attempt if you knew you couldn\'t fail?',
        'Your potential is greater than your current reality.',
        'Today is your chance to prove yourself wrong.',
      ],
      CoachMood.determined: [
        'Let\'s see what you\'re really made of today!',
        'Your goals are waiting. Are you going to meet them?',
        'Every challenge is an opportunity to grow stronger.',
        'You\'re capable of more than you think.',
        'Let\'s turn your "impossible" into "I\'m possible"!',
      ],
      CoachMood.excited: [
        'Ready to crush some goals today? Let\'s do this!',
        'Your future self is calling. Are you going to answer?',
        'Let\'s make today so productive that tomorrow gets jealous!',
        'You\'re building momentum. Keep it going!',
        'This is your time to shine!',
      ],
    },
    
    CoachPersonality.playful: {
      CoachMood.playful: [
        '🎮 Ready to level up your life today?',
        '🎪 Welcome to the habit carnival! What\'s your favorite ride?',
        '🎭 Life is a game, and you\'re the player. Choose your power-ups wisely!',
        '🎯 Your habits are like a video game - each level gets more exciting!',
        '🌟 You\'re not just living life, you\'re playing it on expert mode!',
      ],
      CoachMood.excited: [
        '🎉 Let\'s make today so fun that your calendar gets jealous!',
        '🚀 You\'re like a rocket ship of awesome!',
        '🎪 The habit party is starting, and you\'re the VIP!',
        '🎯 Every completed habit is a high score!',
        '🌟 You\'re basically a habit superhero!',
      ],
      CoachMood.encouraging: [
        '🎭 You\'re the director of your own success movie!',
        '🎪 Life is a circus, and you\'re the star performer!',
        '🎮 Your habits are your cheat codes to success!',
        '🌟 You\'re not just improving, you\'re evolving!',
        '🎯 Every day is a new level to conquer!',
      ],
    },
    
    CoachPersonality.zen: {
      CoachMood.zen: [
        'Breathe deeply. Your journey is unfolding perfectly.',
        'Find peace in the present moment. This is where growth happens.',
        'Your habits are like gentle waves, shaping the shore of your life.',
        'In stillness, you find your strength. In action, you find your purpose.',
        'Every step is a meditation. Every breath is an opportunity.',
      ],
      CoachMood.encouraging: [
        'Trust the process. Your growth is happening in perfect timing.',
        'Find balance in your actions. Harmony in your habits.',
        'Your journey is unique. Honor your own pace.',
        'In patience, you find wisdom. In consistency, you find success.',
        'Every moment is a new beginning. Every choice is a new path.',
      ],
      CoachMood.concerned: [
        'It\'s okay to rest. Growth happens in cycles.',
        'Find peace in imperfection. Progress is a gentle journey.',
        'Your worth is not measured by your productivity.',
        'In stillness, you find answers. In patience, you find peace.',
        'Every challenge is a teacher. Every setback is a lesson.',
      ],
    },
  };

  static String generateMessage(CoachPersonality personality, CoachMood mood, {
    String? userName,
    List<Habit>? completedHabits,
    List<Habit>? missedHabits,
    Avatar? avatar,
  }) {
    final messages = _messages[personality]?[mood] ?? _messages[CoachPersonality.motivational]![CoachMood.encouraging]!;
    final random = DateTime.now().millisecondsSinceEpoch;
    String baseMessage = messages[random % messages.length];
    
    // Personalize the message
    if (userName != null) {
      baseMessage = baseMessage.replaceAll('You\'re', '$userName, you\'re');
      baseMessage = baseMessage.replaceAll('You\'ve', '$userName, you\'ve');
    }
    
    // Add context-specific messages
    if (completedHabits != null && completedHabits.isNotEmpty) {
      if (personality == CoachPersonality.motivational) {
        baseMessage += ' You completed ${completedHabits.length} habits today - that\'s incredible! 🎉';
      } else if (personality == CoachPersonality.funny) {
        baseMessage += ' ${completedHabits.length} habits down, infinite possibilities to go! 🚀';
      } else if (personality == CoachPersonality.zen) {
        baseMessage += ' Your dedication is creating beautiful ripples in your life. 🌊';
      }
    }
    
    if (missedHabits != null && missedHabits.isNotEmpty) {
      if (personality == CoachPersonality.strict) {
        baseMessage += ' But you missed ${missedHabits.length} habits. Tomorrow is a new opportunity to do better.';
      } else if (personality == CoachPersonality.supportive) {
        baseMessage += ' It\'s okay to miss some habits. Tomorrow is a fresh start. 💙';
      } else if (personality == CoachPersonality.zen) {
        baseMessage += ' Every missed habit is a lesson in compassion for yourself. 🌸';
      }
    }
    
    if (avatar != null) {
      if (avatar.state == AvatarState.enlightened) {
        baseMessage += ' You\'re reaching legendary status! 🌟';
      } else if (avatar.state == AvatarState.weak) {
        baseMessage += ' Let\'s build you back up, one habit at a time. 💪';
      }
    }
    
    return baseMessage;
  }

  static String generateGreeting(CoachPersonality personality, DateTime time) {
    final hour = time.hour;
    String timeGreeting;
    
    if (hour < 12) {
      timeGreeting = 'Good morning';
    } else if (hour < 17) {
      timeGreeting = 'Good afternoon';
    } else {
      timeGreeting = 'Good evening';
    }
    
    switch (personality) {
      case CoachPersonality.motivational:
        return '$timeGreeting, champion! Ready to dominate today? 💪';
      case CoachPersonality.strict:
        return '$timeGreeting. Let\'s get to work.';
      case CoachPersonality.funny:
        return '$timeGreeting, you magnificent human! 🎭';
      case CoachPersonality.wise:
        return '$timeGreeting. A new day brings new opportunities for growth.';
      case CoachPersonality.supportive:
        return '$timeGreeting, beautiful soul! How are you feeling today? 💙';
      case CoachPersonality.challenging:
        return '$timeGreeting. Are you ready to push your limits?';
      case CoachPersonality.playful:
        return '$timeGreeting, you awesome human! 🎮';
      case CoachPersonality.zen:
        return '$timeGreeting. May your day be filled with peace and purpose. 🧘‍♀️';
    }
  }

  static String generateMotivationalQuote(CoachPersonality personality) {
    final quotes = {
      CoachPersonality.motivational: [
        'The only way to do great work is to love what you do. - Steve Jobs',
        'Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill',
        'The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt',
      ],
      CoachPersonality.strict: [
        'Discipline is the bridge between goals and accomplishment. - Jim Rohn',
        'The difference between ordinary and extraordinary is that little extra. - Jimmy Johnson',
        'Excellence is not an act, it\'s a habit. - Aristotle',
      ],
      CoachPersonality.wise: [
        'The journey of a thousand miles begins with a single step. - Lao Tzu',
        'Wisdom comes from experience, and experience comes from making mistakes. - Unknown',
        'Your habits are the architects of your destiny. - Unknown',
      ],
      CoachPersonality.zen: [
        'Peace comes from within. Do not seek it without. - Buddha',
        'In the midst of movement and chaos, keep stillness inside you. - Deepak Chopra',
        'The present moment is filled with joy and happiness. - Thich Nhat Hanh',
      ],
    };
    
    final personalityQuotes = quotes[personality] ?? quotes[CoachPersonality.motivational]!;
    final random = DateTime.now().millisecondsSinceEpoch;
    return personalityQuotes[random % personalityQuotes.length];
  }
}
