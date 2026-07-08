import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final List<Map<String, dynamic>> _familyMembers = [];
  final _formKey = GlobalKey<FormState>();
  
  final _relationController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _occupationController = TextEditingController();
  final _educationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _maritalStatusController = TextEditingController();
  
  bool _showAddForm = false;
  String? _selectedRelation;
  String? _selectedGender;
  String? _selectedMaritalStatus;

  final List<String> _relations = [
    'Father', 'Mother', 'Brother', 'Sister', 'Spouse',
    'Son', 'Daughter', 'Grandfather', 'Grandmother', 'Uncle', 'Aunt', 'Other'
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatus = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedFamily();
    });
  }

  // ✅ Load saved family data
  void _loadSavedFamily() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final members = provider.getFamilyMembers();
    if (members != null) {
      setState(() {
        _familyMembers.clear();
        for (var m in members) {
          _familyMembers.add({
            'relation': m.relation ?? '',
            'name': m.name ?? '',
            'dob': m.dob?.toString() ?? '',
            'gender': m.gender ?? '',
            'occupation': m.occupation ?? '',
            'education': m.education ?? '',
            'mobile': m.mobileNumber ?? '',
            'maritalStatus': m.maritalStatus ?? '',
          });
        }
      });
    }
  }

  // ✅ Save family data to provider
  void _saveFamily() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    for (var member in _familyMembers) {
      provider.addFamilyMember(
        FamilyMember(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          relation: member['relation'],
          name: member['name'],
          gender: member['gender'],
          dob: member['dob']?.isNotEmpty == true ? DateTime.tryParse(member['dob']) : null,
          occupation: member['occupation'],
          education: member['education'],
          mobileNumber: member['mobile'],
          maritalStatus: member['maritalStatus'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/professional'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _showAddForm = !_showAddForm),
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
              _buildProgressBar(6, 8),
              const SizedBox(height: 24),
              
              // Step Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '6',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Family Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Add your family members',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              
              // Add Family Member Form
              if (_showAddForm) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedRelation,
                          decoration: const InputDecoration(
                            labelText: 'Relation *',
                            prefixIcon: Icon(Icons.family_restroom),
                          ),
                          items: _relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                          onChanged: (value) => setState(() => _selectedRelation = value),
                          validator: (value) => value == null ? 'Select relation' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enter full name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _dobController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                            hintText: 'DD/MM/YYYY',
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              _dobController.text = '${date.day}/${date.month}/${date.year}';
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (value) => setState(() => _selectedGender = value),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _occupationController,
                          decoration: const InputDecoration(
                            labelText: 'Occupation',
                            prefixIcon: Icon(Icons.work),
                            hintText: 'Enter occupation',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _educationController,
                          decoration: const InputDecoration(
                            labelText: 'Education',
                            prefixIcon: Icon(Icons.school),
                            hintText: 'Enter education',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Enter mobile number',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedMaritalStatus,
                          decoration: const InputDecoration(
                            labelText: 'Marital Status',
                            prefixIcon: Icon(Icons.favorite),
                          ),
                          items: _maritalStatus.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                          onChanged: (value) => setState(() => _selectedMaritalStatus = value),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _addFamilyMember,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                                child: const Text('Add Member'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() => _showAddForm = false),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Family Members List
              if (_familyMembers.isEmpty && !_showAddForm) ...[
                Center(
                  child: Column(
                    children: [
                      const Text(
                        '🕉️',
                        style: TextStyle(fontSize: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No family members added yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add family members',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _familyMembers.length,
                  itemBuilder: (context, index) {
                    final member = _familyMembers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            member['name']?.isNotEmpty == true
                                ? member['name'][0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(member['name'] ?? 'Unknown'),
                        subtitle: Text('Relation: ${member['relation'] ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _familyMembers.removeAt(index);
                            });
                            // ✅ Save after deletion
                            _saveFamily();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              
              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next: Social Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: AppTheme.accentColor, size: 18),
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

  void _addFamilyMember() {
    if (_nameController.text.isEmpty || _selectedRelation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill name and relation')),
      );
      return;
    }
    
    setState(() {
      _familyMembers.add({
        'relation': _selectedRelation,
        'name': _nameController.text,
        'dob': _dobController.text,
        'gender': _selectedGender,
        'occupation': _occupationController.text,
        'education': _educationController.text,
        'mobile': _mobileController.text,
        'maritalStatus': _selectedMaritalStatus,
      });
      _showAddForm = false;
      _clearForm();
    });
    
    // ✅ Save immediately
    _saveFamily();
  }

  void _clearForm() {
    _nameController.clear();
    _dobController.clear();
    _occupationController.clear();
    _educationController.clear();
    _mobileController.clear();
    _selectedRelation = null;
    _selectedGender = null;
    _selectedMaritalStatus = null;
  }

  void _saveAndContinue() {
    // ✅ Save family before navigating
    _saveFamily();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🕉️ Family details saved!'),
        duration: Duration(seconds: 1),
      ),
    );
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.go('/social');
      }
    });
  }
}