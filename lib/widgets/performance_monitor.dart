import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = kDebugMode,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor>
    with WidgetsBindingObserver {
  int _frameCount = 0;
  DateTime _lastFrameTime = DateTime.now();
  double _fps = 0.0;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addObserver(this);
      WidgetsBinding.instance.addPostFrameCallback(_onFrame);
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isVisible = state == AppLifecycleState.resumed;
  }

  void _onFrame(Duration timeStamp) {
    if (!widget.enabled || !_isVisible) return;

    final now = DateTime.now();
    final frameDuration = now.difference(_lastFrameTime).inMilliseconds;
    
    if (frameDuration > 0) {
      _frameCount++;
      _fps = 1000.0 / frameDuration;
      _lastFrameTime = now;
      
      if (_frameCount % 60 == 0) {
        // Log performance every 60 frames
        debugPrint('Performance: FPS: ${_fps.toStringAsFixed(1)}');
      }
    }
    
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (kDebugMode)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'FPS: ${_fps.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
