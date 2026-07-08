import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _sameAsPresent = false;
  bool _isSaving = false;
  
  // Present Address Controllers
  final _presentHouseController = TextEditingController();
  final _presentAreaController = TextEditingController();
  final _presentCityController = TextEditingController();
  final _presentDistrictController = TextEditingController();
  final _presentStateController = TextEditingController();
  final _presentPincodeController = TextEditingController();
  
  // Permanent Address Controllers
  final _permanentHouseController = TextEditingController();
  final _permanentAreaController = TextEditingController();
  final _permanentCityController = TextEditingController();
  final _permanentDistrictController = TextEditingController();
  final _permanentStateController = TextEditingController();
  final _permanentPincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedData();
    });
  }

  void _loadSavedData() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final data = provider.getAddress();
    
    if (data != null) {
      setState(() {
        _sameAsPresent = data['sameAsPresent'] ?? false;
        
        final present = data['presentAddress'];
        if (present != null) {
          _presentHouseController.text = present.houseNo ?? '';
          _presentAreaController.text = present.area ?? '';
          _presentCityController.text = present.city ?? '';
          _presentDistrictController.text = present.district ?? '';
          _presentStateController.text = present.state ?? '';
          _presentPincodeController.text = present.pincode ?? '';
        }
        
        if (_sameAsPresent) {
          _copyPresentToPermanent();
        } else {
          final permanent = data['permanentAddress'];
          if (permanent != null) {
            _permanentHouseController.text = permanent.houseNo ?? '';
            _permanentAreaController.text = permanent.area ?? '';
            _permanentCityController.text = permanent.city ?? '';
            _permanentDistrictController.text = permanent.district ?? '';
            _permanentStateController.text = permanent.state ?? '';
            _permanentPincodeController.text = permanent.pincode ?? '';
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _presentHouseController.dispose();
    _presentAreaController.dispose();
    _presentCityController.dispose();
    _presentDistrictController.dispose();
    _presentStateController.dispose();
    _presentPincodeController.dispose();
    _permanentHouseController.dispose();
    _permanentAreaController.dispose();
    _permanentCityController.dispose();
    _permanentDistrictController.dispose();
    _permanentStateController.dispose();
    _permanentPincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/brahmin_details'),
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
                _buildProgressBar(3, 8),
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
                        '3',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Address Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your address details',
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
                
                // Present Address
                const Text(
                  '📍 Present Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentHouseController,
                  decoration: const InputDecoration(
                    labelText: 'House Number *',
                    prefixIcon: Icon(Icons.home),
                    hintText: 'Enter house number',
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Enter house number' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentAreaController,
                  decoration: const InputDecoration(
                    labelText: 'Area / Locality *',
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'Enter area',
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Enter area' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentCityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Enter city',
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Enter city' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentDistrictController,
                  decoration: const InputDecoration(
                    labelText: 'District *',
                    prefixIcon: Icon(Icons.map),
                    hintText: 'Enter district',
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Enter district' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentStateController,
                  decoration: const InputDecoration(
                    labelText: 'State *',
                    prefixIcon: Icon(Icons.flag),
                    hintText: 'Enter state',
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Enter state' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _presentPincodeController,
                  decoration: const InputDecoration(
                    labelText: 'Pincode *',
                    prefixIcon: Icon(Icons.numbers),
                    hintText: 'Enter pincode',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter pincode';
                    if (value!.length < 6) return 'Enter 6-digit pincode';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Same as Present
                CheckboxListTile(
                  title: const Text(
                    'Same as Present Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Check if your permanent address is same as present'),
                  value: _sameAsPresent,
                  onChanged: (value) {
                    setState(() {
                      _sameAsPresent = value ?? false;
                      if (_sameAsPresent) {
                        _copyPresentToPermanent();
                      }
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                  tileColor: AppTheme.primaryColor.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Permanent Address
                const Text(
                  '🏠 Permanent Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentHouseController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'House Number *',
                    prefixIcon: Icon(Icons.home),
                    hintText: 'Enter house number',
                  ),
                  validator: (value) {
                    if (!_sameAsPresent && (value?.isEmpty ?? true)) {
                      return 'Enter house number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentAreaController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'Area / Locality *',
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'Enter area',
                  ),
                  validator: (value) {
                    if (!_sameAsPresent && (value?.isEmpty ?? true)) {
                      return 'Enter area';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentCityController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Enter city',
                  ),
                  validator: (value) {
                    if (!_sameAsPresent && (value?.isEmpty ?? true)) {
                      return 'Enter city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentDistrictController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'District *',
                    prefixIcon: Icon(Icons.map),
                    hintText: 'Enter district',
                  ),
                  validator: (value) {
                    if (!_sameAsPresent && (value?.isEmpty ?? true)) {
                      return 'Enter district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentStateController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'State *',
                    prefixIcon: Icon(Icons.flag),
                    hintText: 'Enter state',
                  ),
                  validator: (value) {
                    if (!_sameAsPresent && (value?.isEmpty ?? true)) {
                      return 'Enter state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _permanentPincodeController,
                  enabled: !_sameAsPresent,
                  decoration: const InputDecoration(
                    labelText: 'Pincode *',
                    prefixIcon: Icon(Icons.numbers),
                    hintText: 'Enter pincode',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!_sameAsPresent) {
                      if (value?.isEmpty ?? true) return 'Enter pincode';
                      if (value!.length < 6) return 'Enter 6-digit pincode';
                    }
                    return null;
                  },
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

  void _copyPresentToPermanent() {
    _permanentHouseController.text = _presentHouseController.text;
    _permanentAreaController.text = _presentAreaController.text;
    _permanentCityController.text = _presentCityController.text;
    _permanentDistrictController.text = _presentDistrictController.text;
    _permanentStateController.text = _presentStateController.text;
    _permanentPincodeController.text = _presentPincodeController.text;
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
      
      final presentAddress = Address(
        houseNo: _presentHouseController.text.trim(),
        area: _presentAreaController.text.trim(),
        city: _presentCityController.text.trim(),
        district: _presentDistrictController.text.trim(),
        state: _presentStateController.text.trim(),
        pincode: _presentPincodeController.text.trim(),
      );
      
      Address? permanentAddress;
      if (!_sameAsPresent) {
        permanentAddress = Address(
          houseNo: _permanentHouseController.text.trim(),
          area: _permanentAreaController.text.trim(),
          city: _permanentCityController.text.trim(),
          district: _permanentDistrictController.text.trim(),
          state: _permanentStateController.text.trim(),
          pincode: _permanentPincodeController.text.trim(),
        );
      }
      
      provider.saveAddress(
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        sameAsPresent: _sameAsPresent,
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
      
      final presentAddress = Address(
        houseNo: _presentHouseController.text.trim(),
        area: _presentAreaController.text.trim(),
        city: _presentCityController.text.trim(),
        district: _presentDistrictController.text.trim(),
        state: _presentStateController.text.trim(),
        pincode: _presentPincodeController.text.trim(),
      );
      
      Address? permanentAddress;
      if (!_sameAsPresent) {
        permanentAddress = Address(
          houseNo: _permanentHouseController.text.trim(),
          area: _permanentAreaController.text.trim(),
          city: _permanentCityController.text.trim(),
          district: _permanentDistrictController.text.trim(),
          state: _permanentStateController.text.trim(),
          pincode: _permanentPincodeController.text.trim(),
        );
      }
      
      provider.saveAddress(
        presentAddress: presentAddress,
        permanentAddress: permanentAddress,
        sameAsPresent: _sameAsPresent,
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
          context.go('/education');
        }
      });
    }
  }
}