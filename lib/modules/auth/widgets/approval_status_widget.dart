import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/auth/providers/auth_provider.dart';

class ApprovalStatusWidget extends StatelessWidget {
  const ApprovalStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final status = authProvider.approvalStatus;
    final isApproved = authProvider.isApproved;

    if (isApproved) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(status),
                color: _getStatusColor(status),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getStatusTitle(status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusMessage(status),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.hourglass_top, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⏳ Your profile is under review. You will be notified once approved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (status == 'rejected') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '❌ Profile Rejected',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (authProvider.rejectionReason != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Reason: ${authProvider.rejectionReason}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Please update your profile and resubmit for approval.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<AuthProvider>(context, listen: false);
                        provider.resubmitForApproval();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🔄 Profile resubmitted for approval!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Resubmit for Approval'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_top;
      default:
        return Icons.info;
    }
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'approved':
        return '✅ Approved';
      case 'rejected':
        return '❌ Rejected';
      case 'pending':
        return '⏳ Under Review';
      default:
        return 'Unknown Status';
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'approved':
        return 'Your profile is approved. You have full access to BRAHMA community.';
      case 'rejected':
        return 'Your profile was rejected. Please update your details and resubmit.';
      case 'pending':
        return 'Your profile is under review. This may take 24-48 hours.';
      default:
        return 'Please complete your profile and submit for approval.';
    }
  }
}