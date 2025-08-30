import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/reminder_provider.dart';
import 'package:habit_tracker/models/reminder.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddReminderScreen extends StatefulWidget {
  final String habitId;
  final String habitTitle;
  final Reminder? reminder; // If provided, we're editing an existing reminder

  const AddReminderScreen({
    super.key,
    required this.habitId,
    required this.habitTitle,
    this.reminder,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  int _selectedHour = 9;
  int _selectedMinute = 0;
  List<int> _selectedDays = [1, 2, 3, 4, 5]; // Monday to Friday by default
  ReminderFrequency _frequency = ReminderFrequency.daily;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      // Editing existing reminder
      _titleController.text = widget.reminder!.title;
      _messageController.text = widget.reminder!.message;
      _selectedHour = widget.reminder!.hour;
      _selectedMinute = widget.reminder!.minute;
      _selectedDays = List.from(widget.reminder!.daysOfWeek);
      _frequency = widget.reminder!.frequency;
      _isActive = widget.reminder!.isActive;
    } else {
      // Creating new reminder
      _titleController.text = '${widget.habitTitle} Reminder';
      _messageController.text = 'Time to work on ${widget.habitTitle}!';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
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
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
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
              widget.reminder != null ? 'Edit Reminder' : 'Add Reminder',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _saveReminder,
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTitleField(),
            const SizedBox(height: 20),
            _buildMessageField(),
            const SizedBox(height: 20),
            _buildTimeSelector(),
            const SizedBox(height: 20),
            _buildDaySelector(),
            const SizedBox(height: 20),
            _buildFrequencySelector(),
            const SizedBox(height: 20),
            _buildActiveToggle(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Reminder Title',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      style: const TextStyle(color: Colors.white),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Reminder Message',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a message';
        }
        return null;
      },
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Time',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _selectTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.fireGradient.first,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Change Time'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = [
      {'value': 1, 'label': 'Mon'},
      {'value': 2, 'label': 'Tue'},
      {'value': 3, 'label': 'Wed'},
      {'value': 4, 'label': 'Thu'},
      {'value': 5, 'label': 'Fri'},
      {'value': 6, 'label': 'Sat'},
      {'value': 7, 'label': 'Sun'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Days of Week',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: days.map((day) {
              final isSelected = _selectedDays.contains(day['value'] as int);
              return GestureDetector(
                onTap: () => _toggleDay(day['value'] as int),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: AppTheme.fireGradient)
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequency',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ReminderFrequency>(
            value: _frequency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _frequency = value;
                });
              }
            },
            dropdownColor: AppTheme.midnightGradient.first,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
            ),
            items: ReminderFrequency.values.map((frequency) {
              return DropdownMenuItem(
                value: frequency,
                child: Text(_getFrequencyText(frequency)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Active',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
            activeColor: AppTheme.forestGradient.first,
            activeTrackColor: AppTheme.forestGradient.first.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveReminder,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.fireGradient.first,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        widget.reminder != null ? 'Update Reminder' : 'Create Reminder',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedHour = time.hour;
        _selectedMinute = time.minute;
      });
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _selectedDays.sort();
    });
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

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day of the week'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reminderProvider = context.read<ReminderProvider>();
    
    try {
      final reminder = Reminder(
        id: widget.reminder?.id ?? const Uuid().v4(),
        habitId: widget.habitId,
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        hour: _selectedHour,
        minute: _selectedMinute,
        daysOfWeek: _selectedDays,
        frequency: _frequency,
        isActive: _isActive,
        createdAt: widget.reminder?.createdAt ?? DateTime.now(),
        lastTriggered: widget.reminder?.lastTriggered,
      );

      bool success;
      if (widget.reminder != null) {
        success = await reminderProvider.updateReminder(reminder);
      } else {
        success = await reminderProvider.addReminder(reminder);
      }

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.reminder != null
                  ? 'Reminder updated successfully!'
                  : 'Reminder created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save reminder. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
