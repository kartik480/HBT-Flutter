import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/screens/auth/login_screen.dart';
import 'package:habit_tracker/screens/welcome_screen.dart';
import 'package:habit_tracker/utils/app_theme.dart';
import 'dart:math' as math;
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _particleController;
  late AnimationController _textController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _createParticles();
    _startAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
  }

  void _createParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * 400,
        y: _random.nextDouble() * 800,
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 2 + 1,
        color: _getRandomColor(),
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.neonPink,
      AppTheme.neonBlue,
      AppTheme.neonGreen,
      AppTheme.neonYellow,
      AppTheme.hotPink,
      AppTheme.limeGreen,
      AppTheme.electricBlue,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _startAnimations() {
    _mainAnimationController.forward();
    _particleController.repeat();
    _textController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _particleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
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
        child: Stack(
          children: [
            // Animated Background Particles
            ..._particles.map((particle) => _buildParticle(particle)),
            
            // Main Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMainIcon(),
                      const SizedBox(height: 40),
                      _buildAnimatedText(),
                      const SizedBox(height: 60),
                      _buildProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Floating Elements
            _buildFloatingElements(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.fireGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPink.withOpacity(0.6),
            blurRadius: 40,
            spreadRadius: 10,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.6),
            blurRadius: 40,
            spreadRadius: 10,
            offset: const Offset(0, -20),
          ),
        ],
      ),
      child: RotationTransition(
        turns: _rotationAnimation,
        child: Icon(
          Icons.track_changes,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAnimatedText() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textFadeAnimation,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: AppTheme.sunsetGradient,
              ).createShader(bounds),
              child: Text(
                'HABIT TRACKER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.oceanGradient,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.electricBlue.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                'BUILD BETTER HABITS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 200,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white.withOpacity(0.3),
      ),
      child: LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.neonGreen,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating circles
              Positioned(
                left: 50 + math.sin(_particleController.value * 2 * math.pi) * 30,
                top: 100 + math.cos(_particleController.value * 2 * math.pi) * 30,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.neonPink.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonPink.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 80 + math.cos(_particleController.value * 2 * math.pi) * 40,
                top: 200 + math.sin(_particleController.value * 2 * math.pi) * 40,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppTheme.neonBlue.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonBlue.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 120 + math.sin(_particleController.value * 3 * math.pi) * 50,
                bottom: 150 + math.cos(_particleController.value * 3 * math.pi) * 50,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppTheme.neonGreen.withOpacity(0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonGreen.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParticle(Particle particle) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = _particleController.value;
        final y = particle.y - (particle.speed * progress * 100);
        
        if (y < -50) {
          particle.y = 850;
        }
        
        return Positioned(
          left: particle.x,
          top: y,
          child: Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(
              color: particle.color.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: particle.color.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}
