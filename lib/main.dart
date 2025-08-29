import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/screens/splash_screen.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'package:habit_tracker/utils/performance_config.dart';

void main() {
  // Enable performance optimizations
  PerformanceConfig.enablePerformanceOptimizations();
  
  // Optimize for performance
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HabitProvider()),
      ],
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        // Performance optimizations
        builder: (context, child) {
          return PerformanceConfig.wrapWithPerformanceOptimizations(child!);
        },
        // Additional performance settings
        debugShowMaterialGrid: false,
        showSemanticsDebugger: false,
      ),
    );
  }
}
