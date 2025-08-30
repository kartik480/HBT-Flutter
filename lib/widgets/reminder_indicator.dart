import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/reminder_provider.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class ReminderIndicator extends StatelessWidget {
  final String habitId;
  final double size;

  const ReminderIndicator({
    super.key,
    required this.habitId,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        final reminders = reminderProvider.getRemindersForHabit(habitId);
        final activeReminders = reminders.where((r) => r.isActive).toList();
        
        if (activeReminders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.fireGradient),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.fireGradient.first.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: size * 0.6,
          ),
        );
      },
    );
  }
}
