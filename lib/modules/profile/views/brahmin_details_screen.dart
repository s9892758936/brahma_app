import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brahma_app/core/theme/app_theme.dart';
import 'package:brahma_app/modules/profile/providers/profile_provider.dart';

class BrahminDetailsScreen extends StatefulWidget {
  const BrahminDetailsScreen({super.key});

  @override
  State<BrahminDetailsScreen> createState() => _BrahminDetailsScreenState();
}

class _BrahminDetailsScreenState extends State<BrahminDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  
  String? _brahminType;
  String? _gotra;
  String? _pravara;
  String? _pur;
  String? _kul;
  String? _kuldevta;
  String? _nativeVillage;
  String? _nativeDistrict;
  String? _nativeState;
  String? _vedicTradition;
  String? _sampradaya;
  String? _familyPriest;
  final _lineageController = TextEditingController();
  
  final List<String> _brahminTypes = [
    'Saryuparin', 'Shakdwipi', 'Kanyakubj', 'Maithil', 'Gaud', 'Saraswat', 'Utkala', 'Other'
  ];
  final List<String> _gotras = [
    'Bharadwaj', 'Shandilya', 'Kashyap', 'Vashishtha', 'Atri', 'Gautam', 'Jamadagni', 'Kaushik', 'Other'
  ];
  final List<String> _vedicTraditions = [
    'Shukla Yajurveda', 'Krishna Yajurveda', 'Rigveda', 'Samaveda', 'Atharvaveda',
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
    final data = provider.getBrahminDetails();
    
    if (data != null) {
      setState(() {
        _brahminType = data.brahminType;
        _gotra = data.gotra;
        _pravara = data.pravara;
        _pur = data.pur;
        _kul = data.kul;
        _kuldevta = data.kuldevta;
        _nativeVillage = data.nativeVillage;
        _nativeDistrict = data.nativeDistrict;
        _nativeState = data.nativeState;
        _vedicTradition = data.vedicTradition;
        _sampradaya = data.sampradaya;
        _familyPriest = data.familyPriest;
        _lineageController.text = data.lineageDescription ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brahmin Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/personal_info'),
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
                _buildProgressBar(2, 8),
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
                        '2',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Brahmin Community Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill your Brahmin community details',
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
                
                DropdownButtonFormField<String>(
                  value: _brahminType,
                  decoration: const InputDecoration(
                    labelText: 'Brahmin Category / Type *',
                    prefixIcon: Icon(Icons.group),
                  ),
                  items: _brahminTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (value) => setState(() => _brahminType = value),
                  validator: (value) => value == null ? 'Please select Brahmin type' : null,
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _gotra,
                  decoration: const InputDecoration(
                    labelText: 'Gotra *',
                    prefixIcon: Icon(Icons.family_restroom),
                  ),
                  items: _gotras.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (value) => setState(() => _gotra = value),
                  validator: (value) => value == null ? 'Please select Gotra' : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pravara',
                    prefixIcon: Icon(Icons.history),
                    hintText: 'Enter your Pravara',
                  ),
                  onChanged: (value) => _pravara = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pur / Vansh',
                    prefixIcon: Icon(Icons.timeline),
                    hintText: 'Enter your Pur or Vansh',
                  ),
                  onChanged: (value) => _pur = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kul',
                    prefixIcon: Icon(Icons.account_tree),
                    hintText: 'Enter your Kul',
                  ),
                  onChanged: (value) => _kul = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Kuldevta',
                    prefixIcon: Icon(Icons.temple_hindu),
                    hintText: 'Enter your Kuldevta',
                  ),
                  onChanged: (value) => _kuldevta = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Native Village',
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'Enter your native village',
                  ),
                  onChanged: (value) => _nativeVillage = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Native District',
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'Enter your native district',
                  ),
                  onChanged: (value) => _nativeDistrict = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Native State',
                    prefixIcon: Icon(Icons.map),
                    hintText: 'Enter your native state',
                  ),
                  onChanged: (value) => _nativeState = value,
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _vedicTradition,
                  decoration: const InputDecoration(
                    labelText: 'Vedic Tradition / Shakha',
                    prefixIcon: Icon(Icons.book),
                  ),
                  items: _vedicTraditions.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (value) => setState(() => _vedicTradition = value),
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Sampradaya',
                    prefixIcon: Icon(Icons.spa),
                    hintText: 'Enter your Sampradaya',
                  ),
                  onChanged: (value) => _sampradaya = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Family Priest / Guru (Optional)',
                    prefixIcon: Icon(Icons.people),
                    hintText: 'Enter family priest name',
                  ),
                  onChanged: (value) => _familyPriest = value,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _lineageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Family Lineage Description (Optional)',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'Tell us about your family lineage',
                    alignLabelWithHint: true,
                  ),
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
      
      provider.saveBrahminDetails(
        brahminType: _brahminType!,
        gotra: _gotra!,
        pravara: _pravara,
        pur: _pur,
        kul: _kul,
        kuldevta: _kuldevta,
        nativeVillage: _nativeVillage,
        nativeDistrict: _nativeDistrict,
        nativeState: _nativeState,
        vedicTradition: _vedicTradition,
        sampradaya: _sampradaya,
        familyPriest: _familyPriest,
        lineageDescription: _lineageController.text,
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
      
      provider.saveBrahminDetails(
        brahminType: _brahminType!,
        gotra: _gotra!,
        pravara: _pravara,
        pur: _pur,
        kul: _kul,
        kuldevta: _kuldevta,
        nativeVillage: _nativeVillage,
        nativeDistrict: _nativeDistrict,
        nativeState: _nativeState,
        vedicTradition: _vedicTradition,
        sampradaya: _sampradaya,
        familyPriest: _familyPriest,
        lineageDescription: _lineageController.text,
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
          context.go('/address');
        }
      });
    }
  }
}