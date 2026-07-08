import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/reports/providers/reports_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReportType = 'All';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsProvider>(context, listen: false).loadSampleReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportsProvider>(context);

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
              'Reports',
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
              provider.loadSampleReports();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard('Total Reports', provider.totalReports, Colors.blue),
                _buildStatCard('Pending', provider.pendingReports, Colors.orange),
                _buildStatCard('Resolved', provider.resolvedReports, Colors.green),
                _buildStatCard('Rejected', provider.rejectedReports, Colors.red),
              ],
            ),
          ),
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedReportType,
                    decoration: const InputDecoration(
                      labelText: 'Report Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'All',
                      'Spam',
                      'Harassment',
                      'Fake Profile',
                      'Inappropriate Content',
                      'Other',
                    ].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedReportType = value ?? 'All';
                        _applyFilters(provider);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'All',
                      'Pending',
                      'Under Review',
                      'Resolved',
                      'Rejected',
                    ].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value ?? 'All';
                        _applyFilters(provider);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Report List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.reports.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flag,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No reports found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'All clear! No reports to review',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.reports.length,
                        itemBuilder: (context, index) {
                          final report = provider.reports[index];
                          return _buildReportCard(context, report);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
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

  Widget _buildReportCard(BuildContext context, ReportItem report) {
    final statusColor = _getStatusColor(report.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getReportTypeColor(report.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getReportTypeIcon(report.type),
            color: _getReportTypeColor(report.type),
          ),
        ),
        title: Text(
          report.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reported by: ${report.reportedBy}'),
            Text('${report.type} • ${_formatDate(report.createdAt)}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            report.status,
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report Details
                _buildDetailRow('📋 Type', report.type),
                _buildDetailRow('👤 Reported By', report.reportedBy),
                _buildDetailRow('📧 Email', report.reportedEmail),
                _buildDetailRow('🕐 Created', _formatDate(report.createdAt)),
                _buildDetailRow('📊 Status', report.status),
                const SizedBox(height: 12),
                // Description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                if (report.reportedContent.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Reported Content',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      report.reportedContent,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                
                // Action Buttons
                if (report.status == 'Pending' || report.status == 'Under Review') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showActionDialog(context, report, 'resolve');
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Resolve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showActionDialog(context, report, 'reject');
                          },
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showActionDialog(context, report, 'investigate');
                      },
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Investigate'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Under Review':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'Spam':
        return Colors.red;
      case 'Harassment':
        return Colors.purple;
      case 'Fake Profile':
        return Colors.orange;
      case 'Inappropriate Content':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'Spam':
        return Icons.warning;
      case 'Harassment':
        return Icons.gavel;
      case 'Fake Profile':
        return Icons.person_off;
      case 'Inappropriate Content':
        return Icons.flag;
      default:
        return Icons.report;
    }
  }

  void _applyFilters(ReportsProvider provider) {
    provider.filterReports(
      type: _selectedReportType == 'All' ? null : _selectedReportType,
      status: _selectedStatus == 'All' ? null : _selectedStatus,
    );
  }

  void _showActionDialog(BuildContext context, ReportItem report, String action) {
    final remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action == 'resolve' ? '✅ Resolve Report' : action == 'reject' ? '❌ Reject Report' : '🔍 Investigate Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Report: ${report.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarkController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add remarks...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ReportsProvider>(context, listen: false);
              if (action == 'resolve') {
                provider.resolveReport(report.id);
              } else if (action == 'reject') {
                provider.rejectReport(report.id);
              } else {
                provider.investigateReport(report.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Report ${action == 'resolve' ? 'resolved' : action == 'reject' ? 'rejected' : 'under investigation'}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'resolve' ? Colors.green : action == 'reject' ? Colors.red : Colors.blue,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}