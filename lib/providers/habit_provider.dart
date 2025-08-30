import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Habit> _filteredHabits = [];
  HabitCategory? _selectedCategory;
  String _searchQuery = '';
  
  // Cache expensive computations
  Map<String, dynamic>? _cachedStatistics;
  List<Habit>? _cachedTodayHabits;
  List<Habit>? _cachedCompletedTodayHabits;
  DateTime _lastStatisticsUpdate = DateTime.now();
  DateTime _lastTodayUpdate = DateTime.now();

  List<Habit> get habits => _habits;
  List<Habit> get filteredHabits => _filteredHabits;
  HabitCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  HabitProvider() {
    _loadHabits().then((_) {
      // Add sample habits if none exist
      if (_habits.isEmpty) {
        addSampleHabits();
      }
    });
  }

  // Load habits from SharedPreferences
  Future<void> _loadHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList('habits') ?? [];
      
      _habits = habitsJson
          .map((habitJson) => Habit.fromJson(json.decode(habitJson)))
          .toList();
      
      _applyFilters();
      _clearCache(); // Clear cache when habits change
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading habits: $e');
    }
  }

  // Clear cached data
  void _clearCache() {
    _cachedStatistics = null;
    _cachedTodayHabits = null;
    _cachedCompletedTodayHabits = null;
    _lastStatisticsUpdate = DateTime.now();
    _lastTodayUpdate = DateTime.now();
  }

  // Save habits to SharedPreferences
  Future<void> _saveHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = _habits
          .map((habit) => json.encode(habit.toJson()))
          .toList();
      
      await prefs.setStringList('habits', habitsJson);
    } catch (e) {
      debugPrint('Error saving habits: $e');
    }
  }

  // Add a new habit
  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _saveHabits();
    _applyFilters();
    _clearCache(); // Clear cache when habits change
    notifyListeners();
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _saveHabits();
      _applyFilters();
      _clearCache(); // Clear cache when habits change
      notifyListeners();
    }
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((habit) => habit.id == habitId);
    await _saveHabits();
    _applyFilters();
    _clearCache(); // Clear cache when habits change
    notifyListeners();
  }

  // Mark habit as completed for a specific date
  Future<void> markHabitCompleted(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final habit = _habits[index];
      habit.markCompleted(date);
      
      // Update streaks
      _updateStreaks(habit);
      
      await _saveHabits();
      _applyFilters();
      _clearCache(); // Clear cache when habits change
      notifyListeners();
    }
  }

  // Mark habit as incomplete for a specific date
  Future<void> markHabitIncomplete(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index != -1) {
      final habit = _habits[index];
      habit.markIncomplete(date);
      
      // Update streaks
      _updateStreaks(habit);
      
      await _saveHabits();
      _applyFilters();
      _clearCache(); // Clear cache when habits change
      notifyListeners();
    }
  }

  // Update streaks for a habit
  void _updateStreaks(Habit habit) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    
    // Calculate current streak
    int currentStreak = 0;
    DateTime currentDate = todayKey;
    
    while (habit.completionHistory[currentDate] == true) {
      currentStreak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    
    // Update habit with new streak data
    final updatedHabit = habit.copyWith(
      currentStreak: currentStreak,
      longestStreak: currentStreak > habit.longestStreak ? currentStreak : habit.longestStreak,
      totalCompletions: habit.completionHistory.values.where((completed) => completed).length,
    );
    
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
    }
  }

  // Set category filter
  void setCategoryFilter(HabitCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      _applyFilters();
      notifyListeners();
    }
  }

  // Set search query
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _applyFilters();
      notifyListeners();
    }
  }

  // Apply filters to habits
  void _applyFilters() {
    _filteredHabits = _habits.where((habit) {
      // Category filter
      if (_selectedCategory != null && habit.category != _selectedCategory) {
        return false;
      }
      
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return habit.title.toLowerCase().contains(query) ||
               habit.description.toLowerCase().contains(query);
      }
      
      return true;
    }).toList();
    
    // Sort by creation date (newest first)
    _filteredHabits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get habits by category
  List<Habit> getHabitsByCategory(HabitCategory category) {
    return _habits.where((habit) => habit.category == category).toList();
  }

  // Get today's habits with caching
  List<Habit> getTodayHabits() {
    final now = DateTime.now();
    if (_cachedTodayHabits != null && 
        _lastTodayUpdate.day == now.day && 
        _lastTodayUpdate.month == now.month && 
        _lastTodayUpdate.year == now.year) {
      return _cachedTodayHabits!;
    }
    
    _cachedTodayHabits = _habits.where((habit) => !habit.isCompletedToday()).toList();
    _lastTodayUpdate = now;
    return _cachedTodayHabits!;
  }

  // Get completed habits for today with caching
  List<Habit> getCompletedTodayHabits() {
    final now = DateTime.now();
    if (_cachedCompletedTodayHabits != null && 
        _lastTodayUpdate.day == now.day && 
        _lastTodayUpdate.month == now.month && 
        _lastTodayUpdate.year == now.year) {
      return _cachedCompletedTodayHabits!;
    }
    
    _cachedCompletedTodayHabits = _habits.where((habit) => habit.isCompletedToday()).toList();
    _lastTodayUpdate = now;
    return _cachedCompletedTodayHabits!;
  }

  // Get habit statistics with caching
  Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    if (_cachedStatistics != null && 
        _lastStatisticsUpdate.day == now.day && 
        _lastStatisticsUpdate.month == now.month && 
        _lastStatisticsUpdate.year == now.year) {
      return _cachedStatistics!;
    }
    
    final totalHabits = _habits.length;
    final completedToday = getCompletedTodayHabits().length;
    final pendingToday = getTodayHabits().length;
    
    double overallCompletionRate = 0.0;
    if (_habits.isNotEmpty) {
      final totalCompletions = _habits.fold(0.0, (sum, habit) => sum + habit.getCompletionRate());
      overallCompletionRate = totalCompletions / _habits.length;
    }
    
    final totalStreaks = _habits.fold(0, (sum, habit) => sum + habit.currentStreak);
    final longestStreak = _habits.fold(0, (max, habit) => 
        habit.longestStreak > max ? habit.longestStreak : max);
    
    _cachedStatistics = {
      'totalHabits': totalHabits,
      'completedToday': completedToday,
      'pendingToday': pendingToday,
      'overallCompletionRate': overallCompletionRate,
      'totalStreaks': totalStreaks,
      'longestStreak': longestStreak,
    };
    
    _lastStatisticsUpdate = now;
    return _cachedStatistics!;
  }

  // Clear all data
  Future<void> clearAllData() async {
    _habits.clear();
    _filteredHabits.clear();
    _clearCache();
    await _saveHabits();
    notifyListeners();
  }

  // Add sample habits for demonstration
  Future<void> addSampleHabits() async {
    if (_habits.isNotEmpty) return; // Only add if no habits exist
    
    final sampleHabits = [
      Habit(
        id: 'sample_1',
        title: 'Morning Exercise',
        description: 'Start the day with 30 minutes of exercise',
        category: HabitCategory.fitness,
        frequency: HabitFrequency.daily,
        targetCount: 1,
        reminderTime: const TimeOfDay(hour: 8, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        currentStreak: 5,
        longestStreak: 12,
        color: Colors.blue,
        completionHistory: {
          DateTime.now().subtract(const Duration(days: 1)): true,
          DateTime.now().subtract(const Duration(days: 2)): true,
          DateTime.now().subtract(const Duration(days: 3)): true,
          DateTime.now().subtract(const Duration(days: 4)): true,
          DateTime.now().subtract(const Duration(days: 5)): true,
        },
      ),
      Habit(
        id: 'sample_2',
        title: 'Read 20 Pages',
        description: 'Read at least 20 pages of a book daily',
        category: HabitCategory.learning,
        frequency: HabitFrequency.daily,
        targetCount: 20,
        reminderTime: const TimeOfDay(hour: 21, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        currentStreak: 8,
        longestStreak: 25,
        color: Colors.green,
        completionHistory: {
          DateTime.now().subtract(const Duration(days: 1)): true,
          DateTime.now().subtract(const Duration(days: 2)): true,
          DateTime.now().subtract(const Duration(days: 3)): true,
          DateTime.now().subtract(const Duration(days: 4)): true,
          DateTime.now().subtract(const Duration(days: 5)): true,
          DateTime.now().subtract(const Duration(days: 6)): true,
          DateTime.now().subtract(const Duration(days: 7)): true,
          DateTime.now().subtract(const Duration(days: 8)): true,
        },
      ),
      Habit(
        id: 'sample_3',
        title: 'Drink 8 Glasses of Water',
        description: 'Stay hydrated by drinking 8 glasses of water',
        category: HabitCategory.health,
        frequency: HabitFrequency.daily,
        targetCount: 8,
        reminderTime: const TimeOfDay(hour: 18, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        currentStreak: 2,
        longestStreak: 2,
        color: Colors.red,
        completionHistory: {
          DateTime.now().subtract(const Duration(days: 1)): true,
          DateTime.now().subtract(const Duration(days: 2)): true,
        },
      ),
      Habit(
        id: 'sample_4',
        title: 'Practice Guitar',
        description: 'Practice guitar for 30 minutes',
        category: HabitCategory.creativity,
        frequency: HabitFrequency.weekly,
        targetCount: 30,
        reminderTime: const TimeOfDay(hour: 19, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 21)),
        currentStreak: 3,
        longestStreak: 8,
        color: Colors.purple,
        completionHistory: {
          DateTime.now().subtract(const Duration(days: 7)): true,
          DateTime.now().subtract(const Duration(days: 14)): true,
          DateTime.now().subtract(const Duration(days: 21)): true,
        },
      ),
      Habit(
        id: 'sample_5',
        title: 'Meditation',
        description: 'Practice mindfulness meditation for 15 minutes',
        category: HabitCategory.mindfulness,
        frequency: HabitFrequency.daily,
        targetCount: 15,
        reminderTime: const TimeOfDay(hour: 7, minute: 0),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        currentStreak: 3,
        longestStreak: 15,
        color: Colors.orange,
        completionHistory: {
          DateTime.now().subtract(const Duration(days: 1)): true,
          DateTime.now().subtract(const Duration(days: 2)): true,
          DateTime.now().subtract(const Duration(days: 3)): true,
        },
      ),
    ];
    
    for (final habit in sampleHabits) {
      _habits.add(habit);
    }
    
    await _saveHabits();
    _applyFilters();
    _clearCache();
    notifyListeners();
  }
}
