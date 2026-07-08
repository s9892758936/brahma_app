import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/views/personal_info_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedGender;
  String? _selectedAge;

  final List<String> _ageGroups = [
    'Under 18',
    '18-25',
    '26-35',
    '36-45',
    '46-55',
    '55+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // 🕉️ OM Symbol
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.15),
                        Colors.transparent,
                      ],
                      radius: 1.0,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '🕉️',
                      style: TextStyle(
                        fontSize: 35,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'Tell us more about yourself',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Help us understand you better! Answer a few quick questions so we can tailor the app just for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Divine Line
                Container(
                  width: 60,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryColor,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name *',
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Enter your full name',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Profession
                      TextFormField(
                        controller: _professionController,
                        decoration: const InputDecoration(
                          labelText: 'Profession *',
                          prefixIcon: Icon(Icons.work),
                          hintText: 'What do you do?',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your profession';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Gender
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Gender *',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text('Male')),
                          DropdownMenuItem(value: 'Female', child: Text('Female')),
                          DropdownMenuItem(value: 'Other', child: Text('Other')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Age Group
                      DropdownButtonFormField<String>(
                        value: _selectedAge,
                        decoration: const InputDecoration(
                          labelText: 'Age Group *',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        items: _ageGroups.map((age) {
                          return DropdownMenuItem(
                            value: age,
                            child: Text(age),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAge = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select your age group';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Bio
                      TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Tell us a bit about yourself...',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 🕉️ Get Started Button - Saffron
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: AppTheme.accentColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Skip Button
                TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip for now',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // 🕉️ Divine Line
                Container(
                  width: 80,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.primaryColor,
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
                    color: AppTheme.primaryColor,
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

  void _validateAndContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      if (mounted) {
        context.go('/personal_info');
      }
    }
  }

  void _skipOnboarding() {
    if (mounted) {
      context.go('/personal_info');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}