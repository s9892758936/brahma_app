import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/auth/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isEmailLogin = false;
  bool _isLoading = false;
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ============================================================
                // 🕉️ OM SYMBOL WITH GLOW
                // ============================================================
                Container(
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
                      fontSize: 60,
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
                const SizedBox(height: 12),

                // ============================================================
                // 📷 LOGO
                // ============================================================
                Container(
                  width: 100,
                  height: 100,
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
                      'assets/images/login_logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.1),
                          child: const Center(
                            child: Text(
                              '🕉️',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ============================================================
                // 📝 APP NAME
                // ============================================================
                const Text(
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
                const SizedBox(height: 4),
                Text(
                  'CONNECT • COLLABORATE • CREATE IMPACT',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // ✦ PREMIUM TAG
                // ============================================================
                Container(
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // 🏷️ WELCOME TEXT
                // ============================================================
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'BRAHMA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect, collaborate, and grow with a\nnetwork of professionals and entrepreneurs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // ============================================================
                // 🏷️ ERROR MESSAGE
                // ============================================================
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade300, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade300,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_errorMessage != null) const SizedBox(height: 16),

                // ============================================================
                // 🏷️ MOBILE / EMAIL TOGGLE
                // ============================================================
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEmailLogin = false;
                              _errorMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isEmailLogin
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_android,
                                    size: 18,
                                    color: _isEmailLogin
                                        ? Colors.white60
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      color: _isEmailLogin
                                          ? Colors.white60
                                          : Colors.white,
                                      fontWeight: _isEmailLogin
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEmailLogin = true;
                              _errorMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isEmailLogin
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 18,
                                    color: _isEmailLogin
                                        ? Colors.white
                                        : Colors.white60,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      color: _isEmailLogin
                                          ? Colors.white
                                          : Colors.white60,
                                      fontWeight: _isEmailLogin
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // 🏷️ INPUT FIELD
                // ============================================================
                if (!_isEmailLogin) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _mobileController,
                            enabled: !_isLoading,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter mobile number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              hintStyle: TextStyle(fontSize: 14, color: Colors.white60),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Note: Use any 10-digit number\nOTP: 123456 (any 6 digits)',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.3,
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter email address',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email, color: Colors.white60),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        hintStyle: TextStyle(fontSize: 14, color: Colors.white60),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // ============================================================
                // 🏷️ GET OTP BUTTON
                // ============================================================
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF6F00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.white.withOpacity(0.3),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFF6F00),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Get OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: const Color(0xFFFF6F00),
                                size: 18,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // ============================================================
                // 🏷️ OR DIVIDER
                // ============================================================
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ============================================================
                // 🏷️ GUEST LOGIN
                // ============================================================
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: _guestLogin,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue as guest',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ============================================================
                // 🏷️ GOOGLE LOGIN
                // ============================================================
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton.icon(
                    onPressed: _googleLogin,
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'G',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ============================================================
                // 🏷️ ADMIN LOGIN LINK
                // ============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        context.go('/admin_login');
                      },
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ============================================================
                // 🏷️ FOOTER
                // ============================================================
                Container(
                  width: 100,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '🕉️ जय श्री राम 🕉️',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 📤 SEND OTP FUNCTION
  // ============================================================
  void _sendOTP() async {
    if (_isEmailLogin) {
      if (_emailController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your email';
        });
        return;
      }
      if (!_emailController.text.contains('@')) {
        setState(() {
          _errorMessage = 'Please enter a valid email address';
        });
        return;
      }
    } else {
      String mobile = _mobileController.text.trim();
      if (mobile.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your mobile number';
        });
        return;
      }
      if (mobile.length < 10) {
        setState(() {
          _errorMessage = 'Please enter a valid 10-digit mobile number';
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.sendOTP(
        _isEmailLogin ? _emailController.text : _mobileController.text,
      );
      
      if (mounted) {
        context.go('/otp');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again.';
        _isLoading = false;
      });
    }
  }

  // ============================================================
  // 🎭 GUEST LOGIN FUNCTION
  // ============================================================
  void _guestLogin() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🕉️ Welcome Guest!'),
            backgroundColor: Colors.white.withOpacity(0.2),
            duration: const Duration(seconds: 2),
          ),
        );
        context.go('/dashboard');
      }
    });
  }

  // ============================================================
  // 🔵 GOOGLE LOGIN FUNCTION
  // ============================================================
  void _googleLogin() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🕉️ Google Login coming soon!'),
            backgroundColor: Colors.white.withOpacity(0.2),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // ============================================================
  // 🗑️ DISPOSE CONTROLLERS
  // ============================================================
  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}