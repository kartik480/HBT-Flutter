import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/reminder_provider.dart';
import 'package:habit_tracker/models/reminder.dart';
import 'package:habit_tracker/screens/add_reminder_screen.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize reminders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().initialize();
    });
  }

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
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Text(
              'Reminders',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _showTestNotification,
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            tooltip: 'Test Notification',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        if (reminderProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (reminderProvider.reminders.isEmpty) {
          return _buildEmptyState();
        }

        return _buildRemindersList(reminderProvider);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.cosmicGradient),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Reminders Yet!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first reminder to stay on track with your habits',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(ReminderProvider reminderProvider) {
    final reminders = reminderProvider.allReminders;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _buildReminderCard(reminder, reminderProvider);
      },
    );
  }

  Widget _buildReminderCard(Reminder reminder, ReminderProvider reminderProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _editReminder(reminder),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: AppTheme.fireGradient),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        reminder.isActive ? Icons.notifications_active : Icons.notifications_off,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            reminder.message,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusIndicator(reminder),
                  ],
                ),
                const SizedBox(height: 16),
                _buildReminderDetails(reminder),
                const SizedBox(height: 16),
                _buildActionButtons(reminder, reminderProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Reminder reminder) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: reminder.isActive
            ? LinearGradient(colors: AppTheme.forestGradient)
            : LinearGradient(colors: AppTheme.winterGradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        reminder.isActive ? 'Active' : 'Inactive',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReminderDetails(Reminder reminder) {
    final daysText = _getDaysText(reminder.daysOfWeek);
            final timeText = '${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')}';
    
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            Icons.access_time,
            'Time',
            timeText,
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.calendar_today,
            'Days',
            daysText,
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            Icons.repeat,
            'Frequency',
            _getFrequencyText(reminder.frequency),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(Reminder reminder, ReminderProvider reminderProvider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _editReminder(reminder),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.oceanGradient.first,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _toggleReminder(reminder, reminderProvider),
            icon: Icon(
              reminder.isActive ? Icons.pause : Icons.play_arrow,
              size: 18,
            ),
            label: Text(reminder.isActive ? 'Pause' : 'Resume'),
            style: ElevatedButton.styleFrom(
              backgroundColor: reminder.isActive
                  ? AppTheme.sunsetGradient.first
                  : AppTheme.forestGradient.first,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _deleteReminder(reminder, reminderProvider),
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.fireGradient),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.fireGradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _addNewReminder,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Reminder',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _getDaysText(List<int> days) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDays = days.map((day) => dayNames[day - 1]).toList();
    
    if (selectedDays.length == 7) return 'Every day';
    if (selectedDays.length == 5 && 
        days.contains(1) && days.contains(2) && days.contains(3) && 
        days.contains(4) && days.contains(5)) return 'Weekdays';
    if (selectedDays.length == 2 && 
        days.contains(6) && days.contains(7)) return 'Weekends';
    
    return selectedDays.join(', ');
  }

  String _getFrequencyText(ReminderFrequency frequency) {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }

  void _addNewReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddReminderScreen(
          habitId: 'general',
          habitTitle: 'General',
        ),
      ),
    );
  }

  void _editReminder(Reminder reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderScreen(
          habitId: reminder.habitId,
          habitTitle: reminder.title.replaceAll(' Reminder', ''),
          reminder: reminder,
        ),
      ),
    );
  }

  Future<void> _toggleReminder(Reminder reminder, ReminderProvider reminderProvider) async {
    await reminderProvider.toggleReminder(reminder.id, !reminder.isActive);
  }

  Future<void> _deleteReminder(Reminder reminder, ReminderProvider reminderProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.midnightGradient.first,
        title: const Text(
          'Delete Reminder',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${reminder.title}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await reminderProvider.deleteReminder(reminder.id);
    }
  }

  void _showTestNotification() {
    final reminderProvider = context.read<ReminderProvider>();
    reminderProvider.showTestNotification(context, 'This is a test notification from your habit tracker!');
  }
}
