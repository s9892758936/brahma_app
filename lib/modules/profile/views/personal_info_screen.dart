import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedBloodGroup;
  DateTime? _selectedDob;
  String? _profileImagePath;
  bool _isSaving = false;
  bool _isUploading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatus = ['Single', 'Married', 'Divorced', 'Widowed'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedData();
    });
  }

  void _loadSavedData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final data = provider.getPersonalInfo();
    
    if (data != null) {
      setState(() {
        _nameController.text = data['fullName'] ?? '';
        _selectedDob = data['dob'];
        _selectedGender = data['gender'];
        _selectedMaritalStatus = data['maritalStatus'];
        _mobileController.text = data['mobileNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        _selectedBloodGroup = data['bloodGroup'];
        _profileImagePath = data['profilePhoto'];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isSaved ? Icons.check_circle : Icons.save,
              color: provider.isSaved ? Colors.green : Colors.white,
            ),
            onPressed: _isSaving ? null : _saveData,
            tooltip: 'Save Data',
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressBar(1, 8),
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
                        '1',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your personal details',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                
                if (provider.isSaved)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('✅ Data saved successfully!'),
                      ],
                    ),
                  ),
                if (provider.isSaved) const SizedBox(height: 16),
                
                // Profile Photo
                _buildPhotoUpload(),
                const SizedBox(height: 16),
                
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter your full name',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter your name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // DOB
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth *',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Select your date of birth',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDob = date;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _selectedDob != null
                        ? '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}'
                        : '',
                  ),
                  validator: (value) {
                    if (_selectedDob == null) return 'Please select your date of birth';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Gender
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender *',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (value) => setState(() => _selectedGender = value),
                  validator: (value) => value == null ? 'Please select gender' : null,
                ),
                const SizedBox(height: 16),
                
                // Marital Status
                DropdownButtonFormField<String>(
                  value: _selectedMaritalStatus,
                  decoration: const InputDecoration(
                    labelText: 'Marital Status *',
                    prefixIcon: Icon(Icons.favorite),
                  ),
                  items: _maritalStatus.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (value) => setState(() => _selectedMaritalStatus = value),
                  validator: (value) => value == null ? 'Please select marital status' : null,
                ),
                const SizedBox(height: 16),
                
                // Mobile Number
                TextFormField(
                  controller: _mobileController,
                  enabled: true,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number *',
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Enter your mobile number',
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter mobile number';
                    if (value!.length < 10) return 'Enter 10-digit mobile number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email ID *',
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter email';
                    if (!value!.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Blood Group
                DropdownButtonFormField<String>(
                  value: _selectedBloodGroup,
                  decoration: const InputDecoration(
                    labelText: 'Blood Group (Optional)',
                    prefixIcon: Icon(Icons.bloodtype),
                  ),
                  items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (value) => setState(() => _selectedBloodGroup = value),
                ),
                const SizedBox(height: 30),
                
                // Save & Next Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveAndContinue,
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
                        : const Text(
                            'Save & Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Save as Draft
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _saveDraft,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save as Draft'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ PHOTO UPLOAD - FIXED
  // ============================================================
  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: AppTheme.primaryColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isUploading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _profileImagePath != null && _profileImagePath!.isNotEmpty
                    ? ClipOval(
                        child: Image.file(
                          File(_profileImagePath!),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add Photo',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
          // Camera Icon Overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ FIXED: Proper null safety for XFile
  Future<void> _pickImage() async {
    if (_isUploading) return;

    final choice = await _showPickerOptions(context);
    if (choice == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      XFile? pickedFile;
      if (choice == 'camera') {
        pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxWidth: 500,
          maxHeight: 500,
        );
      } else if (choice == 'gallery') {
        pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 500,
          maxHeight: 500,
        );
      }

      // ✅ Null check with safe access
      if (pickedFile != null) {
        final String path = pickedFile.path;  // Now safe because we checked null
        if (path.isNotEmpty) {
          setState(() {
            _profileImagePath = path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Photo uploaded successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ No image selected'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error uploading photo: $e'),
          duration: Duration(seconds: 2),
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
        title: const Text('Choose Photo Source'),
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

  void _saveData() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      final provider = Provider.of<ProfileProvider>(context, listen: false);
      
      provider.savePersonalInfo(
        fullName: _nameController.text.trim(),
        dob: _selectedDob!,
        gender: _selectedGender!,
        maritalStatus: _selectedMaritalStatus!,
        mobileNumber: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        bloodGroup: _selectedBloodGroup,
        profilePhoto: _profileImagePath,
      );

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🕉️ Data saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveDraft() {
    _saveData();
  }

  void _saveAndContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      final provider = Provider.of<ProfileProvider>(context, listen: false);
      
      provider.savePersonalInfo(
        fullName: _nameController.text.trim(),
        dob: _selectedDob!,
        gender: _selectedGender!,
        maritalStatus: _selectedMaritalStatus!,
        mobileNumber: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        bloodGroup: _selectedBloodGroup,
        profilePhoto: _profileImagePath,
      );

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🕉️ Data saved! Moving to next step...'),
          duration: Duration(seconds: 1),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          context.go('/brahmin_details');
        }
      });
    }
  }
}