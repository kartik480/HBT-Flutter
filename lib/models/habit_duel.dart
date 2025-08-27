import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum DuelStatus {
  pending,
  active,
  completed,
  cancelled,
  expired,
}

enum DuelType {
  daily,
  weekly,
  monthly,
  custom,
}

enum DuelOutcome {
  player1Win,
  player2Win,
  tie,
  incomplete,
}

class HabitDuel {
  final String id;
  final String player1Id;
  final String player1Name;
  final String player2Id;
  final String player2Name;
  final String title;
  final String description;
  final DuelType type;
  final DuelStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<String> habitIds;
  final Map<String, int> player1Scores;
  final Map<String, int> player2Scores;
  final DuelOutcome outcome;
  final String? winnerId;
  final String? winnerName;
  final List<String> rewards;
  final Map<String, dynamic> metadata;

  HabitDuel({
    required this.id,
    required this.player1Id,
    required this.player1Name,
    required this.player2Id,
    required this.player2Name,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.habitIds,
    required this.player1Scores,
    required this.player2Scores,
    required this.outcome,
    this.winnerId,
    this.winnerName,
    required this.rewards,
    required this.metadata,
  });

  HabitDuel copyWith({
    String? id,
    String? player1Id,
    String? player1Name,
    String? player2Id,
    String? player2Name,
    String? title,
    String? description,
    DuelType? type,
    DuelStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    List<String>? habitIds,
    Map<String, int>? player1Scores,
    Map<String, int>? player2Scores,
    DuelOutcome? outcome,
    String? winnerId,
    String? winnerName,
    List<String>? rewards,
    Map<String, dynamic>? metadata,
  }) {
    return HabitDuel(
      id: id ?? this.id,
      player1Id: player1Id ?? this.player1Id,
      player1Name: player1Name ?? this.player1Name,
      player2Id: player2Id ?? this.player2Id,
      player2Name: player2Name ?? this.player2Name,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      habitIds: habitIds ?? this.habitIds,
      player1Scores: player1Scores ?? this.player1Scores,
      player2Scores: player2Scores ?? this.player2Scores,
      outcome: outcome ?? this.outcome,
      winnerId: winnerId ?? this.winnerId,
      winnerName: winnerName ?? this.winnerName,
      rewards: rewards ?? this.rewards,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1Id': player1Id,
      'player1Name': player1Name,
      'player2Id': player2Id,
      'player2Name': player2Name,
      'title': title,
      'description': description,
      'type': type.index,
      'status': status.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'habitIds': habitIds,
      'player1Scores': player1Scores,
      'player2Scores': player2Scores,
      'outcome': outcome.index,
      'winnerId': winnerId,
      'winnerName': winnerName,
      'rewards': rewards,
      'metadata': metadata,
    };
  }

  factory HabitDuel.fromJson(Map<String, dynamic> json) {
    return HabitDuel(
      id: json['id'],
      player1Id: json['player1Id'],
      player1Name: json['player1Name'],
      player2Id: json['player2Id'],
      player2Name: json['player2Name'],
      title: json['title'],
      description: json['description'],
      type: DuelType.values[json['type']],
      status: DuelStatus.values[json['status']],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      habitIds: List<String>.from(json['habitIds']),
      player1Scores: Map<String, int>.from(json['player1Scores']),
      player2Scores: Map<String, int>.from(json['player2Scores']),
      outcome: DuelOutcome.values[json['outcome']],
      winnerId: json['winnerId'],
      winnerName: json['winnerName'],
      rewards: List<String>.from(json['rewards']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  factory HabitDuel.create({
    required String player1Id,
    required String player1Name,
    required String player2Id,
    required String player2Name,
    required String title,
    required String description,
    required DuelType type,
    required List<String> habitIds,
  }) {
    final now = DateTime.now();
    DateTime endDate;
    
    switch (type) {
      case DuelType.daily:
        endDate = now.add(const Duration(days: 1));
        break;
      case DuelType.weekly:
        endDate = now.add(const Duration(days: 7));
        break;
      case DuelType.monthly:
        endDate = now.add(const Duration(days: 30));
        break;
      case DuelType.custom:
        endDate = now.add(const Duration(days: 7));
        break;
    }
    
    return HabitDuel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      player1Id: player1Id,
      player1Name: player1Name,
      player2Id: player2Id,
      player2Name: player2Name,
      title: title,
      description: description,
      type: type,
      status: DuelStatus.pending,
      startDate: now,
      endDate: endDate,
      createdAt: now,
      habitIds: habitIds,
      player1Scores: {},
      player2Scores: {},
      outcome: DuelOutcome.incomplete,
      rewards: _generateRewards(type),
      metadata: {
        'duel_theme': 'friendly_competition',
        'difficulty': 'medium',
        'category': 'general',
      },
    );
  }

  static List<String> _generateRewards(DuelType type) {
    switch (type) {
      case DuelType.daily:
        return ['Daily Champion Badge', '50 Time Coins', '1 Day Streak Bonus'];
      case DuelType.weekly:
        return ['Weekly Warrior Badge', '200 Time Coins', '7 Day Streak Bonus', 'Special Avatar Frame'];
      case DuelType.monthly:
        return ['Monthly Master Badge', '1000 Time Coins', '30 Day Streak Bonus', 'Exclusive Avatar', 'Legendary Title'];
      case DuelType.custom:
        return ['Custom Challenge Badge', '100 Time Coins', 'Personal Achievement'];
    }
  }

  bool get isActive => status == DuelStatus.active;
  bool get isPending => status == DuelStatus.pending;
  bool get isCompleted => status == DuelStatus.completed;
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isCancelled => status == DuelStatus.cancelled;

  int getPlayer1TotalScore {
    return player1Scores.values.fold(0, (sum, score) => sum + score);
  }

  int getPlayer2TotalScore {
    return player2Scores.values.fold(0, (sum, score) => sum + score);
  }

  String getLeadingPlayer {
    if (getPlayer1TotalScore > getPlayer2TotalScore) {
      return player1Name;
    } else if (getPlayer2TotalScore > getPlayer1TotalScore) {
      return player2Name;
    } else {
      return 'Tie';
    }
  }

  double getPlayer1Progress {
    if (habitIds.isEmpty) return 0.0;
    return (player1Scores.length / habitIds.length) * 100;
  }

  double getPlayer2Progress {
    if (habitIds.isEmpty) return 0.0;
    return (player2Scores.length / habitIds.length) * 100;
  }

  String getDuelStatusDescription() {
    switch (status) {
      case DuelStatus.pending:
        return 'Waiting for acceptance';
      case DuelStatus.active:
        return 'Battle in progress!';
      case DuelStatus.completed:
        return 'Duel finished';
      case DuelStatus.cancelled:
        return 'Duel cancelled';
      case DuelStatus.expired:
        return 'Time expired';
    }
  }

  Color getDuelStatusColor() {
    switch (status) {
      case DuelStatus.pending:
        return Colors.orange;
      case DuelStatus.active:
        return Colors.green;
      case DuelStatus.completed:
        return Colors.blue;
      case DuelStatus.cancelled:
        return Colors.red;
      case DuelStatus.expired:
        return Colors.grey;
    }
  }

  HabitDuel accept() {
    if (status != DuelStatus.pending) return this;
    return copyWith(status: DuelStatus.active);
  }

  HabitDuel cancel() {
    if (status == DuelStatus.completed) return this;
    return copyWith(
      status: DuelStatus.cancelled,
      outcome: DuelOutcome.incomplete,
    );
  }

  HabitDuel updateScore(String playerId, String habitId, int score) {
    if (status != DuelStatus.active) return this;
    
    if (playerId == player1Id) {
      final newPlayer1Scores = Map<String, int>.from(player1Scores);
      newPlayer1Scores[habitId] = score;
      return copyWith(player1Scores: newPlayer1Scores);
    } else if (playerId == player2Id) {
      final newPlayer2Scores = Map<String, int>.from(player2Scores);
      newPlayer2Scores[habitId] = score;
      return copyWith(player2Scores: newPlayer2Scores);
    }
    
    return this;
  }

  HabitDuel complete() {
    if (status != DuelStatus.active) return this;
    
    final player1Total = getPlayer1TotalScore;
    final player2Total = getPlayer2TotalScore;
    
    DuelOutcome finalOutcome;
    String? finalWinnerId;
    String? finalWinnerName;
    
    if (player1Total > player2Total) {
      finalOutcome = DuelOutcome.player1Win;
      finalWinnerId = player1Id;
      finalWinnerName = player1Name;
    } else if (player2Total > player1Total) {
      finalOutcome = DuelOutcome.player2Win;
      finalWinnerId = player2Id;
      finalWinnerName = player2Name;
    } else {
      finalOutcome = DuelOutcome.tie;
    }
    
    return copyWith(
      status: DuelStatus.completed,
      outcome: finalOutcome,
      winnerId: finalWinnerId,
      winnerName: finalWinnerName,
    );
  }

  String getDuelTypeDescription() {
    switch (type) {
      case DuelType.daily:
        return '24-Hour Challenge';
      case DuelType.weekly:
        return '7-Day Battle';
      case DuelType.monthly:
        return '30-Day Epic';
      case DuelType.custom:
        return 'Custom Challenge';
    }
  }

  Duration getRemainingTime() {
    if (isExpired || isCompleted || isCancelled) {
      return Duration.zero;
    }
    return endDate.difference(DateTime.now());
  }

  String getRemainingTimeText() {
    final remaining = getRemainingTime();
    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h remaining';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m remaining';
    } else {
      return 'Less than 1 minute';
    }
  }
}

class DuelBadge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final Color color;
  final int rarity; // 1-5, 5 being legendary
  final List<String> requirements;
  final DateTime unlockedAt;
  final bool isUnlocked;

  DuelBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.rarity,
    required this.requirements,
    required this.unlockedAt,
    required this.isUnlocked,
  });

  DuelBadge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    Color? color,
    int? rarity,
    List<String>? requirements,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return DuelBadge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      color: color ?? this.color,
      rarity: rarity ?? this.rarity,
      requirements: requirements ?? this.requirements,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'color': color.value,
      'rarity': rarity,
      'requirements': requirements,
      'unlockedAt': unlockedAt.toIso8601String(),
      'isUnlocked': isUnlocked,
    };
  }

  factory DuelBadge.fromJson(Map<String, dynamic> json) {
    return DuelBadge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconPath: json['iconPath'],
      color: Color(json['color']),
      rarity: json['rarity'],
      requirements: List<String>.from(json['requirements']),
      unlockedAt: DateTime.parse(json['unlockedAt']),
      isUnlocked: json['isUnlocked'],
    );
  }

  String getRarityText() {
    switch (rarity) {
      case 1:
        return 'Common';
      case 2:
        return 'Uncommon';
      case 3:
        return 'Rare';
      case 4:
        return 'Epic';
      case 5:
        return 'Legendary';
      default:
        return 'Unknown';
    }
  }

  Color getRarityColor() {
    switch (rarity) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  DuelBadge unlock() {
    return copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
  }
}

class DuelManager {
  static final List<DuelBadge> _availableBadges = [
    DuelBadge(
      id: 'first_duel',
      name: 'First Blood',
      description: 'Complete your first habit duel',
      iconPath: 'assets/badges/first_duel.png',
      color: Colors.orange,
      rarity: 1,
      requirements: ['Complete 1 duel'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'duel_master',
      name: 'Duel Master',
      description: 'Win 10 habit duels',
      iconPath: 'assets/badges/duel_master.png',
      color: Colors.purple,
      rarity: 3,
      requirements: ['Win 10 duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'streak_champion',
      name: 'Streak Champion',
      description: 'Win 5 duels in a row',
      iconPath: 'assets/badges/streak_champion.png',
      color: Colors.red,
      rarity: 4,
      requirements: ['Win 5 consecutive duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'legendary_dueler',
      name: 'Legendary Dueler',
      description: 'Win 100 habit duels',
      iconPath: 'assets/badges/legendary_dueler.png',
      color: Colors.amber,
      rarity: 5,
      requirements: ['Win 100 duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'daily_warrior',
      name: 'Daily Warrior',
      description: 'Win 7 daily duels',
      iconPath: 'assets/badges/daily_warrior.png',
      color: Colors.blue,
      rarity: 3,
      requirements: ['Win 7 daily duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'weekly_champion',
      name: 'Weekly Champion',
      description: 'Win 4 weekly duels',
      iconPath: 'assets/badges/weekly_champion.png',
      color: Colors.green,
      rarity: 3,
      requirements: ['Win 4 weekly duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'monthly_legend',
      name: 'Monthly Legend',
      description: 'Win 3 monthly duels',
      iconPath: 'assets/badges/monthly_legend.png',
      color: Colors.deepPurple,
      rarity: 4,
      requirements: ['Win 3 monthly duels'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
    DuelBadge(
      id: 'comeback_king',
      name: 'Comeback King',
      description: 'Win a duel after being behind',
      iconPath: 'assets/badges/comeback_king.png',
      color: Colors.teal,
      rarity: 3,
      requirements: ['Win from behind'],
      unlockedAt: DateTime.now(),
      isUnlocked: false,
    ),
  ];

  static List<DuelBadge> getAvailableBadges() {
    return List.from(_availableBadges);
  }

  static DuelBadge? getBadgeById(String id) {
    try {
      return _availableBadges.firstWhere((badge) => badge.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<DuelBadge> getBadgesByRarity(int rarity) {
    return _availableBadges.where((badge) => badge.rarity == rarity).toList();
  }

  static List<DuelBadge> getUnlockedBadges(List<String> unlockedBadgeIds) {
    return _availableBadges.map((badge) {
      if (unlockedBadgeIds.contains(badge.id)) {
        return badge.unlock();
      }
      return badge;
    }).toList();
  }
}
