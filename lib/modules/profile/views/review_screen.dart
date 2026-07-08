import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isSubmitting = false;
  ProfileModel? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    _profile = provider.profile;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    if (_profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/documents'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              _buildStatusCard(provider),
              const SizedBox(height: 16),

              // Profile Summary
              const Text(
                '📋 Profile Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Personal Details
              _buildSectionCard(
                title: '👤 Personal Details',
                children: [
                  _buildDetailRow('Name', _profile!.fullName),
                  _buildDetailRow('DOB', _formatDate(_profile!.dob)),
                  _buildDetailRow('Gender', _profile!.gender),
                  _buildDetailRow('Marital Status', _profile!.maritalStatus),
                  _buildDetailRow('Mobile', _profile!.mobileNumber),
                  _buildDetailRow('Email', _profile!.email),
                  _buildDetailRow('Blood Group', _profile!.bloodGroup ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              
              // Brahmin Details
              _buildSectionCard(
                title: '🕉️ Brahmin Details',
                children: [
                  _buildDetailRow('Brahmin Type', _profile!.brahminDetails?.brahminType ?? 'N/A'),
                  _buildDetailRow('Gotra', _profile!.brahminDetails?.gotra ?? 'N/A'),
                  _buildDetailRow('Pur / Vansh', _profile!.brahminDetails?.pur ?? 'N/A'),
                  _buildDetailRow('Kuldevta', _profile!.brahminDetails?.kuldevta ?? 'N/A'),
                  _buildDetailRow('Native Village', _profile!.brahminDetails?.nativeVillage ?? 'N/A'),
                  _buildDetailRow('Native District', _profile!.brahminDetails?.nativeDistrict ?? 'N/A'),
                  _buildDetailRow('Native State', _profile!.brahminDetails?.nativeState ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              
              // Address Details
              _buildSectionCard(
                title: '📍 Address',
                children: [
                  _buildDetailRow('Present Address', _getFullAddress(_profile!.presentAddress)),
                  _buildDetailRow('Permanent Address', _getFullAddress(_profile!.permanentAddress)),
                ],
              ),
              const SizedBox(height: 16),
              
              // Education Details
              _buildSectionCard(
                title: '📚 Education',
                children: [
                  _buildDetailRow('10th', _profile!.education?.is10thPassed == true ? 'Passed' : 'Not Passed'),
                  _buildDetailRow('10th Board', _profile!.education?.tenthBoard ?? 'N/A'),
                  _buildDetailRow('12th', _profile!.education?.is12thPassed == true ? 'Passed' : 'Not Passed'),
                  _buildDetailRow('12th Board', _profile!.education?.twelfthBoard ?? 'N/A'),
                  _buildDetailRow('Graduation', _profile!.education?.graduation ?? 'N/A'),
                  _buildDetailRow('College', _profile!.education?.college ?? 'N/A'),
                  _buildDetailRow('Marks', _profile!.education?.marks ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              
              // Professional Details
              _buildSectionCard(
                title: '💼 Professional',
                children: [
                  _buildDetailRow('Employed', _profile!.professional?.isEmployed == true ? 'Yes' : 'No'),
                  _buildDetailRow('Employment Type', _profile!.professional?.employmentType ?? 'N/A'),
                  _buildDetailRow('Profession', _profile!.professional?.profession ?? 'N/A'),
                  _buildDetailRow('Designation', _profile!.professional?.designation ?? 'N/A'),
                  _buildDetailRow('Organization', _profile!.professional?.organization ?? 'N/A'),
                  _buildDetailRow('Experience', _profile!.professional?.experience ?? 'N/A'),
                  _buildDetailRow('Skills', _profile!.professional?.skills?.join(', ') ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              
              // Family Details
              _buildSectionCard(
                title: '👨‍👩‍👧‍👦 Family',
                children: _profile!.familyMembers?.map((member) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Text(
                            '${member.relation}: ${member.name}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList() ?? [const Text('No family members added')],
              ),
              const SizedBox(height: 16),
              
              // Documents
              _buildSectionCard(
                title: '📄 Documents',
                children: _profile!.documents?.map((doc) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.name ?? 'Document',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList() ?? [const Text('No documents uploaded')],
              ),
              const SizedBox(height: 30),

              // ============================================================
              // ✅ ACTION BUTTONS - FIXED
              // ============================================================
              _buildActionButtons(provider),
              const SizedBox(height: 16),
              
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
      ),
    );
  }

  // ============================================================
  // ✅ STATUS CARD
  // ============================================================
  Widget _buildStatusCard(ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            provider.getStatusColor().withOpacity(0.1),
            provider.getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: provider.getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: provider.getStatusColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.getStatusIcon(),
              color: provider.getStatusColor(),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusTitle(provider.profileStatus),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: provider.getStatusColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.getStatusMessage(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                if (provider.isRejected && provider.rejectionReason != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Reason: ${provider.rejectionReason}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'draft':
        return '📝 Draft';
      case 'submitted':
        return '⏳ Submitted';
      case 'under_review':
        return '🔍 Under Review';
      case 'approved':
        return '✅ Approved';
      case 'rejected':
        return '❌ Rejected';
      default:
        return '📝 Draft';
    }
  }

  // ============================================================
  // ✅ ACTION BUTTONS - FIXED
  // ============================================================
  Widget _buildActionButtons(ProfileProvider provider) {
    // If approved - show success message
    if (provider.isApproved) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 12),
            const Text(
              '🎉 Profile Approved!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to BRAHMA community! 🕉️',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Go to Dashboard'),
              ),
            ),
          ],
        ),
      );
    }

    // If rejected - show resubmit button
    if (provider.isRejected) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _resubmitProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Resubmit for Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/personal_info'),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      );
    }

    // If submitted or under review - show waiting message
    if (provider.isSubmitted || provider.isUnderReview) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.hourglass_top,
              color: Colors.orange,
              size: 50,
            ),
            const SizedBox(height: 12),
            const Text(
              '⏳ Profile Under Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Admin is reviewing your profile.\nYou will be notified shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Default: Show Submit button - ALWAYS ENABLED ✅
    return Column(
      children: [
        // Profile completion status
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: provider.isProfileComplete() 
                ? Colors.green.withOpacity(0.1) 
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                provider.isProfileComplete() 
                    ? Icons.check_circle 
                    : Icons.warning,
                color: provider.isProfileComplete() 
                    ? Colors.green 
                    : Colors.red,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  provider.isProfileComplete() 
                      ? '✅ All sections completed' 
                      : '⚠️ Some sections incomplete (Family, Documents)',
                  style: TextStyle(
                    color: provider.isProfileComplete() 
                        ? Colors.green 
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting ? null : () {
                  context.go('/documents');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitProfile,  // ✅ Always enabled
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit for Review',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // ✅ BUILD SECTION CARD
  // ============================================================
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ✅ BUILD DETAIL ROW
  // ============================================================
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
              value ?? 'N/A',
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

  // ============================================================
  // ✅ HELPERS
  // ============================================================
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getFullAddress(Address? address) {
    if (address == null) return 'N/A';
    List<String> parts = [];
    if (address.houseNo?.isNotEmpty == true) parts.add(address.houseNo!);
    if (address.area?.isNotEmpty == true) parts.add(address.area!);
    if (address.city?.isNotEmpty == true) parts.add(address.city!);
    if (address.district?.isNotEmpty == true) parts.add(address.district!);
    if (address.state?.isNotEmpty == true) parts.add(address.state!);
    if (address.pincode?.isNotEmpty == true) parts.add(address.pincode!);
    return parts.isEmpty ? 'N/A' : parts.join(', ');
  }

  // ============================================================
  // ✅ ACTIONS
  // ============================================================
  void _submitProfile() async {
    setState(() => _isSubmitting = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.submitProfile();
    
    setState(() => _isSubmitting = false);
    
    _showSubmissionDialog(context);
  }

  void _resubmitProfile() async {
    setState(() => _isSubmitting = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.resubmitProfile();
    
    setState(() => _isSubmitting = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Profile resubmitted for review!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🕉️'),
            SizedBox(width: 8),
            Text('Profile Submitted!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your profile has been submitted for review.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.hourglass_top,
                    color: Colors.orange,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Under Review',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'Admin will review your profile shortly',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }
}