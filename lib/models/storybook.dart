import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/models/avatar.dart';

enum StoryGenre {
  fantasy,
  adventure,
  mystery,
  romance,
  sciFi,
  historical,
  contemporary,
  magical,
}

enum StoryMood {
  triumphant,
  peaceful,
  mysterious,
  exciting,
  reflective,
  challenging,
  magical,
  inspiring,
}

class StoryChapter {
  final String id;
  final String title;
  final String content;
  final StoryGenre genre;
  final StoryMood mood;
  final DateTime writtenAt;
  final List<String> triggers; // What habits triggered this chapter
  final int chapterNumber;
  final String? imageUrl;
  final List<String> tags;
  final bool isUnlocked;
  final bool isRead;

  StoryChapter({
    required this.id,
    required this.title,
    required this.content,
    required this.genre,
    required this.mood,
    required this.writtenAt,
    required this.triggers,
    required this.chapterNumber,
    this.imageUrl,
    required this.tags,
    required this.isUnlocked,
    required this.isRead,
  });

  StoryChapter copyWith({
    String? id,
    String? title,
    String? content,
    StoryGenre? genre,
    StoryMood? mood,
    DateTime? writtenAt,
    List<String>? triggers,
    int? chapterNumber,
    String? imageUrl,
    List<String>? tags,
    bool? isUnlocked,
    bool? isRead,
  }) {
    return StoryChapter(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      genre: genre ?? this.genre,
      mood: mood ?? this.mood,
      writtenAt: writtenAt ?? this.writtenAt,
      triggers: triggers ?? this.triggers,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'genre': genre.index,
      'mood': mood.index,
      'writtenAt': writtenAt.toIso8601String(),
      'triggers': triggers,
      'chapterNumber': chapterNumber,
      'imageUrl': imageUrl,
      'tags': tags,
      'isUnlocked': isUnlocked,
      'isRead': isRead,
    };
  }

  factory StoryChapter.fromJson(Map<String, dynamic> json) {
    return StoryChapter(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      genre: StoryGenre.values[json['genre']],
      mood: StoryMood.values[json['mood']],
      writtenAt: DateTime.parse(json['writtenAt']),
      triggers: List<String>.from(json['triggers']),
      chapterNumber: json['chapterNumber'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags']),
      isUnlocked: json['isUnlocked'],
      isRead: json['isRead'],
    );
  }

  StoryChapter markAsRead() {
    return copyWith(isRead: true);
  }

  StoryChapter unlock() {
    return copyWith(isUnlocked: true);
  }

  Color getGenreColor() {
    switch (genre) {
      case StoryGenre.fantasy:
        return Colors.purple;
      case StoryGenre.adventure:
        return Colors.orange;
      case StoryGenre.mystery:
        return Colors.indigo;
      case StoryGenre.romance:
        return Colors.pink;
      case StoryGenre.sciFi:
        return Colors.cyan;
      case StoryGenre.historical:
        return Colors.brown;
      case StoryGenre.contemporary:
        return Colors.blue;
      case StoryGenre.magical:
        return Colors.deepPurple;
    }
  }

  IconData getGenreIcon() {
    switch (genre) {
      case StoryGenre.fantasy:
        return Icons.auto_awesome;
      case StoryGenre.adventure:
        return Icons.explore;
      case StoryGenre.mystery:
        return Icons.psychology;
      case StoryGenre.romance:
        return Icons.favorite;
      case StoryGenre.sciFi:
        return Icons.rocket;
      case StoryGenre.historical:
        return Icons.history;
      case StoryGenre.contemporary:
        return Icons.today;
      case StoryGenre.magical:
        return Icons.whatshot;
    }
  }
}

class Storybook {
  final String id;
  final String userId;
  final String title;
  final String subtitle;
  final String author;
  final List<StoryChapter> chapters;
  final StoryGenre primaryGenre;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final int totalChapters;
  final int unlockedChapters;
  final int readChapters;
  final String currentStoryline;
  final List<String> characters;
  final List<String> locations;
  final Map<String, dynamic> worldBuilding;

  Storybook({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.chapters,
    required this.primaryGenre,
    required this.createdAt,
    required this.lastUpdated,
    required this.totalChapters,
    required this.unlockedChapters,
    required this.readChapters,
    required this.currentStoryline,
    required this.characters,
    required this.locations,
    required this.worldBuilding,
  });

  Storybook copyWith({
    String? id,
    String? userId,
    String? title,
    String? subtitle,
    String? author,
    List<StoryChapter>? chapters,
    StoryGenre? primaryGenre,
    DateTime? createdAt,
    DateTime? lastUpdated,
    int? totalChapters,
    int? unlockedChapters,
    int? readChapters,
    String? currentStoryline,
    List<String>? characters,
    List<String>? locations,
    Map<String, dynamic>? worldBuilding,
  }) {
    return Storybook(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      author: author ?? this.author,
      chapters: chapters ?? this.chapters,
      primaryGenre: primaryGenre ?? this.primaryGenre,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      totalChapters: totalChapters ?? this.totalChapters,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
      readChapters: readChapters ?? this.readChapters,
      currentStoryline: currentStoryline ?? this.currentStoryline,
      characters: characters ?? this.characters,
      locations: locations ?? this.locations,
      worldBuilding: worldBuilding ?? this.worldBuilding,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'primaryGenre': primaryGenre.index,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'totalChapters': totalChapters,
      'unlockedChapters': unlockedChapters,
      'readChapters': readChapters,
      'currentStoryline': currentStoryline,
      'characters': characters,
      'locations': locations,
      'worldBuilding': worldBuilding,
    };
  }

  factory Storybook.fromJson(Map<String, dynamic> json) {
    return Storybook(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      subtitle: json['subtitle'],
      author: json['author'],
      chapters: (json['chapters'] as List).map((c) => StoryChapter.fromJson(c)).toList(),
      primaryGenre: StoryGenre.values[json['primaryGenre']],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      totalChapters: json['totalChapters'],
      unlockedChapters: json['unlockedChapters'],
      readChapters: json['readChapters'],
      currentStoryline: json['currentStoryline'],
      characters: List<String>.from(json['characters']),
      locations: List<String>.from(json['locations']),
      worldBuilding: Map<String, dynamic>.from(json['worldBuilding']),
    );
  }

  factory Storybook.createDefault(String userId, String userName) {
    return Storybook(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: 'The Chronicles of $userName',
      subtitle: 'A Journey of Growth and Transformation',
      author: userName,
      chapters: [
        StoryChapter(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'The Beginning',
          content: 'In a world where habits shape destinies, a new hero emerges. $userName, an ordinary person with extraordinary potential, stands at the threshold of an incredible journey. Little do they know that every choice, every action, and every habit will write the story of their transformation.\n\nAs the first rays of dawn break through the clouds, $userName takes their first step into a world of possibilities. The path ahead is uncertain, but the potential for greatness is limitless.\n\n"Every legend begins with a single step," whispers the wind, carrying the promise of adventure and growth.',
          genre: StoryGenre.fantasy,
          mood: StoryMood.inspiring,
          writtenAt: DateTime.now(),
          triggers: ['first_login'],
          chapterNumber: 1,
          tags: ['beginning', 'hero', 'journey', 'potential'],
          isUnlocked: true,
          isRead: false,
        ),
      ],
      primaryGenre: StoryGenre.fantasy,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      totalChapters: 1,
      unlockedChapters: 1,
      readChapters: 0,
      currentStoryline: 'A new hero begins their journey of transformation',
      characters: [userName, 'The Mentor', 'The Guardian Spirit'],
      locations: ['The Starting Village', 'The Path of Growth', 'The Garden of Habits'],
      worldBuilding: {
        'magic_system': 'Habit-based transformation magic',
        'world_name': 'Terra Habitus',
        'time_period': 'Era of Growth',
        'special_elements': ['Time Coins', 'Growth Crystals', 'Transformation Orbs'],
      },
    );
  }

  Storybook addChapter(StoryChapter chapter) {
    final newChapters = [...chapters, chapter];
    return copyWith(
      chapters: newChapters,
      totalChapters: newChapters.length,
      unlockedChapters: unlockedChapters + 1,
      lastUpdated: DateTime.now(),
    );
  }

  Storybook unlockChapter(String chapterId) {
    final updatedChapters = chapters.map((chapter) {
      if (chapter.id == chapterId) {
        return chapter.unlock();
      }
      return chapter;
    }).toList();

    final unlockedCount = updatedChapters.where((c) => c.isUnlocked).length;
    
    return copyWith(
      chapters: updatedChapters,
      unlockedChapters: unlockedCount,
      lastUpdated: DateTime.now(),
    );
  }

  Storybook markChapterAsRead(String chapterId) {
    final updatedChapters = chapters.map((chapter) {
      if (chapter.id == chapterId) {
        return chapter.markAsRead();
      }
      return chapter;
    }).toList();

    final readCount = updatedChapters.where((c) => c.isRead).length;
    
    return copyWith(
      chapters: updatedChapters,
      readChapters: readCount,
      lastUpdated: DateTime.now(),
    );
  }

  List<StoryChapter> getUnlockedChapters() {
    return chapters.where((chapter) => chapter.isUnlocked).toList();
  }

  List<StoryChapter> getUnreadChapters() {
    return chapters.where((chapter) => chapter.isUnlocked && !chapter.isRead).toList();
  }

  List<StoryChapter> getChaptersByGenre(StoryGenre genre) {
    return chapters.where((chapter) => chapter.genre == genre).toList();
  }

  List<StoryChapter> getChaptersByMood(StoryMood mood) {
    return chapters.where((chapter) => chapter.mood == mood).toList();
  }

  StoryChapter? getNextUnlockedChapter() {
    final unlocked = getUnlockedChapters();
    if (unlocked.isEmpty) return null;
    
    unlocked.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    return unlocked.firstWhere((c) => !c.isRead, orElse: () => unlocked.first);
  }

  String getProgressStatus() {
    if (totalChapters == 0) return 'No chapters yet';
    
    final progress = (unlockedChapters / totalChapters) * 100;
    if (progress >= 100) {
      return 'Story Complete! 🎉';
    } else if (progress >= 80) {
      return 'Near the End! 🌟';
    } else if (progress >= 60) {
      return 'Story Unfolding! 📖';
    } else if (progress >= 40) {
      return 'Building Momentum! 🚀';
    } else if (progress >= 20) {
      return 'Getting Started! 🌱';
    } else {
      return 'Just Beginning! ✨';
    }
  }
}

class StoryGenerator {
  static final Map<String, List<Map<String, dynamic>>> _chapterTemplates = {
    'habit_completion': [
      {
        'title': 'The Power Within',
        'content': 'As {userName} completed their {habitTitle}, a warm glow emanated from within. The habit, like a spark of magic, ignited a transformation that rippled through their being. Strength flowed through their veins, and wisdom whispered in their mind.\n\n"Every completed habit is a step toward greatness," echoed the ancient voice of the Guardian Spirit. "You are becoming the hero you were meant to be."\n\n{userName} felt the change, subtle yet profound. The world around them seemed brighter, more alive, as if responding to their growing power.',
        'genre': StoryGenre.fantasy,
        'mood': StoryMood.triumphant,
        'tags': ['transformation', 'power', 'growth', 'magic'],
      },
      {
        'title': 'The Garden Blooms',
        'content': 'In the mystical Garden of Habits, a new flower burst into bloom. {userName}\'s dedication to {habitTitle} had nurtured not just a habit, but a living testament to their commitment to growth.\n\nThe petals shimmered with an otherworldly light, casting dancing shadows across the garden path. Each completed habit was like watering the seeds of their future self, and today, {userName} had added another drop of determination to their journey.\n\n"Your garden grows more beautiful with each passing day," murmured the Garden Keeper, appearing from behind a flowering tree. "The world is watching your transformation."',
        'genre': StoryGenre.magical,
        'mood': StoryMood.peaceful,
        'tags': ['garden', 'nature', 'beauty', 'dedication'],
      },
    ],
    'streak_achievement': [
      {
        'title': 'The Fire of Consistency',
        'content': 'Flames of determination danced around {userName} as they achieved a {streakLength}-day streak. The fire was not destructive, but transformative, burning away doubt and forging unbreakable will.\n\n"Consistency is the forge of legends," proclaimed the Fire Master, emerging from the flames. "You have proven yourself worthy of the ancient knowledge."\n\n{userName} felt the heat of their own potential, a warmth that spread from their heart to every fiber of their being. They were no longer just a person with habits - they were a force of nature, unstoppable and unbreakable.',
        'genre': StoryGenre.adventure,
        'mood': StoryMood.exciting,
        'tags': ['fire', 'consistency', 'strength', 'legend'],
      },
    ],
    'milestone_reached': [
      {
        'title': 'The Mountain Peak',
        'content': 'After weeks of climbing, {userName} finally reached the summit of Mount Habit. The view from the top was breathtaking - they could see their entire journey spread out below them, every step, every habit, every moment of growth.\n\n"From this height, you can see the path to your destiny," said the Mountain Sage, appearing beside them. "The habits you\'ve built are the stones that pave your way to greatness."\n\n{userName} breathed in the thin mountain air, feeling lighter and stronger than ever before. They had proven that no goal was too high, no habit too difficult, when approached with determination and consistency.',
        'genre': StoryGenre.adventure,
        'mood': StoryMood.triumphant,
        'tags': ['mountain', 'achievement', 'perspective', 'destiny'],
      },
    ],
    'comeback_story': [
      {
        'title': 'The Phoenix Rises',
        'content': 'From the ashes of broken streaks and missed habits, {userName} emerged stronger than ever. Like the legendary phoenix, they had been reborn through the fire of their own determination.\n\n"Setbacks are not failures," whispered the Phoenix Spirit, its golden feathers glowing with renewed life. "They are the catalysts for greater comebacks. You have learned that true strength lies not in never falling, but in always rising again."\n\n{userName} felt the power of resilience coursing through them. They were not just rebuilding their habits - they were building an unbreakable spirit that would carry them through any challenge.',
        'genre': StoryGenre.fantasy,
        'mood': StoryMood.inspiring,
        'tags': ['phoenix', 'resilience', 'comeback', 'strength'],
      },
    ],
  };

  static StoryChapter generateChapter({
    required String trigger,
    required String userName,
    required List<Habit> completedHabits,
    required int chapterNumber,
    Map<String, String>? customData,
  }) {
    List<Map<String, dynamic>> templates = [];
    
    switch (trigger) {
      case 'habit_completion':
        templates = _chapterTemplates['habit_completion'] ?? [];
        break;
      case 'streak_achievement':
        templates = _chapterTemplates['streak_achievement'] ?? [];
        break;
      case 'milestone_reached':
        templates = _chapterTemplates['milestone_reached'] ?? [];
        break;
      case 'comeback_story':
        templates = _chapterTemplates['comeback_story'] ?? [];
        break;
      default:
        templates = _chapterTemplates['habit_completion'] ?? [];
    }
    
    if (templates.isEmpty) {
      templates = _chapterTemplates['habit_completion'] ?? [];
    }
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final template = templates[random % templates.length];
    
    String content = template['content'];
    String title = template['title'];
    
    // Replace placeholders with actual data
    content = content.replaceAll('{userName}', userName);
    title = title.replaceAll('{userName}', userName);
    
    if (completedHabits.isNotEmpty) {
      final habit = completedHabits.first;
      content = content.replaceAll('{habitTitle}', habit.title);
    }
    
    if (customData != null) {
      customData.forEach((key, value) {
        content = content.replaceAll('{$key}', value);
        title = title.replaceAll('{$key}', value);
      });
    }
    
    return StoryChapter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      genre: StoryGenre.values[template['genre']],
      mood: StoryMood.values[template['mood']],
      writtenAt: DateTime.now(),
      triggers: [trigger],
      chapterNumber: chapterNumber,
      tags: List<String>.from(template['tags']),
      isUnlocked: true,
      isRead: false,
    );
  }

  static StoryChapter generatePersonalizedChapter({
    required String userName,
    required HabitCategory category,
    required int streak,
    required int chapterNumber,
    required StoryMood mood,
  }) {
    final categoryStories = {
      HabitCategory.health: {
        'title': 'The Healing Touch',
        'content': '{userName} felt the warm energy of vitality flowing through their body. Each health habit was like a healing spell, restoring their natural strength and resilience. The Guardian of Health smiled upon their dedication.\n\n"Your body is a temple, and you are its faithful caretaker," the Guardian whispered. "Every healthy choice is a prayer answered, every wellness habit a step toward immortality."\n\n{userName} could feel their cells singing with renewed life, their energy levels rising like the morning sun. They were not just living - they were thriving.',
      },
      HabitCategory.fitness: {
        'title': 'The Warrior\'s Path',
        'content': 'Muscles rippled with newfound power as {userName} completed another fitness challenge. They were no longer just exercising - they were forging their body into a weapon of strength and endurance.\n\nThe Spirit of Fitness appeared, its form shifting between different athletic disciplines. "You are becoming a warrior of the modern age," it declared. "Your body is your armor, your habits your sword. Together, you are unstoppable."\n\n{userName} felt the power coursing through their limbs, a strength that came not just from muscles, but from the unbreakable will that drove them forward.',
      },
      HabitCategory.learning: {
        'title': 'The Scholar\'s Awakening',
        'content': 'Knowledge flowed like a river through {userName}\'s mind, each learning habit expanding their understanding of the world. They were not just studying - they were becoming a vessel of wisdom.\n\nThe Ancient Scholar materialized from the pages of forgotten books. "Your mind is a library, and every habit is a new volume added to your collection," it said. "You are building an empire of knowledge, one habit at a time."\n\n{userName} could feel their perspective broadening, their thoughts becoming clearer and more profound. They were evolving into something greater than they had ever been.',
      },
      HabitCategory.creativity: {
        'title': 'The Artist\'s Vision',
        'content': 'Creativity sparked like lightning in {userName}\'s soul, each creative habit unlocking new dimensions of imagination. They were not just making art - they were becoming a conduit for divine inspiration.\n\nThe Muse of Creativity danced around them, trailing stardust and possibility. "Your imagination is a universe waiting to be explored," she sang. "Every creative habit is a new star born in your personal galaxy of ideas."\n\n{userName} felt their inner artist awakening, their mind overflowing with colors, sounds, and stories that had never existed before. They were not just creating - they were manifesting dreams into reality.',
      },
    };
    
    final story = categoryStories[category] ?? categoryStories[HabitCategory.health]!;
    String content = story['content']!.replaceAll('{userName}', userName);
    
    return StoryChapter(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: story['title']!,
      content: content,
      genre: StoryGenre.fantasy,
      mood: mood,
      writtenAt: DateTime.now(),
      triggers: ['personalized_${category.name}'],
      chapterNumber: chapterNumber,
      tags: [category.name, 'personalized', 'growth', 'transformation'],
      isUnlocked: true,
      isRead: false,
    );
  }
}
