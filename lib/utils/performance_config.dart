import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerformanceConfig {
  static void enablePerformanceOptimizations() {
    // Enable performance optimizations
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations for better performance
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Optimize system UI overlay
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  static Widget wrapWithPerformanceOptimizations(Widget child) {
    return RepaintBoundary(
      child: child,
    );
  }
  
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  
  static const Curve fastAnimationCurve = Curves.easeOut;
  static const Curve mediumAnimationCurve = Curves.easeInOut;
  static const Curve slowAnimationCurve = Curves.easeInOutCubic;
}
