import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/utils/app_theme.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  HabitCategory _selectedCategory = HabitCategory.health;
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  int _targetCount = 1;
  TimeOfDay? _reminderTime;
  Color _selectedColor = AppTheme.primaryColor;

  final List<Color> _colorOptions = [
    AppTheme.primaryColor,
    AppTheme.secondaryColor,
    AppTheme.accentColor,
    AppTheme.primaryColor,
    AppTheme.warningColor,
    AppTheme.successColor,
    Colors.purple,
    Colors.teal,
    Colors.orange,
    Colors.pink,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 24),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildCategorySection(),
              const SizedBox(height: 24),
              _buildFrequencySection(),
              const SizedBox(height: 24),
              _buildTargetCountSection(),
              const SizedBox(height: 24),
              _buildReminderSection(),
              const SizedBox(height: 24),
              _buildColorSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habit Title',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'e.g., Morning Exercise, Read Books',
            prefixIcon: Icon(Icons.edit),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a habit title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Describe your habit in detail...',
            prefixIcon: Icon(Icons.description),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: HabitCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Habit.getCategoryIcon(category),
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(Habit.getCategoryName(category)),
                ],
              ),
              selected: isSelected,
              selectedColor: AppTheme.primaryColor,
              backgroundColor: Colors.grey[200],
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: HabitFrequency.values.map((frequency) {
            final isSelected = _selectedFrequency == frequency;
            return ChoiceChip(
              label: Text(Habit.getFrequencyName(frequency)),
              selected: isSelected,
              selectedColor: AppTheme.secondaryColor,
              backgroundColor: Colors.grey[200],
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFrequency = frequency;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTargetCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Count',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_targetCount > 1) {
                  setState(() {
                    _targetCount--;
                  });
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
              color: AppTheme.primaryColor,
            ),
            Expanded(
              child: Text(
                '$_targetCount',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _targetCount++;
                });
              },
              icon: const Icon(Icons.add_circle_outline),
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Reminder (Optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.access_time,
            color: _reminderTime != null ? AppTheme.primaryColor : Colors.grey,
          ),
          title: Text(
            _reminderTime != null
                ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                : 'Set reminder time',
            style: TextStyle(
              color: _reminderTime != null ? AppTheme.primaryColor : Colors.grey,
            ),
          ),
          trailing: _reminderTime != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _reminderTime = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  color: Colors.grey,
                )
              : null,
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              setState(() {
                _reminderTime = time;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Color',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colorOptions.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Create Habit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        targetCount: _targetCount,
        reminderTime: _reminderTime,
        color: _selectedColor,
        createdAt: DateTime.now(),
      );

      context.read<HabitProvider>().addHabit(habit);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit "${habit.title}" created successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}
