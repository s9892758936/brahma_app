import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const ProfileTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _logout(BuildContext context) {
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
              'BRAHMA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          // ✅ Notification Button
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.go('/notifications');
            },
          ),
          // ✅ Admin Button
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              context.go('/admin');
            },
          ),
          // ✅ Feed Button
          IconButton(
            icon: const Icon(Icons.home_work),
            onPressed: () {
              context.go('/feed');
            },
          ),
          // ✅ Chat Button
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              context.go('/chat');
            },
          ),
          // ✅ Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to BRAHMA! 🕉️',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your profile is under review by admin.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Pending Review',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Row 1
              Row(
                children: [
                  _buildActionCard(
                    icon: Icons.person,
                    label: 'My Profile',
                    color: AppTheme.primaryColor,
                    onTap: () {
                      context.go('/personal_info');
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.family_restroom,
                    label: 'Family',
                    color: Colors.green,
                    onTap: () {},
                  ),
                  _buildActionCard(
                    icon: Icons.work,
                    label: 'Jobs',
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Row 2
              Row(
                children: [
                  _buildActionCard(
                    icon: Icons.business,
                    label: 'Business',
                    color: Colors.orange,
                    onTap: () {},
                  ),
                  _buildActionCard(
                    icon: Icons.chat,
                    label: 'Messages',
                    color: Colors.purple,
                    onTap: () {
                      context.go('/chat');
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.admin_panel_settings,
                    label: 'Admin',
                    color: Colors.purple,
                    onTap: () {
                      context.go('/admin');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Row 3
              Row(
                children: [
                  _buildActionCard(
                    icon: Icons.home_work,
                    label: 'Feed',
                    color: Colors.teal,
                    onTap: () {
                      context.go('/feed');
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    color: Colors.red,
                    onTap: () {
                      context.go('/notifications');
                    },
                  ),
                  _buildActionCard(
                    icon: Icons.settings,
                    label: 'Settings',
                    color: Colors.grey,
                    onTap: () {
                      context.go('/settings');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Recent Activity
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history, color: AppTheme.primaryColor),
                  title: const Text('Profile Submitted'),
                  subtitle: const Text('Your profile is pending admin review'),
                  trailing: const Text('2 hours ago'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history, color: AppTheme.primaryColor),
                  title: const Text('Document Uploaded'),
                  subtitle: const Text('Aadhaar Card uploaded successfully'),
                  trailing: const Text('1 day ago'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history, color: AppTheme.primaryColor),
                  title: const Text('Profile Approved'),
                  subtitle: const Text('Your profile has been verified!'),
                  trailing: const Text('3 days ago'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Text(
                  '🕉️',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'User Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'user@email.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Chip(
                label: Text('Pending Review'),
                backgroundColor: Colors.amber,
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.verified, color: Colors.green),
                  title: Text('Verified Member'),
                  subtitle: Text('Your account is verified'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Edit Profile
          ListTile(
            leading: const Icon(Icons.person, color: AppTheme.primaryColor),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.go('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: AppTheme.primaryColor),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.go('/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: AppTheme.primaryColor),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language, color: AppTheme.primaryColor),
            title: const Text('Language'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: AppTheme.primaryColor),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.family_restroom, color: AppTheme.primaryColor),
            title: const Text('Family Tree'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.work, color: AppTheme.primaryColor),
            title: const Text('Job Portal'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.business, color: AppTheme.primaryColor),
            title: const Text('Business Directory'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              context.go('/login');
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}