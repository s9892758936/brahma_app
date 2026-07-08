import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // 🎬 ANIMATION CONTROLLER
    // ============================================================
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // ============================================================
    // 🌟 FADE ANIMATION (For OM Symbol)
    // ============================================================
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // ============================================================
    // 📐 SCALE ANIMATION (For Logo)
    // ============================================================
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // ============================================================
    // 🔄 ROTATE ANIMATION (For OM Symbol)
    // ============================================================
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // ============================================================
    // ▶️ START ANIMATION
    // ============================================================
    _animationController.forward();

    // ============================================================
    // 🚀 NAVIGATE TO LOGIN AFTER 4 SECONDS
    // ============================================================
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6F00),  // Orange
              Color(0xFFE65100),  // Dark Orange
              Color(0xFFBF360C),  // Red-Orange
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ============================================================
                // 🕉️ OM SYMBOL WITH FADE + ROTATE
                // ============================================================
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: RotationTransition(
                    turns: _rotateAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.transparent,
                          ],
                          radius: 1.0,
                        ),
                      ),
                      child: const Text(
                        '🕉️',
                        style: TextStyle(
                          fontSize: 70,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 30,
                              color: Colors.white70,
                            ),
                            Shadow(
                              blurRadius: 60,
                              color: Colors.white30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // 📷 LOGO WITH SCALE ANIMATION
                // ============================================================
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // ============================================================
                // 📝 APP NAME
                // ============================================================
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'BRAHMA',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ============================================================
                // 📝 FULL NAME
                // ============================================================
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: const Text(
                      'Brahman Abhyudaya Hitarth Mahasangh Arohan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ============================================================
                // ✦ PREMIUM TAG
                // ============================================================
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFD700),  // Gold
                          Color(0xFFFFA000),  // Dark Gold
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Text(
                      '✦ Premium Community ✦',
                      style: TextStyle(
                        color: Color(0xFF2C1810),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ============================================================
                // 🔄 LOADING INDICATOR
                // ============================================================
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
                const SizedBox(height: 16),

                // ============================================================
                // 📱 VERSION TEXT
                // ============================================================
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // 🕉️ JAY SHRI RAM FOOTER
                // ============================================================
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    '🕉️ जय श्री राम 🕉️',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}