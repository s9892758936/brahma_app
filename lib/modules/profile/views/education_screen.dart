import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  
  bool? _is10thPassed;
  bool? _is12thPassed;
  
  final _tenthBoardController = TextEditingController();
  final _tenthMarksController = TextEditingController();
  final _tenthYearController = TextEditingController();
  final _twelfthBoardController = TextEditingController();
  final _twelfthMarksController = TextEditingController();
  final _twelfthYearController = TextEditingController();
  final _degreeController = TextEditingController();
  final _collegeController = TextEditingController();
  final _universityController = TextEditingController();
  final _marksController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _higherStudiesController = TextEditingController();
  final _higherStudiesInstitutionController = TextEditingController();
  final _higherStudiesYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedData();
    });
  }

  void _loadSavedData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final data = provider.getEducation();
    
    if (data != null) {
      setState(() {
        _is10thPassed = data.is10thPassed;
        _is12thPassed = data.is12thPassed;
        _tenthBoardController.text = data.tenthBoard ?? '';
        _tenthMarksController.text = data.tenthMarks ?? '';
        _tenthYearController.text = data.tenthYear ?? '';
        _twelfthBoardController.text = data.twelfthBoard ?? '';
        _twelfthMarksController.text = data.twelfthMarks ?? '';
        _twelfthYearController.text = data.twelfthYear ?? '';
        _degreeController.text = data.graduation ?? '';
        _collegeController.text = data.college ?? '';
        _universityController.text = data.university ?? '';
        _marksController.text = data.marks ?? '';
        _graduationYearController.text = data.graduationYear ?? '';
        _higherStudiesController.text = data.higherStudies ?? '';
        _higherStudiesInstitutionController.text = data.higherStudiesInstitution ?? '';
        _higherStudiesYearController.text = data.higherStudiesYear ?? '';
      });
    }
  }

  @override
  void dispose() {
    _tenthBoardController.dispose();
    _tenthMarksController.dispose();
    _tenthYearController.dispose();
    _twelfthBoardController.dispose();
    _twelfthMarksController.dispose();
    _twelfthYearController.dispose();
    _degreeController.dispose();
    _collegeController.dispose();
    _universityController.dispose();
    _marksController.dispose();
    _graduationYearController.dispose();
    _higherStudiesController.dispose();
    _higherStudiesInstitutionController.dispose();
    _higherStudiesYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/address'),
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
                _buildProgressBar(4, 8),
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
                        '4',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Education Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your education details',
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
                
                // 10th
                const Text(
                  '📚 10th Standard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Passed'),
                        value: true,
                        groupValue: _is10thPassed,
                        onChanged: (value) => setState(() => _is10thPassed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Not Passed'),
                        value: false,
                        groupValue: _is10thPassed,
                        onChanged: (value) => setState(() => _is10thPassed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _tenthBoardController,
                  decoration: const InputDecoration(
                    labelText: 'Board',
                    prefixIcon: Icon(Icons.school),
                    hintText: 'Enter board name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _tenthMarksController,
                  decoration: const InputDecoration(
                    labelText: 'Marks %',
                    prefixIcon: Icon(Icons.percent),
                    hintText: 'Enter percentage',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _tenthYearController,
                  decoration: const InputDecoration(
                    labelText: 'Passing Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Enter passing year',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // 12th
                const Text(
                  '📚 12th Standard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Passed'),
                        value: true,
                        groupValue: _is12thPassed,
                        onChanged: (value) => setState(() => _is12thPassed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Not Passed'),
                        value: false,
                        groupValue: _is12thPassed,
                        onChanged: (value) => setState(() => _is12thPassed = value),
                        activeColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _twelfthBoardController,
                  decoration: const InputDecoration(
                    labelText: 'Board',
                    prefixIcon: Icon(Icons.school),
                    hintText: 'Enter board name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _twelfthMarksController,
                  decoration: const InputDecoration(
                    labelText: 'Marks %',
                    prefixIcon: Icon(Icons.percent),
                    hintText: 'Enter percentage',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _twelfthYearController,
                  decoration: const InputDecoration(
                    labelText: 'Passing Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Enter passing year',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // Graduation
                const Text(
                  '🎓 Graduation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Degree',
                    prefixIcon: Icon(Icons.workspace_premium),
                    hintText: 'Enter degree name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _collegeController,
                  decoration: const InputDecoration(
                    labelText: 'College',
                    prefixIcon: Icon(Icons.business),
                    hintText: 'Enter college name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _universityController,
                  decoration: const InputDecoration(
                    labelText: 'University',
                    prefixIcon: Icon(Icons.account_balance),
                    hintText: 'Enter university name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _marksController,
                  decoration: const InputDecoration(
                    labelText: 'Marks / CGPA',
                    prefixIcon: Icon(Icons.percent),
                    hintText: 'Enter marks or CGPA',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _graduationYearController,
                  decoration: const InputDecoration(
                    labelText: 'Passing Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Enter passing year',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                
                // Higher Studies
                const Text(
                  '📖 Higher Studies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _higherStudiesController,
                  decoration: const InputDecoration(
                    labelText: 'Masters / PhD / Diploma',
                    prefixIcon: Icon(Icons.school),
                    hintText: 'Enter higher studies',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _higherStudiesInstitutionController,
                  decoration: const InputDecoration(
                    labelText: 'Institution',
                    prefixIcon: Icon(Icons.business),
                    hintText: 'Enter institution name',
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _higherStudiesYearController,
                  decoration: const InputDecoration(
                    labelText: 'Completion Year',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Enter completion year',
                  ),
                  keyboardType: TextInputType.number,
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
      
      final education = EducationDetails(
        is10thPassed: _is10thPassed,
        tenthBoard: _tenthBoardController.text.trim(),
        tenthMarks: _tenthMarksController.text.trim(),
        tenthYear: _tenthYearController.text.trim(),
        is12thPassed: _is12thPassed,
        twelfthBoard: _twelfthBoardController.text.trim(),
        twelfthMarks: _twelfthMarksController.text.trim(),
        twelfthYear: _twelfthYearController.text.trim(),
        graduation: _degreeController.text.trim(),
        college: _collegeController.text.trim(),
        university: _universityController.text.trim(),
        marks: _marksController.text.trim(),
        graduationYear: _graduationYearController.text.trim(),
        higherStudies: _higherStudiesController.text.trim(),
        higherStudiesInstitution: _higherStudiesInstitutionController.text.trim(),
        higherStudiesYear: _higherStudiesYearController.text.trim(),
      );
      
      provider.saveEducation(education: education);

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
      
      final education = EducationDetails(
        is10thPassed: _is10thPassed,
        tenthBoard: _tenthBoardController.text.trim(),
        tenthMarks: _tenthMarksController.text.trim(),
        tenthYear: _tenthYearController.text.trim(),
        is12thPassed: _is12thPassed,
        twelfthBoard: _twelfthBoardController.text.trim(),
        twelfthMarks: _twelfthMarksController.text.trim(),
        twelfthYear: _twelfthYearController.text.trim(),
        graduation: _degreeController.text.trim(),
        college: _collegeController.text.trim(),
        university: _universityController.text.trim(),
        marks: _marksController.text.trim(),
        graduationYear: _graduationYearController.text.trim(),
        higherStudies: _higherStudiesController.text.trim(),
        higherStudiesInstitution: _higherStudiesInstitutionController.text.trim(),
        higherStudiesYear: _higherStudiesYearController.text.trim(),
      );
      
      provider.saveEducation(education: education);

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
          context.go('/professional');
        }
      });
    }
  }
}