import 'package:flutter/material.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/views/document_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});  // ✅ Correct constructor

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _socialWorkController = TextEditingController();
  
  List<String> _selectedHobbies = [];
  List<String> _selectedInterests = [];
  List<String> _achievements = [];
  
  final List<String> _hobbyOptions = [
    'Reading',
    'Yoga',
    'Spirituality',
    'Teaching',
    'Social Work',
    'Writing',
    'Music',
    'Dance',
    'Art',
    'Cooking',
    'Gardening',
    'Photography',
  ];
  
  final List<String> _interestOptions = [
    'Community Development',
    'Education',
    'Health & Wellness',
    'Environment',
    'Technology',
    'Culture',
    'Politics',
    'Business',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social & Personal Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressBar(7, 8),
                const SizedBox(height: 24),
                
                // Step Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '7',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Social & Personal Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your hobbies, interests and achievements',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                
                // Hobbies
                const Text(
                  '🎯 Hobbies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your hobbies',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _hobbyOptions.map((hobby) {
                    final isSelected = _selectedHobbies.contains(hobby);
                    return FilterChip(
                      label: Text(hobby),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedHobbies.add(hobby);
                          } else {
                            _selectedHobbies.remove(hobby);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
                      ),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Interests
                const Text(
                  '🌟 Interests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your interests',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interestOptions.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
                      ),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Achievements
                const Text(
                  '🏆 Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'List your achievements (one per line)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter your achievements...',
                    prefixIcon: Icon(Icons.emoji_events),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _achievements = value.split('\n').where((e) => e.trim().isNotEmpty).toList();
                  },
                ),
                const SizedBox(height: 24),
                
                // Social Work
                const Text(
                  '🤝 Social Work',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about your social contributions',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _socialWorkController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe your social work...',
                    prefixIcon: Icon(Icons.volunteer_activism),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                
                // About Yourself
                const Text(
                  '📝 About Yourself',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell us about yourself',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Write about yourself...',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveAndContinue,
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
                          'Next: Document Upload',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: AppTheme.accentColor, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🕉️ Profile saved as draft!')),
                  ),
                  child: Text('Save as Draft', style: TextStyle(color: Colors.grey[600])),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int current, int total) {
    double progress = current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Step $current of $total', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 12, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
          child: Container(
            width: MediaQuery.of(context).size.width * progress,
            height: 6,
            decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(3)),
          ),
        ),
      ],
    );
  }

  void _saveAndContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DocumentScreen(),
      ),
    );
  }
}