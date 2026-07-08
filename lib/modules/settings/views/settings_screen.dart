import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '🕉️',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
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
        child: ListView(
          children: [
            // Profile Section
            _buildSectionHeader('👤 Profile'),
            _buildSettingsTile(
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => context.go('/personal_info'),
            ),
            _buildSettingsTile(
              icon: Icons.photo_camera,
              title: 'Change Photo',
              subtitle: 'Update your profile picture',
              onTap: () {},
            ),
            
            // Account Section
            _buildSectionHeader('🔐 Account'),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.smartphone,
              title: 'Device Management',
              subtitle: 'Manage your devices',
              onTap: () {},
            ),
            
            // Preferences Section
            _buildSectionHeader('⚙️ Preferences'),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
            ),
            _buildSwitchTile(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive email notifications',
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Enable dark theme',
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Change app language',
              onTap: () {},
            ),
            
            // App Section
            _buildSectionHeader('📱 App'),
            _buildSettingsTile(
              icon: Icons.search,
              title: 'Search',
              subtitle: 'Search users, posts, jobs, and businesses',
              onTap: () => context.go('/search'),
            ),
            _buildSettingsTile(
              icon: Icons.family_restroom,
              title: 'Family Tree',
              subtitle: 'View and manage your family tree',
              onTap: () => context.go('/family_tree'),
            ),
            _buildSettingsTile(
              icon: Icons.work,
              title: 'Job Portal',
              subtitle: 'Find and apply for jobs',
              onTap: () => context.go('/jobs'),
            ),
            _buildSettingsTile(
              icon: Icons.business,
              title: 'Business Directory',
              subtitle: 'Discover local businesses',
              onTap: () => context.go('/business'),
            ),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () => _showHelpDialog(context),
            ),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'About BRAHMA',
              subtitle: 'App version and information',
              onTap: () => _showAboutDialog(context),
            ),
            
            // Admin Section (visible to admin users)
            _buildSectionHeader('🛡️ Admin'),
            _buildSettingsTile(
              icon: Icons.admin_panel_settings,
              title: 'Admin Panel',
              subtitle: 'Manage users, content, and settings',
              onTap: () => context.go('/admin'),
            ),
            _buildSettingsTile(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'View app analytics and insights',
              onTap: () => context.go('/analytics'),
            ),
            _buildSettingsTile(
              icon: Icons.flag,
              title: 'Reports',
              subtitle: 'Manage user reports',
              onTap: () => context.go('/reports'),
            ),
            _buildSettingsTile(
              icon: Icons.group,
              title: 'Groups',
              subtitle: 'Manage community groups',
              onTap: () => context.go('/groups'),
            ),
            
            // Logout
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
            
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🕉️'),
            SizedBox(width: 8),
            Text('Help & Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHelpItem('📧', 'Email Support', 'support@brahma.com'),
            _buildHelpItem('📱', 'Phone Support', '+91-XXXXX-XXXXX'),
            _buildHelpItem('💬', 'Live Chat', 'Available 24/7'),
            _buildHelpItem('📚', 'FAQ', 'Common questions answered'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🕉️'),
            SizedBox(width: 8),
            Text('About BRAHMA'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🕉️', style: TextStyle(fontSize: 40, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'BRAHMA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                letterSpacing: 2,
              ),
            ),
            const Text(
              'Brahman Abhyudaya Hitarth Mahasangh Arohan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'A social networking platform for families,\nconnecting hearts and preserving culture.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🕉️'),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}