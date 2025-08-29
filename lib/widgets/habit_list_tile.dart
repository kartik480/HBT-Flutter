import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class HabitListTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final bool showCompleteButton;
  final bool isCompleted;

  const HabitListTile({
    super.key,
    required this.habit,
    this.onTap,
    this.onComplete,
    this.showCompleteButton = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildCategoryIcon(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildHabitInfo(),
                  ),
                  if (showCompleteButton) ...[
                    const SizedBox(width: 16),
                    _buildCompleteButton(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getCategoryGradient(habit.category)),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _getCategoryGradient(habit.category).first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        _getCategoryIcon(habit.category),
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildHabitInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          habit.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          habit.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildStreakBadge(),
            const SizedBox(width: 8),
            _buildFrequencyBadge(),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.forestGradient.first.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.forestGradient.first.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Text(
        'Streak: ${habit.currentStreak}',
        style: TextStyle(
          color: AppTheme.forestGradient.first,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFrequencyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.auroraGradient.first.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.auroraGradient.first.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Text(
        Habit.getFrequencyName(habit.frequency),
        style: TextStyle(
          color: AppTheme.auroraGradient.first,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.fireGradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.fireGradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onComplete,
        icon: Icon(
          isCompleted ? Icons.check_circle : Icons.check,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  List<Color> _getCategoryGradient(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return AppTheme.fireGradient;
      case HabitCategory.fitness:
        return AppTheme.forestGradient;
      case HabitCategory.learning:
        return AppTheme.auroraGradient;
      case HabitCategory.productivity:
        return AppTheme.oceanGradient;
      case HabitCategory.mindfulness:
        return AppTheme.cosmicGradient;
      case HabitCategory.social:
        return AppTheme.sunsetGradient;
      case HabitCategory.finance:
        return AppTheme.springGradient;
      case HabitCategory.creativity:
        return AppTheme.autumnGradient;
      case HabitCategory.other:
        return AppTheme.winterGradient;
    }
  }

  IconData _getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.learning:
        return Icons.school;
      case HabitCategory.productivity:
        return Icons.work;
      case HabitCategory.mindfulness:
        return Icons.self_improvement;
      case HabitCategory.social:
        return Icons.people;
      case HabitCategory.finance:
        return Icons.account_balance_wallet;
      case HabitCategory.creativity:
        return Icons.brush;
      case HabitCategory.other:
        return Icons.star;
    }
  }
}
