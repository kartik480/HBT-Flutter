import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/screens/add_reminder_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.auroraGradient,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHabitHeader(),
                    const SizedBox(height: 24),
                    _buildHabitInfo(),
                    const SizedBox(height: 24),
                    _buildProgressSection(),
                    const SizedBox(height: 24),
                    _buildHistorySection(),
                    const SizedBox(height: 24),
                    _buildActionsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppTheme.midnightGradient),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.midnightGradient.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.fireGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.fireGradient.first.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _editHabit(),
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Habit',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.errorGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.errorGradient.first.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _deleteHabit(),
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete Habit',
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.habit.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getCategoryGradient(widget.habit.category)),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getCategoryGradient(widget.habit.category).first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getCategoryIcon(widget.habit.category),
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.habit.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.habit.description.isNotEmpty 
                      ? widget.habit.description 
                      : 'No description provided',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _getCategoryName(widget.habit.category),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        Habit.getFrequencyName(widget.habit.frequency),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habit Information',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Created', _formatDate(widget.habit.createdAt)),
          _buildInfoRow('Target Count', '${widget.habit.targetCount} per ${Habit.getFrequencyName(widget.habit.frequency).toLowerCase()}'),
          if (widget.habit.reminderTime != null)
            _buildInfoRow('Reminder', _formatTime(widget.habit.reminderTime!)),
          _buildInfoRow('Total Completions', '${widget.habit.totalCompletions}'),
          _buildInfoRow('Current Streak', '${widget.habit.currentStreak} days'),
          _buildInfoRow('Longest Streak', '${widget.habit.longestStreak} days'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final totalHabits = 1; // Single habit
    final completedToday = widget.habit.isCompletedToday() ? 1 : 0;
    final progress = completedToday / totalHabits;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.midnightGradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.midnightGradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.fireGradient),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Today\'s Progress',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.forestGradient.first,
            ),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ${widget.habit.isCompletedToday() ? "Completed" : "Pending"}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    final completionHistory = widget.habit.completionHistory.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completion History',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (completionHistory.isEmpty)
            Text(
              'No completions yet. Start building your streak!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Column(
              children: completionHistory.take(10).map((entry) {
                final isToday = _isToday(entry.key);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: entry.value 
                        ? AppTheme.forestGradient.first.withOpacity(0.2)
                        : AppTheme.errorGradient.first.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: entry.value 
                          ? AppTheme.forestGradient.first.withOpacity(0.4)
                          : AppTheme.errorGradient.first.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        entry.value ? Icons.check_circle : Icons.cancel,
                        color: entry.value 
                            ? AppTheme.forestGradient.first
                            : AppTheme.errorGradient.first,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDate(entry.key),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (isToday)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.fireGradient.first.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'TODAY',
                            style: TextStyle(
                              color: AppTheme.fireGradient.first,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        if (!widget.habit.isCompletedToday())
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.forestGradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.forestGradient.first.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _completeHabit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Mark as Completed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.habit.isCompletedToday()) ...[
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.errorGradient),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.errorGradient.first.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _uncompleteHabit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Mark as Incomplete',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.cosmicGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cosmicGradient.first.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _addReminder(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, size: 24),
                SizedBox(width: 8),
                Text(
                  'Add Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.oceanGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.oceanGradient.first.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _editHabit(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 24),
                SizedBox(width: 8),
                Text(
                  'Edit Habit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  String _getCategoryName(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return 'Health & Wellness';
      case HabitCategory.fitness:
        return 'Fitness & Exercise';
      case HabitCategory.learning:
        return 'Learning & Education';
      case HabitCategory.productivity:
        return 'Productivity & Work';
      case HabitCategory.mindfulness:
        return 'Mindfulness & Spirituality';
      case HabitCategory.social:
        return 'Social & Relationships';
      case HabitCategory.finance:
        return 'Finance & Money';
      case HabitCategory.creativity:
        return 'Creativity & Arts';
      case HabitCategory.other:
        return 'Other';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  void _completeHabit() {
    final habitProvider = context.read<HabitProvider>();
    habitProvider.markHabitCompleted(widget.habit.id, DateTime.now());
    
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.habit.title} completed! 🎉'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _uncompleteHabit() {
    final habitProvider = context.read<HabitProvider>();
    habitProvider.markHabitIncomplete(widget.habit.id, DateTime.now());
    
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.habit.title} marked as incomplete'),
        backgroundColor: AppTheme.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _editHabit() {
    // Navigate to edit screen (you can implement this later)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit feature coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _addReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(
          habitId: widget.habit.id,
          habitTitle: widget.habit.title,
        ),
      ),
    );
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightGradient.first,
        title: const Text(
          'Delete Habit',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.habit.title}"? This action cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final habitProvider = context.read<HabitProvider>();
              habitProvider.deleteHabit(widget.habit.id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.habit.title} deleted'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorGradient.first),
            ),
          ),
        ],
      ),
    );
  }
}
