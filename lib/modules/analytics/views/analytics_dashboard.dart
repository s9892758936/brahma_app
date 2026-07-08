import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/analytics/providers/analytics_provider.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String _selectedTimeFilter = 'Weekly';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnalyticsProvider>(context, listen: false).loadAnalyticsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyticsProvider>(context);

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
              'Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.loadAnalyticsData();
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildTimeFilterChip('Daily', _selectedTimeFilter == 'Daily'),
                      _buildTimeFilterChip('Weekly', _selectedTimeFilter == 'Weekly'),
                      _buildTimeFilterChip('Monthly', _selectedTimeFilter == 'Monthly'),
                      _buildTimeFilterChip('Yearly', _selectedTimeFilter == 'Yearly'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Key Metrics
                  Text(
                    '📊 Key Metrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildMetricCard(
                        'Total Users',
                        provider.totalUsers.toString(),
                        Icons.people,
                        Colors.blue,
                        provider.userGrowth,
                      ),
                      _buildMetricCard(
                        'Active Users',
                        provider.activeUsers.toString(),
                        Icons.person,
                        Colors.green,
                        provider.activeGrowth,
                      ),
                      _buildMetricCard(
                        'New Registrations',
                        provider.newRegistrations.toString(),
                        Icons.person_add,
                        Colors.orange,
                        provider.registrationGrowth,
                      ),
                      _buildMetricCard(
                        'Approval Rate',
                        '${provider.approvalRate}%',
                        Icons.verified,
                        Colors.purple,
                        provider.approvalGrowth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // User Growth Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📈 User Growth',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: _buildUserGrowthChart(provider),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Demographic Distribution
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '👤 Gender Distribution',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildGenderDistribution(provider),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '📂 Profile Types',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileTypeDistribution(provider),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Engagement Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📱 Engagement Stats',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildEngagementStat(
                                '💬 Messages',
                                provider.totalMessages.toString(),
                                Colors.blue,
                              ),
                              _buildEngagementStat(
                                '📝 Posts',
                                provider.totalPosts.toString(),
                                Colors.green,
                              ),
                              _buildEngagementStat(
                                '❤️ Likes',
                                provider.totalLikes.toString(),
                                Colors.red,
                              ),
                              _buildEngagementStat(
                                '💬 Comments',
                                provider.totalComments.toString(),
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Top States
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📍 Top States',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...provider.topStates.entries.map((entry) {
                            final total = provider.topStates.values.fold(0, (a, b) => a + b);
                            final percentage = total > 0 ? (entry.value / total * 100) : 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          entry.key,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.4 * (entry.value / total),
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${entry.value}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divine Text
                  Center(
                    child: Text(
                      '🕉️ जय श्री राम 🕉️',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildTimeFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedTimeFilter = label;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color, String growth) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                growth,
                style: TextStyle(
                  fontSize: 10,
                  color: growth.contains('+') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart(AnalyticsProvider provider) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: provider.userGrowthData.length,
      itemBuilder: (context, index) {
        final data = provider.userGrowthData[index];
        final height = (data['count'] / 100) * 180;
        final isSelected = index == provider.userGrowthData.length - 1;

        return Container(
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: height > 10 ? height : 10,
                width: 30,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['day'] ?? '',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderDistribution(AnalyticsProvider provider) {
    final data = provider.genderDistribution;
    final total = data.values.fold(0, (a, b) => a + b);

    return Column(
      children: data.entries.map((entry) {
        final percentage = total > 0 ? (entry.value / total * 100) : 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15 * (entry.value / total),
                    height: 6,
                    decoration: BoxDecoration(
                      color: entry.key == 'Male' ? Colors.blue : Colors.pink,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileTypeDistribution(AnalyticsProvider provider) {
    final data = provider.profileTypeDistribution;
    final total = data.values.fold(0, (a, b) => a + b);

    return Column(
      children: data.entries.map((entry) {
        final percentage = total > 0 ? (entry.value / total * 100) : 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  entry.key,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15 * (entry.value / total),
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getProfileTypeColor(entry.key),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getProfileTypeColor(String type) {
    switch (type) {
      case 'General':
        return Colors.blue;
      case 'Professional':
        return Colors.green;
      case 'Elite':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEngagementStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}