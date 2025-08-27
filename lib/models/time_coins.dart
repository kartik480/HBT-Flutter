import 'package:flutter/material.dart';

enum CoinType {
  time,
  experience,
  achievement,
  bonus,
  streak,
  quest,
}

enum TransactionType {
  earned,
  spent,
  bonus,
  penalty,
  refund,
}

class TimeCoin {
  final String id;
  final int amount;
  final CoinType type;
  final String description;
  final DateTime earnedAt;
  final bool isSpent;
  final DateTime? spentAt;
  final String? spentOn;

  TimeCoin({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.earnedAt,
    required this.isSpent,
    this.spentAt,
    this.spentOn,
  });

  TimeCoin copyWith({
    String? id,
    int? amount,
    CoinType? type,
    String? description,
    DateTime? earnedAt,
    bool? isSpent,
    DateTime? spentAt,
    String? spentOn,
  }) {
    return TimeCoin(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      earnedAt: earnedAt ?? this.earnedAt,
      isSpent: isSpent ?? this.isSpent,
      spentAt: spentAt ?? this.spentAt,
      spentOn: spentOn ?? this.spentOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.index,
      'description': description,
      'earnedAt': earnedAt.toIso8601String(),
      'isSpent': isSpent,
      'spentAt': spentAt?.toIso8601String(),
      'spentOn': spentOn,
    };
  }

  factory TimeCoin.fromJson(Map<String, dynamic> json) {
    return TimeCoin(
      id: json['id'],
      amount: json['amount'],
      type: CoinType.values[json['type']],
      description: json['description'],
      earnedAt: DateTime.parse(json['earnedAt']),
      isSpent: json['isSpent'],
      spentAt: json['spentAt'] != null ? DateTime.parse(json['spentAt']) : null,
      spentOn: json['spentOn'],
    );
  }

  Color getCoinColor() {
    switch (type) {
      case CoinType.time:
        return Colors.blue;
      case CoinType.experience:
        return Colors.green;
      case CoinType.achievement:
        return Colors.purple;
      case CoinType.bonus:
        return Colors.amber;
      case CoinType.streak:
        return Colors.orange;
      case CoinType.quest:
        return Colors.teal;
    }
  }

  IconData getCoinIcon() {
    switch (type) {
      case CoinType.time:
        return Icons.access_time;
      case CoinType.experience:
        return Icons.trending_up;
      case CoinType.achievement:
        return Icons.emoji_events;
      case CoinType.bonus:
        return Icons.star;
      case CoinType.streak:
        return Icons.local_fire_department;
      case CoinType.quest:
        return Icons.quest;
    }
  }

  TimeCoin spend(String itemName) {
    return copyWith(
      isSpent: true,
      spentAt: DateTime.now(),
      spentOn: itemName,
    );
  }
}

class Transaction {
  final String id;
  final int amount;
  final TransactionType type;
  final String description;
  final DateTime timestamp;
  final int balanceAfter;
  final String? relatedItem;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.balanceAfter,
    this.relatedItem,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.index,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'balanceAfter': balanceAfter,
      'relatedItem': relatedItem,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      type: TransactionType.values[json['type']],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      balanceAfter: json['balanceAfter'],
      relatedItem: json['relatedItem'],
    );
  }

  Color getTransactionColor() {
    switch (type) {
      case TransactionType.earned:
      case TransactionType.bonus:
        return Colors.green;
      case TransactionType.spent:
      case TransactionType.penalty:
        return Colors.red;
      case TransactionType.refund:
        return Colors.blue;
    }
  }

  IconData getTransactionIcon() {
    switch (type) {
      case TransactionType.earned:
        return Icons.add_circle;
      case TransactionType.spent:
        return Icons.remove_circle;
      case TransactionType.bonus:
        return Icons.star;
      case TransactionType.penalty:
        return Icons.warning;
      case TransactionType.refund:
        return Icons.refresh;
    }
  }
}

class TimeCoinWallet {
  final String id;
  final String userId;
  final int balance;
  final List<TimeCoin> coins;
  final List<Transaction> transactions;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final int totalEarned;
  final int totalSpent;
  final int totalBonus;

  TimeCoinWallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.coins,
    required this.transactions,
    required this.createdAt,
    required this.lastUpdated,
    required this.totalEarned,
    required this.totalSpent,
    required this.totalBonus,
  });

  TimeCoinWallet copyWith({
    String? id,
    String? userId,
    int? balance,
    List<TimeCoin>? coins,
    List<Transaction>? transactions,
    DateTime? createdAt,
    DateTime? lastUpdated,
    int? totalEarned,
    int? totalSpent,
    int? totalBonus,
  }) {
    return TimeCoinWallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      coins: coins ?? this.coins,
      transactions: transactions ?? this.transactions,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      totalBonus: totalBonus ?? this.totalBonus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'coins': coins.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'totalBonus': totalBonus,
    };
  }

  factory TimeCoinWallet.fromJson(Map<String, dynamic> json) {
    return TimeCoinWallet(
      id: json['id'],
      userId: json['userId'],
      balance: json['balance'],
      coins: (json['coins'] as List).map((c) => TimeCoin.fromJson(c)).toList(),
      transactions: (json['transactions'] as List).map((t) => Transaction.fromJson(t)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      totalEarned: json['totalEarned'],
      totalSpent: json['totalSpent'],
      totalBonus: json['totalBonus'],
    );
  }

  factory TimeCoinWallet.createDefault(String userId) {
    return TimeCoinWallet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      balance: 100, // Starting bonus
      coins: [
        TimeCoin(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: 100,
          type: CoinType.bonus,
          description: 'Welcome bonus - Start your journey!',
          earnedAt: DateTime.now(),
          isSpent: false,
        ),
      ],
      transactions: [
        Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: 100,
          type: TransactionType.bonus,
          description: 'Welcome bonus - Start your journey!',
          timestamp: DateTime.now(),
          balanceAfter: 100,
        ),
      ],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      totalEarned: 100,
      totalSpent: 0,
      totalBonus: 100,
    );
  }

  TimeCoinWallet earnCoins(int amount, CoinType type, String description) {
    final newCoin = TimeCoin(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: type,
      description: description,
      earnedAt: DateTime.now(),
      isSpent: false,
    );

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: TransactionType.earned,
      description: description,
      timestamp: DateTime.now(),
      balanceAfter: balance + amount,
    );

    return copyWith(
      balance: balance + amount,
      coins: [...coins, newCoin],
      transactions: [...transactions, newTransaction],
      lastUpdated: DateTime.now(),
      totalEarned: totalEarned + amount,
    );
  }

  TimeCoinWallet spendCoins(int amount, String itemName) {
    if (balance < amount) {
      throw Exception('Insufficient coins');
    }

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: TransactionType.spent,
      description: 'Spent on $itemName',
      timestamp: DateTime.now(),
      balanceAfter: balance - amount,
      relatedItem: itemName,
    );

    return copyWith(
      balance: balance - amount,
      transactions: [...transactions, newTransaction],
      lastUpdated: DateTime.now(),
      totalSpent: totalSpent + amount,
    );
  }

  TimeCoinWallet addBonus(int amount, String description) {
    final newCoin = TimeCoin(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: CoinType.bonus,
      description: description,
      earnedAt: DateTime.now(),
      isSpent: false,
    );

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: TransactionType.bonus,
      description: description,
      timestamp: DateTime.now(),
      balanceAfter: balance + amount,
    );

    return copyWith(
      balance: balance + amount,
      coins: [...coins, newCoin],
      transactions: [...transactions, newTransaction],
      lastUpdated: DateTime.now(),
      totalEarned: totalEarned + amount,
      totalBonus: totalBonus + amount,
    );
  }

  TimeCoinWallet applyPenalty(int amount, String reason) {
    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: TransactionType.penalty,
      description: 'Penalty: $reason',
      timestamp: DateTime.now(),
      balanceAfter: (balance - amount).clamp(0, balance),
    );

    return copyWith(
      balance: (balance - amount).clamp(0, balance),
      transactions: [...transactions, newTransaction],
      lastUpdated: DateTime.now(),
    );
  }

  List<TimeCoin> getUnspentCoins() {
    return coins.where((coin) => !coin.isSpent).toList();
  }

  List<TimeCoin> getSpentCoins() {
    return coins.where((coin) => coin.isSpent).toList();
  }

  List<TimeCoin> getCoinsByType(CoinType type) {
    return coins.where((coin) => coin.type == type).toList();
  }

  List<Transaction> getRecentTransactions(int count) {
    final sorted = List<Transaction>.from(transactions);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(count).toList();
  }

  double getEarningRate() {
    final now = DateTime.now();
    final daysSinceCreation = now.difference(createdAt).inDays;
    if (daysSinceCreation == 0) return totalEarned.toDouble();
    return totalEarned / daysSinceCreation;
  }

  String getBalanceStatus() {
    if (balance >= 1000) {
      return '💰 Coin Master - You\'re rolling in time!';
    } else if (balance >= 500) {
      return '💎 Wealthy - Great job saving your time!';
    } else if (balance >= 200) {
      return '💫 Prosperous - You\'re building wealth!';
    } else if (balance >= 100) {
      return '⭐ Stable - Good financial habits!';
    } else if (balance >= 50) {
      return '⚠️ Low - Time to earn more coins!';
    } else {
      return '🚨 Critical - Need to complete more habits!';
    }
  }
}

class CoinRewardSystem {
  static const Map<String, int> _habitCompletionRewards = {
    'health': 15,
    'fitness': 20,
    'learning': 25,
    'productivity': 30,
    'mindfulness': 20,
    'social': 15,
    'finance': 25,
    'creativity': 20,
    'other': 15,
  };

  static const Map<String, int> _streakRewards = {
    '3': 10,
    '7': 25,
    '14': 50,
    '30': 100,
    '60': 200,
    '100': 500,
    '365': 1000,
  };

  static const Map<String, int> _achievementRewards = {
    'first_habit': 50,
    'week_complete': 100,
    'month_complete': 250,
    'perfect_day': 75,
    'comeback': 100,
    'legendary': 500,
  };

  static int getHabitCompletionReward(String category) {
    return _habitCompletionRewards[category] ?? 15;
  }

  static int getStreakReward(int streak) {
    for (final entry in _streakRewards.entries) {
      if (streak >= int.parse(entry.key)) {
        return entry.value;
      }
    }
    return 0;
  }

  static int getAchievementReward(String achievement) {
    return _achievementRewards[achievement] ?? 0;
  }

  static int getQuestCompletionReward(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 10;
      case 'medium':
        return 25;
      case 'hard':
        return 50;
      case 'epic':
        return 100;
      case 'legendary':
        return 250;
      default:
        return 15;
    }
  }

  static int getDailyBonus() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    
    // Weekend bonus
    if (dayOfWeek == DateTime.saturday || dayOfWeek == DateTime.sunday) {
      return 25;
    }
    
    // Monday motivation bonus
    if (dayOfWeek == DateTime.monday) {
      return 20;
    }
    
    // Regular day bonus
    return 15;
  }

  static int getPerfectDayBonus(int habitsCompleted, int totalHabits) {
    if (totalHabits == 0) return 0;
    
    final completionRate = habitsCompleted / totalHabits;
    if (completionRate >= 0.9) {
      return 100; // Perfect day bonus
    } else if (completionRate >= 0.8) {
      return 50; // Great day bonus
    } else if (completionRate >= 0.6) {
      return 25; // Good day bonus
    }
    
    return 0;
  }
}
