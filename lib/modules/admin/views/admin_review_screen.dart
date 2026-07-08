import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class AdminReviewScreen extends StatefulWidget {
  const AdminReviewScreen({super.key});

  @override
  State<AdminReviewScreen> createState() => _AdminReviewScreenState();
}

class _AdminReviewScreenState extends State<AdminReviewScreen> {
  List<ProfileModel> _pendingProfiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingProfiles();
  }

  Future<void> _loadPendingProfiles() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    _pendingProfiles = await provider.getPendingProfiles();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingProfiles,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingProfiles.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 60, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'All caught up!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('No pending profiles to review'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = _pendingProfiles[index];
                    return _buildProfileCard(context, profile);
                  },
                ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileModel profile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    profile.fullName?.isNotEmpty == true
                        ? profile.fullName![0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // ✅ FIXED: Use professional?.profession
                      Text(
                        profile.professional?.profession ?? 'No profession',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Text(
                          'Pending Review',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Profile Details
            _buildDetailRow('📧 Email', profile.email ?? 'N/A'),
            _buildDetailRow('📱 Phone', profile.mobileNumber ?? 'N/A'),
            _buildDetailRow('📍 Location', profile.presentAddress?.city ?? 'N/A'),
            _buildDetailRow('🕉️ Brahmin Type', profile.brahminDetails?.brahminType ?? 'N/A'),
            _buildDetailRow('📜 Gotra', profile.brahminDetails?.gotra ?? 'N/A'),
            _buildDetailRow('💼 Profession', profile.professional?.profession ?? 'N/A'),
            _buildDetailRow('🏢 Organization', profile.professional?.organization ?? 'N/A'),
            _buildDetailRow('🎓 Education', profile.education?.graduation ?? 'N/A'),
            _buildDetailRow('👨‍👩‍👧‍👦 Family', '${profile.familyMembers?.length ?? 0} members'),
            _buildDetailRow('📄 Documents', '${profile.documents?.length ?? 0} uploaded'),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApproveDialog(context, profile),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRejectDialog(context, profile),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showFullProfileDialog(context, profile),
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('View Full Profile'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApproveDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Approve Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Approve ${profile.fullName}\'s profile?',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'This user will get full access to the BRAHMA community.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<ProfileProvider>(context, listen: false);
              // ✅ Use fullName as identifier since id is now added
              await provider.approveProfileById(profile.id);
              _loadPendingProfiles();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Profile approved successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, ProfileModel profile) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 8),
            Text('Reject Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reject ${profile.fullName}\'s profile?',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please provide a reason for rejection:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter rejection reason...',
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
            onPressed: () async {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for rejection'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              final provider = Provider.of<ProfileProvider>(context, listen: false);
              await provider.rejectProfileById(profile.id, reason);
              _loadPendingProfiles();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Profile rejected'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showFullProfileDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('👤 ${profile.fullName}\'s Profile'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Full Name', profile.fullName ?? 'N/A'),
                _buildDetailRow('Email', profile.email ?? 'N/A'),
                _buildDetailRow('Phone', profile.mobileNumber ?? 'N/A'),
                _buildDetailRow('State', profile.presentAddress?.state ?? 'N/A'),
                _buildDetailRow('District', profile.presentAddress?.district ?? 'N/A'),
                _buildDetailRow('Brahmin Type', profile.brahminDetails?.brahminType ?? 'N/A'),
                _buildDetailRow('Gotra', profile.brahminDetails?.gotra ?? 'N/A'),
                _buildDetailRow('Profession', profile.professional?.profession ?? 'N/A'),
                _buildDetailRow('Organization', profile.professional?.organization ?? 'N/A'),
                _buildDetailRow('Education', profile.education?.graduation ?? 'N/A'),
                _buildDetailRow('Family', '${profile.familyMembers?.length ?? 0} members'),
                _buildDetailRow('Documents', '${profile.documents?.length ?? 0} uploaded'),
                _buildDetailRow('Status', profile.profileStatus ?? 'N/A'),
              ],
            ),
          ),
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
}