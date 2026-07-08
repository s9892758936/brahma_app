import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class ProfessionalScreen extends StatefulWidget {
  const ProfessionalScreen({super.key});

  @override
  State<ProfessionalScreen> createState() => _ProfessionalScreenState();
}

class _ProfessionalScreenState extends State<ProfessionalScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool? _isEmployed;
  String? _employmentType;
  String? _serviceType;
  
  final _professionController = TextEditingController();
  final _designationController = TextEditingController();
  final _organizationController = TextEditingController();
  final _departmentController = TextEditingController();
  final _workLocationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _pastExperienceController = TextEditingController();
  final _batchYearController = TextEditingController();
  final _employeeIdController = TextEditingController();
  List<String> _skills = [];

  final List<String> _employmentTypes = [
    'Government', 'Private', 'Business', 'Student', 'Self Employed', 'Retired',
  ];
  final List<String> _serviceTypes = [
    'IAS', 'IPS', 'IRS', 'PCS', 'Army', 'Bank', 'PSU', 'Other',
  ];
  final List<String> _skillOptions = [
    'Leadership', 'Communication', 'Management', 'Teaching', 'Coding',
    'Writing', 'Public Speaking', 'Yoga',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedData();
    });
  }

  void _loadSavedData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final data = provider.getProfessional();
    
    if (data != null) {
      setState(() {
        _isEmployed = data.isEmployed;
        _employmentType = data.employmentType;
        _serviceType = data.serviceType;
        _professionController.text = data.profession ?? '';
        _designationController.text = data.designation ?? '';
        _organizationController.text = data.organization ?? '';
        _departmentController.text = data.department ?? '';
        _workLocationController.text = data.workLocation ?? '';
        _experienceController.text = data.experience ?? '';
        _pastExperienceController.text = data.pastExperience ?? '';
        _batchYearController.text = data.batchYear ?? '';
        _employeeIdController.text = data.employeeId ?? '';
        _skills = data.skills ?? [];
      });
    }
  }

  @override
  void dispose() {
    _professionController.dispose();
    _designationController.dispose();
    _organizationController.dispose();
    _departmentController.dispose();
    _workLocationController.dispose();
    _experienceController.dispose();
    _pastExperienceController.dispose();
    _batchYearController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/education'),
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
                _buildProgressBar(5, 8),
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
                        '5',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Professional Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your professional details',
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
                
                const Text(
                  'Are you employed?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Yes'),
                        value: true,
                        groupValue: _isEmployed,
                        onChanged: (value) => setState(() => _isEmployed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: _isEmployed,
                        onChanged: (value) => setState(() => _isEmployed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _employmentType,
                  decoration: const InputDecoration(
                    labelText: 'Employment Type *',
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: _employmentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (value) => setState(() => _employmentType = value),
                  validator: (value) => value == null ? 'Select employment type' : null,
                ),
                const SizedBox(height: 16),
                
                if (_employmentType == 'Government') ...[
                  DropdownButtonFormField<String>(
                    value: _serviceType,
                    decoration: const InputDecoration(
                      labelText: 'Service Type',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    items: _serviceTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (value) => setState(() => _serviceType = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _batchYearController,
                    decoration: const InputDecoration(
                      labelText: 'Batch Year',
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Enter batch year',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _employeeIdController,
                    decoration: const InputDecoration(
                      labelText: 'Employee ID',
                      prefixIcon: Icon(Icons.badge),
                      hintText: 'Enter employee ID',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                TextFormField(
                  controller: _professionController,
                  decoration: const InputDecoration(
                    labelText: 'Present Profession *',
                    prefixIcon: Icon(Icons.work),
                    hintText: 'Enter your profession',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter your profession';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _designationController,
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                    prefixIcon: Icon(Icons.work_outline),
                    hintText: 'Enter your designation',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _organizationController,
                  decoration: const InputDecoration(
                    labelText: 'Organization / Company',
                    prefixIcon: Icon(Icons.business),
                    hintText: 'Enter organization name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.account_tree),
                    hintText: 'Enter department name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _workLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Work Location',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Enter work location',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Years of Experience',
                    prefixIcon: Icon(Icons.timer),
                    hintText: 'Enter years of experience',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _pastExperienceController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Past Experience',
                    prefixIcon: Icon(Icons.history),
                    hintText: 'Describe your past experience',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skillOptions.map((skill) {
                    final isSelected = _skills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: isSelected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _skills.add(skill);
                          } else {
                            _skills.remove(skill);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
                      ),
                      checkmarkColor: AppTheme.primaryColor,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                
                // ✅ Save & Next Button
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
      
      final professional = ProfessionalDetails(
        isEmployed: _isEmployed,
        employmentType: _employmentType,
        serviceType: _serviceType,
        profession: _professionController.text.trim(),
        designation: _designationController.text.trim(),
        organization: _organizationController.text.trim(),
        department: _departmentController.text.trim(),
        workLocation: _workLocationController.text.trim(),
        experience: _experienceController.text.trim(),
        pastExperience: _pastExperienceController.text.trim(),
        skills: _skills,
        batchYear: _batchYearController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
      );
      
      provider.saveProfessional(professional: professional);

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
      
      final professional = ProfessionalDetails(
        isEmployed: _isEmployed,
        employmentType: _employmentType,
        serviceType: _serviceType,
        profession: _professionController.text.trim(),
        designation: _designationController.text.trim(),
        organization: _organizationController.text.trim(),
        department: _departmentController.text.trim(),
        workLocation: _workLocationController.text.trim(),
        experience: _experienceController.text.trim(),
        pastExperience: _pastExperienceController.text.trim(),
        skills: _skills,
        batchYear: _batchYearController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
      );
      
      provider.saveProfessional(professional: professional);

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
          context.go('/family');
        }
      });
    }
  }
}