import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_theme.dart';
import 'reminder_indicator.dart';

class HabitListBox extends StatefulWidget {
  final String title;
  final List<Habit> habits;
  final bool showActions;
  final bool showEmptyState;
  final VoidCallback? onEmptyStateAction;
  final String emptyStateMessage;
  final String emptyStateActionText;
  final List<Color>? headerGradient;
  final bool showHeader;
  final bool showSearch;
  final bool showCategoryFilter;
  final bool showSortOptions;
  final bool showGroupByCategory;
  final Function(Habit)? onHabitTap;
  final Function(Habit)? onHabitComplete;

  const HabitListBox({
    super.key,
    required this.title,
    required this.habits,
    this.showActions = true,
    this.showEmptyState = true,
    this.onEmptyStateAction,
    this.emptyStateMessage = 'No habits found',
    this.emptyStateActionText = 'Add Habit',
    this.headerGradient,
    this.showHeader = true,
    this.showSearch = false,
    this.showCategoryFilter = false,
    this.showSortOptions = false,
    this.showGroupByCategory = false,
    this.onHabitTap,
    this.onHabitComplete,
  });

  @override
  State<HabitListBox> createState() => _HabitListBoxState();
}

class _HabitListBoxState extends State<HabitListBox> {
  String _searchQuery = '';
  HabitCategory? _selectedCategory;
  String _sortBy = 'name';
  bool _sortAscending = true;
  bool _groupByCategory = false;

  @override
  void initState() {
    super.initState();
    _groupByCategory = widget.showGroupByCategory;
  }

  List<Habit> get _filteredHabits {
    List<Habit> habits = widget.habits;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      habits = habits.where((habit) =>
        habit.title.toLowerCase().contains(query) ||
        habit.description.toLowerCase().contains(query)
      ).toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      habits = habits.where((habit) => habit.category == _selectedCategory).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name':
        habits.sort((a, b) => _sortAscending 
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
        break;
      case 'date':
        habits.sort((a, b) => _sortAscending 
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt));
        break;
      case 'streak':
        habits.sort((a, b) => _sortAscending 
          ? a.currentStreak.compareTo(b.currentStreak)
          : b.currentStreak.compareTo(a.currentStreak));
        break;
      case 'category':
        habits.sort((a, b) => _sortAscending 
          ? a.category.name.compareTo(b.category.name)
          : b.category.name.compareTo(a.category.name));
        break;
    }

    return habits;
  }

  Map<HabitCategory, List<Habit>> get _groupedHabits {
    final grouped = <HabitCategory, List<Habit>>{};
    for (final habit in _filteredHabits) {
      grouped.putIfAbsent(habit.category, () => []).add(habit);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.headerGradient ?? AppTheme.midnightGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (widget.headerGradient ?? AppTheme.midnightGradient).first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.showHeader) _buildHeader(),
          if (widget.showSearch || widget.showCategoryFilter || widget.showSortOptions)
            _buildControls(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.fireGradient),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.fireGradient.first.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.list_alt,
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
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${_filteredHabits.length} habits',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (widget.showGroupByCategory)
            IconButton(
              onPressed: () {
                setState(() {
                  _groupByCategory = !_groupByCategory;
                });
              },
              icon: Icon(
                _groupByCategory ? Icons.view_list : Icons.category,
                color: Colors.white,
                size: 24,
              ),
              tooltip: _groupByCategory ? 'Show as list' : 'Group by category',
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (widget.showSearch) ...[
            _buildSearchBar(),
            const SizedBox(height: 16),
          ],
          if (widget.showCategoryFilter) ...[
            _buildCategoryFilter(),
            const SizedBox(height: 16),
          ],
          if (widget.showSortOptions) _buildSortOptions(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search habits...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Row(
      children: [
        Text(
          'Category:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(null, 'All'),
                const SizedBox(width: 8),
                ...HabitCategory.values.map((category) => 
                  _buildCategoryChip(category, _getCategoryName(category))
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(HabitCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected 
            ? LinearGradient(colors: AppTheme.fireGradient)
            : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected 
              ? Colors.transparent
              : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Row(
      children: [
        Text(
          'Sort by:',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButton<String>(
            value: _sortBy,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _sortBy = value;
                });
              }
            },
            dropdownColor: AppTheme.midnightGradient.first,
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: [
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'date', child: Text('Date')),
              DropdownMenuItem(value: 'streak', child: Text('Streak')),
              DropdownMenuItem(value: 'category', child: Text('Category')),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _sortAscending = !_sortAscending;
            });
          },
          icon: Icon(
            _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_filteredHabits.isEmpty) {
      return _buildEmptyState();
    }

    if (_groupByCategory) {
      return _buildGroupedContent();
    }

    return _buildListContent();
  }

  Widget _buildListContent() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredHabits.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: _buildHabitTile(_filteredHabits[index]),
        );
      },
    );
  }

  Widget _buildGroupedContent() {
    final groupedHabits = _groupedHabits;
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedHabits.length,
      itemBuilder: (context, index) {
        final category = groupedHabits.keys.elementAt(index);
        final habits = groupedHabits[category]!;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _getCategoryGradient(category)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _getCategoryName(category),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...habits.map((habit) => _buildHabitTile(habit)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitTile(Habit habit) {
    return GestureDetector(
      onTap: () => widget.onHabitTap?.call(habit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _getCategoryGradient(habit.category)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(habit.category),
              color: Colors.white,
              size: 20,
            ),
          ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                habit.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            ReminderIndicator(habitId: habit.id, size: 20),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.forestGradient.first.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Streak: ${habit.currentStreak}',
                    style: TextStyle(
                      color: AppTheme.forestGradient.first,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.auroraGradient.first.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Habit.getFrequencyName(habit.frequency),
                    style: TextStyle(
                      color: AppTheme.auroraGradient.first,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: widget.showActions ? _buildActionButtons(habit) : null,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Habit habit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (habit.isCompletedToday())
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.forestGradient),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          )
        else
          GestureDetector(
            onTap: () => widget.onHabitComplete?.call(habit),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppTheme.fireGradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    if (!widget.showEmptyState) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.cosmicGradient),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyStateMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onEmptyStateAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.onEmptyStateAction,
              icon: const Icon(Icons.add),
              label: Text(widget.emptyStateActionText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.fireGradient.first,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ],
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
    return AppTheme.winterGradient; // Default fallback
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
    return Icons.star; // Default fallback
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
    return 'Other'; // Default fallback
  }
}
