import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habit_tracker/models/habit.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<HabitProvider>(
          builder: (context, habitProvider, child) {
            final stats = habitProvider.getStatistics();
            final habits = habitProvider.habits;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(stats),
                const SizedBox(height: 24),
                _buildCompletionChart(habits),
                const SizedBox(height: 24),
                _buildCategoryBreakdown(habits),
                const SizedBox(height: 24),
                _buildTopHabits(habits),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverviewCards(Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Habits',
                stats['totalHabits'].toString(),
                Icons.list_alt,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Today\'s Progress',
                '${stats['completedToday']}/${stats['totalHabits']}',
                Icons.today,
                AppTheme.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Completion Rate',
                '${(stats['overallCompletionRate'] * 100).toInt()}%',
                Icons.trending_up,
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Longest Streak',
                stats['longestStreak'].toString(),
                Icons.local_fire_department,
                AppTheme.accentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionChart(List<Habit> habits) {
    if (habits.isEmpty) {
      return _buildEmptyState('No habits to display');
    }

    final completionData = habits.map((habit) {
      return PieChartSectionData(
        color: (habit as Habit).color,
        value: (habit as Habit).getCompletionRate() * 100,
        title: '${((habit as Habit).getCompletionRate() * 100).toInt()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Rates',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: completionData,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(habits),
      ],
    );
  }

  Widget _buildLegend(List<Habit> habits) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
              children: habits.map((habit) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: (habit as Habit).color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                (habit as Habit).title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          );
        }).toList(),
    );
  }

  Widget _buildCategoryBreakdown(List<Habit> habits) {
    if (habits.isEmpty) {
      return _buildEmptyState('No habits to display');
    }

    final categoryStats = <HabitCategory, int>{};
    for (final habit in habits) {
      categoryStats[habit.category] = (categoryStats[habit.category] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...categoryStats.entries.map((entry) {
          final category = entry.key;
          final count = entry.value;
          final percentage = (count / habits.length * 100).toInt();
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Icon(
                  Habit.getCategoryIcon(category),
                  color: AppTheme.primaryColor,
                ),
              ),
              title: Text(Habit.getCategoryName(category)),
              subtitle: LinearProgressIndicator(
                value: count / habits.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
              trailing: Text(
                '$count ($percentage%)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTopHabits(List<Habit> habits) {
    if (habits.isEmpty) {
      return _buildEmptyState('No habits to display');
    }

    final sortedHabits = List<Habit>.from(habits)
      ..sort((a, b) => (b as Habit).currentStreak.compareTo((a as Habit).currentStreak));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Performing Habits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...sortedHabits.take(5).map((habit) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (habit as Habit).color.withOpacity(0.1),
                child: Icon(
                  Habit.getCategoryIcon((habit as Habit).category),
                  color: (habit as Habit).color,
                ),
              ),
              title: Text((habit as Habit).title),
              subtitle: Text(
                '${(habit as Habit).currentStreak} day streak • ${(habit as Habit).totalCompletions} total',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(habit as Habit).currentStreak}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
