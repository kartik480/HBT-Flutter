import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

enum PlantType {
  seed,
  sprout,
  sapling,
  young,
  mature,
  flowering,
  fruiting,
  ancient,
}

enum PlantHealth {
  dead,
  wilted,
  struggling,
  healthy,
  thriving,
  vibrant,
  radiant,
}

class GardenPlant {
  final String id;
  final String habitId;
  final String habitTitle;
  final HabitCategory category;
  final PlantType type;
  final PlantHealth health;
  final double growth;
  final double water;
  final double sunlight;
  final DateTime plantedDate;
  final DateTime lastWatered;
  final DateTime lastCared;
  final List<String> careHistory;
  final int daysAlive;
  final bool isAlive;

  GardenPlant({
    required this.id,
    required this.habitId,
    required this.habitTitle,
    required this.category,
    required this.type,
    required this.health,
    required this.growth,
    required this.water,
    required this.sunlight,
    required this.plantedDate,
    required this.lastWatered,
    required this.lastCared,
    required this.careHistory,
    required this.daysAlive,
    required this.isAlive,
  });

  GardenPlant copyWith({
    String? id,
    String? habitId,
    String? habitTitle,
    HabitCategory? category,
    PlantType? type,
    PlantHealth? health,
    double? growth,
    double? water,
    double? sunlight,
    DateTime? plantedDate,
    DateTime? lastWatered,
    DateTime? lastCared,
    List<String>? careHistory,
    int? daysAlive,
    bool? isAlive,
  }) {
    return GardenPlant(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitTitle: habitTitle ?? this.habitTitle,
      category: category ?? this.category,
      type: type ?? this.type,
      health: health ?? this.health,
      growth: growth ?? this.growth,
      water: water ?? this.water,
      sunlight: sunlight ?? this.sunlight,
      plantedDate: plantedDate ?? this.plantedDate,
      lastWatered: lastWatered ?? this.lastWatered,
      lastCared: lastCared ?? this.lastCared,
      careHistory: careHistory ?? this.careHistory,
      daysAlive: daysAlive ?? this.daysAlive,
      isAlive: isAlive ?? this.isAlive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'habitTitle': habitTitle,
      'category': category.index,
      'type': type.index,
      'health': health.index,
      'growth': growth,
      'water': water,
      'sunlight': sunlight,
      'plantedDate': plantedDate.toIso8601String(),
      'lastWatered': lastWatered.toIso8601String(),
      'lastCared': lastCared.toIso8601String(),
      'careHistory': careHistory,
      'daysAlive': daysAlive,
      'isAlive': isAlive,
    };
  }

  factory GardenPlant.fromJson(Map<String, dynamic> json) {
    return GardenPlant(
      id: json['id'],
      habitId: json['habitId'],
      habitTitle: json['habitTitle'],
      category: HabitCategory.values[json['category']],
      type: PlantType.values[json['type']],
      health: PlantHealth.values[json['health']],
      growth: json['growth'].toDouble(),
      water: json['water'].toDouble(),
      sunlight: json['sunlight'].toDouble(),
      plantedDate: DateTime.parse(json['plantedDate']),
      lastWatered: DateTime.parse(json['lastWatered']),
      lastCared: DateTime.parse(json['lastCared']),
      careHistory: List<String>.from(json['careHistory']),
      daysAlive: json['daysAlive'],
      isAlive: json['isAlive'],
    );
  }

  factory GardenPlant.createFromHabit(Habit habit) {
    final now = DateTime.now();
    return GardenPlant(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      habitId: habit.id,
      habitTitle: habit.title,
      category: habit.category,
      type: PlantType.seed,
      health: PlantHealth.healthy,
      growth: 0.0,
      water: 100.0,
      sunlight: 100.0,
      plantedDate: now,
      lastWatered: now,
      lastCared: now,
      careHistory: ['Plant ${habit.title} was planted in the garden'],
      daysAlive: 0,
      isAlive: true,
    );
  }

  String getPlantName() {
    switch (category) {
      case HabitCategory.health:
        return 'Health Tree';
      case HabitCategory.fitness:
        return 'Strength Oak';
      case HabitCategory.learning:
        return 'Wisdom Willow';
      case HabitCategory.productivity:
        return 'Productivity Pine';
      case HabitCategory.mindfulness:
        return 'Peace Lotus';
      case HabitCategory.social:
        return 'Friendship Flower';
      case HabitCategory.finance:
        return 'Prosperity Maple';
      case HabitCategory.creativity:
        return 'Creative Cherry';
      case HabitCategory.other:
        return 'Mystery Plant';
    }
  }

  String getPlantDescription() {
    switch (type) {
      case PlantType.seed:
        return 'A tiny seed full of potential';
      case PlantType.sprout:
        return 'Breaking through the soil';
      case PlantType.sapling:
        return 'Growing stronger each day';
      case PlantType.young:
        return 'Developing beautiful leaves';
      case PlantType.mature:
        return 'A strong, established plant';
      case PlantType.flowering:
        return 'Blooming with beauty';
      case PlantType.fruiting:
        return 'Bearing the fruits of your labor';
      case PlantType.ancient:
        return 'A legendary plant of wisdom';
    }
  }

  IconData getPlantIcon() {
    switch (type) {
      case PlantType.seed:
        return Icons.grain;
      case PlantType.sprout:
        return Icons.eco;
      case PlantType.sapling:
        return Icons.park;
      case PlantType.young:
        return Icons.local_florist;
      case PlantType.mature:
        return Icons.forest;
      case PlantType.flowering:
        return Icons.wb_sunny;
      case PlantType.fruiting:
        return Icons.apple;
      case PlantType.ancient:
        return Icons.auto_awesome;
    }
  }

  Color getPlantColor() {
    switch (health) {
      case PlantHealth.dead:
        return Colors.grey;
      case PlantHealth.wilted:
        return Colors.brown;
      case PlantHealth.struggling:
        return Colors.orange;
      case PlantHealth.healthy:
        return Colors.green;
      case PlantHealth.thriving:
        return Colors.lightGreen;
      case PlantHealth.vibrant:
        return Colors.lime;
      case PlantHealth.radiant:
        return Colors.yellow;
    }
  }

  GardenPlant water() {
    final now = DateTime.now();
    final newWater = (water + 30).clamp(0, 100);
    final newHealth = _calculateHealth(newWater, sunlight);
    
    return copyWith(
      water: newWater,
      health: newHealth,
      lastWatered: now,
      careHistory: [...careHistory, 'Plant was watered - ${now.toString().substring(0, 16)}'],
    );
  }

  GardenPlant care() {
    final now = DateTime.now();
    final newSunlight = (sunlight + 25).clamp(0, 100);
    final newHealth = _calculateHealth(water, newSunlight);
    
    return copyWith(
      sunlight: newSunlight,
      health: newHealth,
      lastCared: now,
      careHistory: [...careHistory, 'Plant was cared for - ${now.toString().substring(0, 16)}'],
    );
  }

  GardenPlant grow() {
    if (!isAlive) return this;
    
    final newGrowth = (growth + 5).clamp(0, 100);
    PlantType newType = type;
    
    // Determine new type based on growth
    if (newGrowth >= 90) {
      newType = PlantType.ancient;
    } else if (newGrowth >= 80) {
      newType = PlantType.fruiting;
    } else if (newGrowth >= 70) {
      newType = PlantType.flowering;
    } else if (newGrowth >= 60) {
      newType = PlantType.mature;
    } else if (newGrowth >= 40) {
      newType = PlantType.young;
    } else if (newGrowth >= 20) {
      newType = PlantType.sapling;
    } else if (newGrowth >= 10) {
      newType = PlantType.sprout;
    }
    
    return copyWith(
      growth: newGrowth,
      type: newType,
    );
  }

  GardenPlant dailyUpdate() {
    if (!isAlive) return this;
    
    final now = DateTime.now();
    final daysSinceWatered = now.difference(lastWatered).inDays;
    final daysSinceCared = now.difference(lastCared).inDays;
    
    // Decrease resources over time
    double newWater = water;
    double newSunlight = sunlight;
    
    if (daysSinceWatered > 0) {
      newWater = (water - (daysSinceWatered * 5)).clamp(0, 100);
    }
    
    if (daysSinceCared > 0) {
      newSunlight = (sunlight - (daysSinceCared * 3)).clamp(0, 100);
    }
    
    // Calculate new health
    final newHealth = _calculateHealth(newWater, newSunlight);
    
    // Check if plant dies
    bool newIsAlive = isAlive;
    if (newWater <= 0 || newSunlight <= 0) {
      newIsAlive = false;
    }
    
    return copyWith(
      water: newWater,
      sunlight: newSunlight,
      health: newHealth,
      isAlive: newIsAlive,
      daysAlive: daysAlive + 1,
    );
  }

  PlantHealth _calculateHealth(double waterLevel, double sunlightLevel) {
    final average = (waterLevel + sunlightLevel) / 2;
    
    if (average >= 90) return PlantHealth.radiant;
    if (average >= 80) return PlantHealth.vibrant;
    if (average >= 70) return PlantHealth.thriving;
    if (average >= 60) return PlantHealth.healthy;
    if (average >= 40) return PlantHealth.struggling;
    if (average >= 20) return PlantHealth.wilted;
    return PlantHealth.dead;
  }

  bool get needsWater => water < 50;
  bool get needsCare => sunlight < 50;
  bool get isThriving => health == PlantHealth.radiant || health == PlantHealth.vibrant;
  bool get isDying => health == PlantHealth.dead || health == PlantHealth.wilted;
}

class DigitalGarden {
  final String id;
  final String userId;
  final List<GardenPlant> plants;
  final DateTime createdAt;
  final int totalPlants;
  final int thrivingPlants;
  final int dyingPlants;
  final double overallHealth;
  final String gardenTheme;
  final List<String> decorations;

  DigitalGarden({
    required this.id,
    required this.userId,
    required this.plants,
    required this.createdAt,
    required this.totalPlants,
    required this.thrivingPlants,
    required this.dyingPlants,
    required this.overallHealth,
    required this.gardenTheme,
    required this.decorations,
  });

  DigitalGarden copyWith({
    String? id,
    String? userId,
    List<GardenPlant>? plants,
    DateTime? createdAt,
    int? totalPlants,
    int? thrivingPlants,
    int? dyingPlants,
    double? overallHealth,
    String? gardenTheme,
    List<String>? decorations,
  }) {
    return DigitalGarden(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plants: plants ?? this.plants,
      createdAt: createdAt ?? this.createdAt,
      totalPlants: totalPlants ?? this.totalPlants,
      thrivingPlants: thrivingPlants ?? this.thrivingPlants,
      dyingPlants: dyingPlants ?? this.dyingPlants,
      overallHealth: overallHealth ?? this.overallHealth,
      gardenTheme: gardenTheme ?? this.gardenTheme,
      decorations: decorations ?? this.decorations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'plants': plants.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'totalPlants': totalPlants,
      'thrivingPlants': thrivingPlants,
      'dyingPlants': dyingPlants,
      'overallHealth': overallHealth,
      'gardenTheme': gardenTheme,
      'decorations': decorations,
    };
  }

  factory DigitalGarden.fromJson(Map<String, dynamic> json) {
    return DigitalGarden(
      id: json['id'],
      userId: json['userId'],
      plants: (json['plants'] as List).map((p) => GardenPlant.fromJson(p)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      totalPlants: json['totalPlants'],
      thrivingPlants: json['thrivingPlants'],
      dyingPlants: json['dyingPlants'],
      overallHealth: json['overallHealth'].toDouble(),
      gardenTheme: json['gardenTheme'],
      decorations: List<String>.from(json['decorations']),
    );
  }

  factory DigitalGarden.createDefault(String userId) {
    return DigitalGarden(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      plants: [],
      createdAt: DateTime.now(),
      totalPlants: 0,
      thrivingPlants: 0,
      dyingPlants: 0,
      overallHealth: 100.0,
      gardenTheme: 'Enchanted Forest',
      decorations: ['Welcome Sign', 'Garden Path'],
    );
  }

  DigitalGarden addPlant(GardenPlant plant) {
    final newPlants = [...plants, plant];
    return _updateStats(newPlants);
  }

  DigitalGarden removePlant(String plantId) {
    final newPlants = plants.where((p) => p.id != plantId).toList();
    return _updateStats(newPlants);
  }

  DigitalGarden updatePlant(GardenPlant updatedPlant) {
    final newPlants = plants.map((p) => p.id == updatedPlant.id ? updatedPlant : p).toList();
    return _updateStats(newPlants);
  }

  DigitalGarden dailyUpdate() {
    final updatedPlants = plants.map((plant) => plant.dailyUpdate()).toList();
    return _updateStats(updatedPlants);
  }

  DigitalGarden _updateStats(List<GardenPlant> newPlants) {
    final total = newPlants.length;
    final thriving = newPlants.where((p) => p.isThriving).length;
    final dying = newPlants.where((p) => p.isDying).length;
    
    double overallHealth = 100.0;
    if (total > 0) {
      final totalHealth = newPlants.fold(0.0, (sum, plant) => sum + plant.health.index);
      overallHealth = (totalHealth / (total * PlantHealth.values.length)) * 100;
    }
    
    return copyWith(
      plants: newPlants,
      totalPlants: total,
      thrivingPlants: thriving,
      dyingPlants: dying,
      overallHealth: overallHealth,
    );
  }

  List<GardenPlant> getPlantsByCategory(HabitCategory category) {
    return plants.where((plant) => plant.category == category).toList();
  }

  List<GardenPlant> getPlantsNeedingCare() {
    return plants.where((plant) => plant.needsWater || plant.needsCare).toList();
  }

  List<GardenPlant> getThrivingPlants() {
    return plants.where((plant) => plant.isThriving).toList();
  }

  String getGardenStatus() {
    if (thrivingPlants >= totalPlants * 0.8) {
      return 'Your garden is flourishing! 🌸';
    } else if (thrivingPlants >= totalPlants * 0.6) {
      return 'Your garden is growing well! 🌱';
    } else if (thrivingPlants >= totalPlants * 0.4) {
      return 'Your garden needs some attention 🌿';
    } else if (thrivingPlants >= totalPlants * 0.2) {
      return 'Your garden is struggling 😔';
    } else {
      return 'Your garden needs immediate care! 🆘';
    }
  }
}
