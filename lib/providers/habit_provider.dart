import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Habit> _filteredHabits = [];
  HabitCategory? _selectedCategory;
  String _searchQuery = '';

  List<Habit> get habits => _habits;
  List<Habit> get filteredHabits => _filteredHabits;
  HabitCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  HabitProvider() {
    _loadHabits();
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
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading habits: $e');
    }
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
    notifyListeners();
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _saveHabits();
      _applyFilters();
      notifyListeners();
    }
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((habit) => habit.id == habitId);
    await _saveHabits();
    _applyFilters();
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
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
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

  // Get today's habits
  List<Habit> getTodayHabits() {
    return _habits.where((habit) => !habit.isCompletedToday()).toList();
  }

  // Get completed habits for today
  List<Habit> getCompletedTodayHabits() {
    return _habits.where((habit) => habit.isCompletedToday()).toList();
  }

  // Get habit statistics
  Map<String, dynamic> getStatistics() {
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
    
    return {
      'totalHabits': totalHabits,
      'completedToday': completedToday,
      'pendingToday': pendingToday,
      'overallCompletionRate': overallCompletionRate,
      'totalStreaks': totalStreaks,
      'longestStreak': longestStreak,
    };
  }

  // Clear all data
  Future<void> clearAllData() async {
    _habits.clear();
    _filteredHabits.clear();
    await _saveHabits();
    notifyListeners();
  }
}
