import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final List<Map<String, dynamic>> _documents = [];
  bool _isUploading = false;
  bool _isSaving = false;
  
  final List<Map<String, dynamic>> _requiredDocs = [
    {'name': 'Aadhaar Card', 'icon': Icons.credit_card, 'required': true},
    {'name': 'PAN Card', 'icon': Icons.credit_card, 'required': true},
    {'name': 'Passport Size Photo', 'icon': Icons.photo_camera, 'required': true},
  ];
  
  final List<Map<String, dynamic>> _optionalDocs = [
    {'name': 'Kundli', 'icon': Icons.description, 'required': false},
    {'name': '10th Certificate', 'icon': Icons.school, 'required': false},
    {'name': '12th Certificate', 'icon': Icons.school, 'required': false},
    {'name': 'Graduation Degree', 'icon': Icons.workspace_premium, 'required': false},
    {'name': 'Higher Education Certificates', 'icon': Icons.school, 'required': false},
    {'name': 'Government ID Card', 'icon': Icons.badge, 'required': false},
    {'name': 'Appointment Letter', 'icon': Icons.description, 'required': false},
    {'name': 'Employee ID Card', 'icon': Icons.badge, 'required': false},
    {'name': 'Family Certificate / Brahmin Proof', 'icon': Icons.family_restroom, 'required': false},
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedDocuments();
  }

  void _loadSavedDocuments() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final docs = provider.getDocuments();
    if (docs != null) {
      for (var doc in docs) {
        _documents.add({
          'name': doc.name,
          'file': File(doc.filePath ?? ''),
          'uploaded': true,
        });
      }
      setState(() {});
    }
  }

  void _saveDocuments() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    for (var doc in _documents) {
      if (doc['uploaded'] == true && doc['file'] != null) {
        provider.addDocument(
          Document(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: doc['name'],
            filePath: doc['file'].path,
            fileType: doc['file'].path.split('.').last,
            uploadDate: DateTime.now(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/social'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndContinue,
            tooltip: 'Save & Continue',
          ),
        ],
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
              _buildProgressBar(8, 8),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '8',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Document Upload',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your documents for verification',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              
              // Required Documents
              const Text(
                '📄 Required Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'These documents are mandatory for verification',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ..._requiredDocs.map((doc) => _buildDocumentTile(doc)),
              const SizedBox(height: 24),
              
              // Optional Documents
              const Text(
                '📄 Optional Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'These documents are optional but recommended',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ..._optionalDocs.map((doc) => _buildDocumentTile(doc)),
              const SizedBox(height: 24),
              
              // Upload Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supported Formats',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'PDF, JPG, PNG • Max size: 10 MB each',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              if (_isUploading)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Uploading document...'),
                    ],
                  ),
                ),
              if (_isUploading) const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Review Profile',
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
    );
  }

  Widget _buildDocumentTile(Map<String, dynamic> doc) {
    final isUploaded = _documents.any((d) => d['name'] == doc['name']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUploaded 
                ? Colors.green.withOpacity(0.1) 
                : AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isUploaded ? Icons.check_circle : doc['icon'],
            color: isUploaded ? Colors.green : AppTheme.primaryColor,
          ),
        ),
        title: Text(
          doc['name'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          isUploaded ? '✅ Uploaded' : 'Tap to upload',
          style: TextStyle(
            color: isUploaded ? Colors.green : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: isUploaded
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _documents.removeWhere((d) => d['name'] == doc['name']);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📄 Document removed'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              )
            : IconButton(
                icon: Icon(Icons.upload, color: AppTheme.primaryColor),
                onPressed: () => _uploadDocument(doc['name']),
              ),
        onTap: () => _uploadDocument(doc['name']),
      ),
    );
  }

  Future<void> _uploadDocument(String docName) async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final choice = await _showPickerOptions(context);
      if (choice == null) {
        setState(() {
          _isUploading = false;
        });
        return;
      }

      XFile? pickedFile;
      if (choice == 'camera') {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      } else if (choice == 'gallery') {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      }

      if (pickedFile != null) {
        await Future.delayed(const Duration(seconds: 1));
        
        setState(() {
          _documents.add({
            'name': docName,
            'file': File(pickedFile!.path),
            'uploaded': true,
          });
        });
        
        _saveDocuments();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $docName uploaded successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error uploading: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String?> _showPickerOptions(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: AppTheme.primaryColor),
              title: const Text('File'),
              onTap: () => Navigator.pop(context, 'file'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
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
    setState(() {
      _isSaving = true;
    });

    _saveDocuments();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        context.go('/review');
      }
    });
  }
}