import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/widgets/statistics_card.dart';
import 'package:habit_tracker/widgets/habit_list_tile.dart';
import 'package:habit_tracker/widgets/category_filter.dart';
import 'package:habit_tracker/widgets/performance_monitor.dart';
import 'package:habit_tracker/widgets/habit_list_box.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/screens/analytics_screen.dart';
import 'package:habit_tracker/screens/auth/login_screen.dart';
import 'package:habit_tracker/screens/habit_detail_screen.dart';
import 'package:habit_tracker/screens/settings_screen.dart';
import 'package:habit_tracker/screens/reminders_screen.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'package:habit_tracker/models/habit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pulseController;
  late AnimationController _refreshController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _refreshAnimation;
  
  String _searchQuery = '';
  HabitCategory? _selectedCategory;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.auroraGradient,
            ),
          ),
          child: Column(
            children: [
              // Fixed header sections
              _buildAppBar(),
              _buildTabBar(),
              // Tab content with proper height
              Expanded(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }



  Widget _buildAppBar() {
    return Container(
      height: 120,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: AppTheme.fireGradient,
                  ).createShader(bounds),
                  child: const Text(
                    'HABIT TRACKER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
                             Container(
                 margin: const EdgeInsets.only(right: 8),
                 decoration: BoxDecoration(
                   gradient: LinearGradient(colors: AppTheme.forestGradient),
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: AppTheme.forestGradient.first.withOpacity(0.3),
                       blurRadius: 10,
                       offset: const Offset(0, 5),
                     ),
                   ],
                 ),
                 child: IconButton(
                   onPressed: () => _navigateToAnalytics(),
                   icon: const Icon(Icons.analytics, color: Colors.white),
                   tooltip: 'Analytics',
                 ),
               ),
               Container(
                 margin: const EdgeInsets.only(right: 8),
                 decoration: BoxDecoration(
                   gradient: LinearGradient(colors: AppTheme.cosmicGradient),
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: AppTheme.cosmicGradient.first.withOpacity(0.3),
                       blurRadius: 10,
                       offset: const Offset(0, 5),
                     ),
                   ],
                 ),
                 child: IconButton(
                   onPressed: () => _navigateToReminders(),
                   icon: const Icon(Icons.notifications, color: Colors.white),
                   tooltip: 'Reminders',
                 ),
               ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.oceanGradient),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.oceanGradient.first.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _navigateToSettings(),
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'Settings',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.sunsetGradient),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.sunsetGradient.first.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => _showProfileMenu(),
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  tooltip: 'Profile',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: AppTheme.cosmicGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cosmicGradient.first.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.fireGradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.fireGradient.first.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.userName ?? 'Habit Champion',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMotivationalQuote(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMotivationalQuote() {
    final quotes = [
      'Every day is a new beginning!',
      'Small steps lead to big changes!',
      'Consistency is the key to success!',
      'You are stronger than you think!',
      'Progress, not perfection!'
    ];
    
    final randomQuote = quotes[DateTime.now().day % quotes.length];
    
    return Text(
      randomQuote,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final stats = habitProvider.getStatistics();
        
        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatisticsCard(
                      title: 'Total Habits',
                      value: stats['totalHabits'].toString(),
                      icon: Icons.list_alt,
                      gradient: AppTheme.auroraGradient,
                      onTap: () => _tabController.animateTo(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatisticsCard(
                      title: 'Completed',
                      value: '${stats['completedToday']}/${stats['totalHabits']}',
                      icon: Icons.check_circle,
                      gradient: AppTheme.forestGradient,
                      onTap: () => _tabController.animateTo(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatisticsCard(
                      title: 'Streak',
                      value: '${stats['longestStreak']} days',
                      icon: Icons.local_fire_department,
                      gradient: AppTheme.fireGradient,
                      onTap: () => _tabController.animateTo(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatisticsCard(
                      title: 'Success Rate',
                      value: '${(stats['overallCompletionRate'] * 100).toInt()}%',
                      icon: Icons.trending_up,
                      gradient: AppTheme.oceanGradient,
                      onTap: () => _navigateToAnalytics(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildProgressCard(stats),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitListBoxSection() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final allHabits = habitProvider.habits;
        final todayHabits = habitProvider.getTodayHabits();
        final completedTodayHabits = habitProvider.getCompletedTodayHabits();
        
        return Column(
          children: [
            // Main Habit List Box
            HabitListBox(
              title: 'Today\'s Habits',
              habits: todayHabits,
              showActions: true,
              showSearch: true,
              showCategoryFilter: true,
              showSortOptions: true,
              showGroupByCategory: true,
              headerGradient: AppTheme.auroraGradient,
              onEmptyStateAction: () => _navigateToAddHabit(),
              emptyStateMessage: 'No habits for today!',
              emptyStateActionText: 'Create Habit',
              onHabitTap: (habit) => _navigateToHabitDetail(habit),
              onHabitComplete: (habit) => _completeHabit(habit),
            ),
            
            const SizedBox(height: 16),
            
            // Completed Habits List Box
            if (completedTodayHabits.isNotEmpty)
              HabitListBox(
                title: 'Completed Today',
                habits: completedTodayHabits,
                showActions: false,
                showSearch: false,
                showCategoryFilter: false,
                showSortOptions: false,
                showGroupByCategory: false,
                headerGradient: AppTheme.forestGradient,
                showEmptyState: false,
              ),
            
            const SizedBox(height: 16),
            
            // Quick Actions List Box
            HabitListBox(
              title: 'Quick Actions',
              habits: allHabits.take(3).toList(), // Show first 3 habits for quick access
              showActions: true,
              showSearch: false,
              showCategoryFilter: false,
              showSortOptions: false,
              showGroupByCategory: false,
              headerGradient: AppTheme.sunsetGradient,
              onEmptyStateAction: () => _navigateToAddHabit(),
              emptyStateMessage: 'No habits available for quick actions!',
              emptyStateActionText: 'Create Habit',
              onHabitTap: (habit) => _navigateToHabitDetail(habit),
              onHabitComplete: (habit) => _completeHabit(habit),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressCard(Map<String, dynamic> stats) {
    final totalHabits = stats['totalHabits'] as int;
    final completedToday = stats['completedToday'] as int;
    final progress = totalHabits > 0 ? completedToday / totalHabits : 0.0;
    
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
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
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.forestGradient.first,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completed: $completedToday',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Remaining: ${totalHabits - completedToday}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
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
          ),
          const SizedBox(height: 16),
          // Category Filter
          CategoryFilter(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          const SizedBox(height: 16),
          // Toggle for completed habits
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Show completed habits',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: _showCompleted,
                onChanged: (value) {
                  setState(() {
                    _showCompleted = value;
                  });
                },
                activeColor: AppTheme.forestGradient.first,
                activeTrackColor: AppTheme.forestGradient.first.withOpacity(0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.winterGradient),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.winterGradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            tabs: const [
              Tab(text: 'TODAY'),
              Tab(text: 'ALL HABITS'),
              Tab(text: 'CATEGORIES'),
              Tab(text: 'COMPLETED'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTodayTab(),
        _buildAllHabitsTab(),
        _buildCategoriesTab(),
        _buildCompletedTab(),
      ],
    );
  }

  Widget _buildTodayTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final todayHabits = habitProvider.getTodayHabits();
        final completedHabits = habitProvider.getCompletedTodayHabits();
        final filteredTodayHabits = _filterHabits(todayHabits);
        final filteredCompletedHabits = _filterHabits(completedHabits);

        return RefreshIndicator(
          onRefresh: () async {
            _refreshController.forward();
            await Future.delayed(const Duration(milliseconds: 500));
            _refreshController.reverse();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 16),
              _buildStatisticsSection(),
              const SizedBox(height: 24),
              if (filteredTodayHabits.isNotEmpty) ...[
                _buildSectionHeader('PENDING HABITS', AppTheme.fireGradient),
                const SizedBox(height: 16),
                ...filteredTodayHabits.map((habit) => _buildHabitTile(habit, true)),
              ],
              if (filteredCompletedHabits.isNotEmpty && _showCompleted) ...[
                const SizedBox(height: 24),
                _buildSectionHeader('COMPLETED TODAY', AppTheme.forestGradient),
                const SizedBox(height: 16),
                ...filteredCompletedHabits.map((habit) => _buildHabitTile(habit, false)),
              ],
              if (filteredTodayHabits.isEmpty && filteredCompletedHabits.isEmpty) ...[
                _buildEmptyState(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAllHabitsTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final allHabits = habitProvider.habits;
        final filteredHabits = _filterHabits(allHabits);
        
        if (filteredHabits.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: HabitListBox(
            title: 'All Habits',
            habits: filteredHabits,
            showActions: false,
            showSearch: true,
            showCategoryFilter: true,
            showSortOptions: true,
            showGroupByCategory: true,
            headerGradient: AppTheme.oceanGradient,
            onEmptyStateAction: () => _navigateToAddHabit(),
            emptyStateMessage: 'No habits found!',
            emptyStateActionText: 'Create Habit',
            onHabitTap: (habit) => _navigateToHabitDetail(habit),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final categories = HabitCategory.values;
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('HABIT CATEGORIES', AppTheme.auroraGradient),
            const SizedBox(height: 20),
            ...categories.map((category) => _buildCategoryCard(category, habitProvider)),
          ],
        );
      },
    );
  }

  Widget _buildCompletedTab() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final allHabits = habitProvider.habits;
        final completedHabits = allHabits.where((habit) => 
          habit.completionHistory.isNotEmpty
        ).toList();
        final filteredCompletedHabits = _filterHabits(completedHabits);
        
        if (filteredCompletedHabits.isEmpty) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: HabitListBox(
            title: 'Completed Habits',
            habits: filteredCompletedHabits,
            showActions: false,
            showSearch: true,
            showCategoryFilter: true,
            showSortOptions: true,
            showGroupByCategory: true,
            headerGradient: AppTheme.forestGradient,
            onEmptyStateAction: () => _navigateToAddHabit(),
            emptyStateMessage: 'No completed habits found!',
            emptyStateActionText: 'Create Habit',
            onHabitTap: (habit) => _navigateToHabitDetail(habit),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(HabitCategory category, HabitProvider habitProvider) {
    final habitsInCategory = habitProvider.getHabitsByCategory(category);
    final completedToday = habitsInCategory.where((h) => h.isCompletedToday()).length;
    final total = habitsInCategory.length;
    final progress = total > 0 ? completedToday / total : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getCategoryGradient(category)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getCategoryGradient(category).first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
            _tabController.animateTo(1);
          },
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
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        _getCategoryIcon(category),
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
                            _getCategoryName(category),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '$completedToday of $total completed today',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                  ],
                ),
                if (total > 0) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
          letterSpacing: 1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHabitTile(Habit habit, bool showActions) {
    return GestureDetector(
      onTap: () => _navigateToHabitDetail(habit),
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
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
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
                        Container(
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
                        ),
                        const SizedBox(width: 8),
                        Container(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showActions) ...[
                const SizedBox(width: 16),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
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
                          onPressed: () => _completeHabit(habit),
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppTheme.cosmicGradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cosmicGradient.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_task,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: AppTheme.fireGradient,
            ).createShader(bounds),
            child: const Text(
              'No Habits Found!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddHabit(),
            icon: const Icon(Icons.add),
            label: const Text('Create New Habit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.fireGradient.first,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Habit> _filterHabits(List<Habit> habits) {
    return habits.where((habit) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!habit.title.toLowerCase().contains(query) &&
            !habit.description.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Category filter
      if (_selectedCategory != null && habit.category != _selectedCategory) {
        return false;
      }
      
      return true;
    }).toList();
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
        onPressed: () => _navigateToAddHabit(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Habit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _completeHabit(Habit habit) {
    final habitProvider = context.read<HabitProvider>();
    habitProvider.markHabitCompleted(habit.id, DateTime.now());
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.title} completed! 🎉'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _navigateToAddHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
  }

  void _navigateToAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToReminders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RemindersScreen()),
    );
  }

  void _navigateToHabitDetail(Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HabitDetailScreen(habit: habit)),
    );
  }

  void _showProfileMenu() {
    final authProvider = context.read<AuthProvider>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.midnightGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.cosmicGradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cosmicGradient.first.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                authProvider.userName ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                authProvider.userEmail ?? '',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppTheme.fireGradient),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.fireGradient.first.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    authProvider.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


