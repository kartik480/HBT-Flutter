import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'dart:ui';

class CategoryFilter extends StatelessWidget {
  final HabitCategory? selectedCategory;
  final Function(HabitCategory?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: selectedCategory == null,
            gradient: AppTheme.auroraGradient,
            onTap: () => onCategorySelected(null),
          ),
          ...HabitCategory.values.map((category) => _buildFilterChip(
            label: Habit.getCategoryName(category),
            isSelected: selectedCategory == category,
            gradient: _getCategoryGradient(category),
            onTap: () => onCategorySelected(category),
          )),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: isSelected ? LinearGradient(colors: gradient) : null,
        color: isSelected ? null : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: gradient.first.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
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
}
