import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
// import 'package:brahma_app/utils/seed_data.dart';  // ❌ COMMENTED OUT

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isLoading = true;
  DashboardStats _stats = DashboardStats();
  List<Map<String, dynamic>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _loadRealData();
  }

  // ============================================================
  // 📥 LOAD REAL DATA FROM FIRESTORE
  // ============================================================
  Future<void> _loadRealData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final usersSnapshot = await firestore.collection('users').get();
      final allUsers = usersSnapshot.docs;

      // Calculate stats
      final totalUsers = allUsers.length;
      final approvedUsers = allUsers.where((doc) => doc['isApproved'] == true).length;
      final pendingUsers = allUsers.where((doc) => doc['isApproved'] == false).length;
      final rejectedUsers = allUsers.where((doc) => doc['isRejected'] == true).length;
      final premiumUsers = allUsers.where((doc) => doc['isPremium'] == true).length;
      final eliteUsers = allUsers.where((doc) => doc['profileType'] == 'elite').length;

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final newToday = allUsers.where((doc) {
        final createdAt = (doc['createdAt'] as Timestamp?)?.toDate();
        if (createdAt == null) return false;
        return createdAt.isAfter(todayStart);
      }).length;

      // Recent activity
      final recentUsers = allUsers
          .where((doc) => doc['createdAt'] != null)
          .toList()
        ..sort((a, b) {
          final aDate = (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
          final bDate = (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });

      _recentActivity = recentUsers.take(10).map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unknown',
          'city': data['city'] ?? 'N/A',
          'status': data['isApproved'] == true ? 'approved' : 'pending',
          'time': (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      _stats = DashboardStats(
        totalUsers: totalUsers,
        approvedUsers: approvedUsers,
        pendingReviews: pendingUsers,
        rejectedProfiles: rejectedUsers,
        activeToday: 0,
        newRegistrations: newToday,
        eliteMembers: eliteUsers,
        paidMembers: premiumUsers,
      );

    } catch (e) {
      print('❌ Error loading dashboard data: $e');
      _showMockData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ============================================================
  // 🧪 MOCK DATA (Fallback)
  // ============================================================
  void _showMockData() {
    _stats = DashboardStats(
      totalUsers: 2847,
      approvedUsers: 0,
      pendingReviews: 25,
      rejectedProfiles: 0,
      activeToday: 342,
      newRegistrations: 56,
      eliteMembers: 0,
      paidMembers: 178,
    );
    _recentActivity = [
      {'name': 'Rahul Sharma', 'city': 'Varanasi', 'status': 'approved', 'time': DateTime.now().subtract(const Duration(minutes: 2))},
      {'name': 'Priya Patel', 'city': 'Patna', 'status': 'pending', 'time': DateTime.now().subtract(const Duration(minutes: 15))},
      {'name': 'Amit Singh', 'city': 'Lucknow', 'status': 'pending', 'time': DateTime.now().subtract(const Duration(hours: 1))},
    ];
  }

  // ============================================================
  // ❌ ADD TEST DATA - COMMENTED OUT
  // ============================================================
  // Future<void> _addTestData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     await SeedData.seedAll();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('✅ 6 Test Users Added Successfully!'),
  //         backgroundColor: Colors.green,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //     await _loadRealData();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('❌ Error: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // ============================================================
  // 🏗️ BUILD UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // ❌ ADD TEST USERS BUTTON - COMMENTED OUT
          // IconButton(
          //   icon: const Icon(Icons.person_add),
          //   onPressed: _addTestData,
          //   tooltip: 'Add Test Users',
          // ),
          // 🔄 Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRealData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading Dashboard...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================================
                  // 🎯 WELCOME CARD
                  // ============================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🕉️ Welcome Admin!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Here\'s your dashboard overview',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '📊 Total Users: ${_stats.totalUsers}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ============================================================
                  // 📊 DASHBOARD OVERVIEW
                  // ============================================================
                  const Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildStatCard('Total Users', _stats.totalUsers, Icons.people, Colors.blue),
                      _buildStatCard('Approved', _stats.approvedUsers, Icons.check_circle, Colors.green),
                      _buildStatCard('Pending', _stats.pendingReviews, Icons.pending, Colors.orange),
                      _buildStatCard('Rejected', _stats.rejectedProfiles, Icons.cancel, Colors.red),
                      _buildStatCard('Active Today', _stats.activeToday, Icons.online_prediction, Colors.teal),
                      _buildStatCard('New Today', _stats.newRegistrations, Icons.person_add, Colors.purple),
                      _buildStatCard('Elite', _stats.eliteMembers, Icons.star, Colors.amber),
                      _buildStatCard('Premium', _stats.paidMembers, Icons.verified, Colors.indigo),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ============================================================
                  // ⚡ QUICK ACTIONS
                  // ============================================================
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildActionCard(Icons.people, 'Review Profiles', Colors.blue),
                      _buildActionCard(Icons.group, 'Manage Groups', Colors.green),
                      _buildActionCard(Icons.announcement, 'Send Announcement', Colors.orange),
                      _buildActionCard(Icons.analytics, 'View Analytics', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ============================================================
                  // 📋 RECENT ACTIVITY
                  // ============================================================
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _recentActivity.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text('No recent activity'),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentActivity.length > 10 ? 10 : _recentActivity.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                            itemBuilder: (context, index) {
                              final activity = _recentActivity[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: activity['status'] == 'approved'
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.2),
                                  child: Icon(
                                    activity['status'] == 'approved'
                                        ? Icons.check_circle
                                        : Icons.pending,
                                    size: 20,
                                    color: activity['status'] == 'approved'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                                title: Text(
                                  activity['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '${activity['city'] ?? 'N/A'} • ${_timeAgo(activity['time'])}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: activity['status'] == 'approved'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    activity['status'] == 'approved' ? 'Approved' : 'Pending',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: activity['status'] == 'approved'
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // ============================================================
  // 🏷️ STAT CARD WIDGET
  // ============================================================
  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🎯 ACTION CARD WIDGET
  // ============================================================
  Widget _buildActionCard(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🕉️ $title clicked!')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 🕐 TIME AGO FUNCTION
  // ============================================================
  String _timeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    if (difference.inDays < 7) return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
  }
}

// ============================================================
// 📊 DASHBOARD STATS MODEL
// ============================================================
class DashboardStats {
  final int totalUsers;
  final int approvedUsers;
  final int pendingReviews;
  final int rejectedProfiles;
  final int activeToday;
  final int newRegistrations;
  final int eliteMembers;
  final int paidMembers;

  DashboardStats({
    this.totalUsers = 0,
    this.approvedUsers = 0,
    this.pendingReviews = 0,
    this.rejectedProfiles = 0,
    this.activeToday = 0,
    this.newRegistrations = 0,
    this.eliteMembers = 0,
    this.paidMembers = 0,
  });
}