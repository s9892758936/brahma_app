import 'package:flutter/material.dart';
import 'package:brahma_app/modules/profile/models/profile_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  bool _isSaved = false;
  String? _currentStep;
  String _profileStatus = 'draft';
  String? _rejectionReason;
  List<ProfileModel> _allProfiles = [];

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaved => _isSaved;
  String? get currentStep => _currentStep;
  String get profileStatus => _profileStatus;
  String? get rejectionReason => _rejectionReason;
  List<ProfileModel> get allProfiles => _allProfiles;

  bool get isUnderReview => _profileStatus == 'under_review';
  bool get isApproved => _profileStatus == 'approved';
  bool get isRejected => _profileStatus == 'rejected';
  bool get isDraft => _profileStatus == 'draft';
  bool get isSubmitted => _profileStatus == 'submitted';

  ProfileProvider() {
    _loadProfile();
    _loadAllProfiles();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('profile_data');
    if (data != null) {
      try {
        final json = jsonDecode(data);
        _profile = ProfileModel.fromJson(json);
        _profileStatus = _profile?.profileStatus ?? 'draft';
        _rejectionReason = _profile?.rejectionReason;
        _isSaved = true;
      } catch (e) {
        _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
      }
    } else {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
  }

  Future<void> _saveProfile() async {
    if (_profile != null) {
      final prefs = await SharedPreferences.getInstance();
      final data = _profile!.toJson();
      data['profileStatus'] = _profileStatus;
      data['rejectionReason'] = _rejectionReason;
      await prefs.setString('profile_data', jsonEncode(data));
      _isSaved = true;
      await _saveToAllProfiles();
    }
  }

  Future<void> _saveToAllProfiles() async {
    if (_profile == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final allData = prefs.getString('all_profiles');
    List<Map<String, dynamic>> profiles = [];
    
    if (allData != null) {
      try {
        profiles = (jsonDecode(allData) as List).cast<Map<String, dynamic>>();
      } catch (e) {
        profiles = [];
      }
    }
    
    // Remove existing profile if any
    profiles.removeWhere((p) => p['id'] == _profile!.id);
    
    // Add current profile
    final profileData = _profile!.toJson();
    profileData['profileStatus'] = _profileStatus;
    profileData['rejectionReason'] = _rejectionReason;
    profileData['submittedAt'] = DateTime.now().toIso8601String();
    profiles.add(profileData);
    
    await prefs.setString('all_profiles', jsonEncode(profiles));
  }

  Future<void> _loadAllProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final allData = prefs.getString('all_profiles');
    if (allData != null) {
      try {
        final List<dynamic> data = jsonDecode(allData);
        _allProfiles = data.map((item) => ProfileModel.fromJson(item)).toList();
      } catch (e) {
        _allProfiles = [];
      }
    } else {
      _allProfiles = [];
    }
  }

  Future<List<ProfileModel>> getAllProfiles() async {
    await _loadAllProfiles();
    return _allProfiles;
  }

  Future<List<ProfileModel>> getPendingProfiles() async {
    await _loadAllProfiles();
    return _allProfiles.where((p) => 
      p.profileStatus == 'submitted' || p.profileStatus == 'under_review'
    ).toList();
  }

  Future<void> approveProfileById(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = prefs.getString('all_profiles');
    if (allData == null) return;
    
    try {
      List<Map<String, dynamic>> profiles = (jsonDecode(allData) as List).cast<Map<String, dynamic>>();
      final index = profiles.indexWhere((p) => p['id'] == userId);
      if (index != -1) {
        profiles[index]['profileStatus'] = 'approved';
        profiles[index]['reviewedAt'] = DateTime.now().toIso8601String();
        profiles[index]['reviewedBy'] = 'admin';
        await prefs.setString('all_profiles', jsonEncode(profiles));
        await _loadAllProfiles();
        notifyListeners();
      }
    } catch (e) {
      print('Error approving profile: $e');
    }
  }

  Future<void> rejectProfileById(String userId, String reason) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = prefs.getString('all_profiles');
    if (allData == null) return;
    
    try {
      List<Map<String, dynamic>> profiles = (jsonDecode(allData) as List).cast<Map<String, dynamic>>();
      final index = profiles.indexWhere((p) => p['id'] == userId);
      if (index != -1) {
        profiles[index]['profileStatus'] = 'rejected';
        profiles[index]['rejectionReason'] = reason;
        profiles[index]['reviewedAt'] = DateTime.now().toIso8601String();
        profiles[index]['reviewedBy'] = 'admin';
        await prefs.setString('all_profiles', jsonEncode(profiles));
        await _loadAllProfiles();
        notifyListeners();
      }
    } catch (e) {
      print('Error rejecting profile: $e');
    }
  }

  Map<String, dynamic>? getPersonalInfo() {
    if (_profile == null) return null;
    return {
      'fullName': _profile!.fullName,
      'dob': _profile!.dob,
      'gender': _profile!.gender,
      'maritalStatus': _profile!.maritalStatus,
      'mobileNumber': _profile!.mobileNumber,
      'email': _profile!.email,
      'bloodGroup': _profile!.bloodGroup,
      'profilePhoto': _profile!.profilePhoto,
    };
  }

  BrahminDetails? getBrahminDetails() {
    return _profile?.brahminDetails;
  }

  Map<String, dynamic>? getAddress() {
    if (_profile == null) return null;
    return {
      'presentAddress': _profile!.presentAddress,
      'permanentAddress': _profile!.permanentAddress,
      'sameAsPresent': _profile!.sameAsPresent,
    };
  }

  EducationDetails? getEducation() {
    return _profile?.education;
  }

  ProfessionalDetails? getProfessional() {
    return _profile?.professional;
  }

  List<FamilyMember>? getFamilyMembers() {
    return _profile?.familyMembers;
  }

  Map<String, dynamic>? getSocial() {
    if (_profile == null) return null;
    return {
      'hobbies': _profile!.hobbies,
      'interests': _profile!.interests,
      'achievements': _profile!.achievements,
      'socialWork': _profile!.socialWork,
      'aboutYourself': _profile!.aboutYourself,
      'languagesKnown': _profile!.languagesKnown,
    };
  }

  List<Document>? getDocuments() {
    return _profile?.documents;
  }

  void savePersonalInfo({
    required String fullName,
    required DateTime dob,
    required String gender,
    required String maritalStatus,
    required String mobileNumber,
    required String email,
    String? bloodGroup,
    String? profilePhoto,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.fullName = fullName;
    _profile!.dob = dob;
    _profile!.gender = gender;
    _profile!.maritalStatus = maritalStatus;
    _profile!.mobileNumber = mobileNumber;
    _profile!.email = email;
    _profile!.bloodGroup = bloodGroup;
    _profile!.profilePhoto = profilePhoto;
    
    _isSaved = true;
    _currentStep = 'personal_info';
    _saveProfile();
    notifyListeners();
  }

  void saveBrahminDetails({
    required String brahminType,
    required String gotra,
    String? pravara,
    String? pur,
    String? kul,
    String? kuldevta,
    String? nativeVillage,
    String? nativeDistrict,
    String? nativeState,
    String? vedicTradition,
    String? sampradaya,
    String? familyPriest,
    String? lineageDescription,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.brahminDetails = BrahminDetails(
      brahminType: brahminType,
      gotra: gotra,
      pravara: pravara,
      pur: pur,
      kul: kul,
      kuldevta: kuldevta,
      nativeVillage: nativeVillage,
      nativeDistrict: nativeDistrict,
      nativeState: nativeState,
      vedicTradition: vedicTradition,
      sampradaya: sampradaya,
      familyPriest: familyPriest,
      lineageDescription: lineageDescription,
    );
    
    _isSaved = true;
    _currentStep = 'brahmin_details';
    _saveProfile();
    notifyListeners();
  }

  void saveAddress({
    required Address presentAddress,
    Address? permanentAddress,
    bool sameAsPresent = false,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.presentAddress = presentAddress;
    _profile!.permanentAddress = permanentAddress;
    _profile!.sameAsPresent = sameAsPresent;
    
    _isSaved = true;
    _currentStep = 'address';
    _saveProfile();
    notifyListeners();
  }

  void saveEducation({
    required EducationDetails education,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.education = education;
    _isSaved = true;
    _currentStep = 'education';
    _saveProfile();
    notifyListeners();
  }

  void saveProfessional({
    required ProfessionalDetails professional,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.professional = professional;
    _isSaved = true;
    _currentStep = 'professional';
    _saveProfile();
    notifyListeners();
  }

  void addFamilyMember(FamilyMember member) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.familyMembers ??= [];
    _profile!.familyMembers!.add(member);
    _isSaved = true;
    _currentStep = 'family';
    _saveProfile();
    notifyListeners();
  }

  void removeFamilyMember(String id) {
    if (_profile != null && _profile!.familyMembers != null) {
      _profile!.familyMembers!.removeWhere((m) => m.id == id);
      _saveProfile();
      notifyListeners();
    }
  }

  void saveSocial({
    List<String>? hobbies,
    List<String>? interests,
    List<String>? achievements,
    String? socialWork,
    String? aboutYourself,
    List<String>? languagesKnown,
  }) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.hobbies = hobbies;
    _profile!.interests = interests;
    _profile!.achievements = achievements;
    _profile!.socialWork = socialWork;
    _profile!.aboutYourself = aboutYourself;
    _profile!.languagesKnown = languagesKnown;
    
    _isSaved = true;
    _currentStep = 'social';
    _saveProfile();
    notifyListeners();
  }

  void addDocument(Document document) {
    if (_profile == null) {
      _profile = ProfileModel(id: DateTime.now().millisecondsSinceEpoch.toString());
    }
    
    _profile!.documents ??= [];
    _profile!.documents!.add(document);
    _isSaved = true;
    _currentStep = 'documents';
    _saveProfile();
    notifyListeners();
  }

  void removeDocument(String id) {
    if (_profile != null && _profile!.documents != null) {
      _profile!.documents!.removeWhere((d) => d.id == id);
      _saveProfile();
      notifyListeners();
    }
  }

  void submitProfile() {
    if (_profile != null) {
      _profileStatus = 'submitted';
      _isSaved = true;
      _saveProfile();
      notifyListeners();
    }
  }

  void approveProfile() {
    _profileStatus = 'approved';
    _rejectionReason = null;
    _saveProfile();
    notifyListeners();
  }

  void rejectProfile({String? reason}) {
    _profileStatus = 'rejected';
    _rejectionReason = reason ?? 'Not specified';
    _saveProfile();
    notifyListeners();
  }

  void underReviewProfile() {
    _profileStatus = 'under_review';
    _saveProfile();
    notifyListeners();
  }

  void resubmitProfile() {
    if (_profileStatus == 'rejected' || _profileStatus == 'draft') {
      _profileStatus = 'submitted';
      _rejectionReason = null;
      _saveProfile();
      notifyListeners();
    }
  }

  bool hasPersonalInfo() {
    return _profile?.fullName != null && _profile!.fullName!.isNotEmpty;
  }

  bool hasBrahminDetails() {
    return _profile?.brahminDetails != null;
  }

  bool hasAddress() {
    return _profile?.presentAddress != null;
  }

  bool hasEducation() {
    return _profile?.education != null;
  }

  bool hasProfessional() {
    return _profile?.professional != null;
  }

  bool hasFamily() {
    return _profile?.familyMembers != null && _profile!.familyMembers!.isNotEmpty;
  }

  bool hasSocial() {
    return _profile?.hobbies != null && _profile!.hobbies!.isNotEmpty;
  }

  bool hasDocuments() {
    return _profile?.documents != null && _profile!.documents!.isNotEmpty;
  }

  bool isProfileComplete() {
    if (_profile == null) return false;
    return hasPersonalInfo() &&
           hasBrahminDetails() &&
           hasAddress() &&
           hasEducation() &&
           hasProfessional() &&
           hasFamily() &&
           hasSocial() &&
           hasDocuments();
  }

  String getStatusMessage() {
    switch (_profileStatus) {
      case 'draft':
        return '📝 Profile is in draft. Please complete all steps.';
      case 'submitted':
        return '⏳ Profile submitted! Waiting for admin review.';
      case 'under_review':
        return '🔍 Profile is under review by admin. Please wait.';
      case 'approved':
        return '✅ Profile approved! Welcome to BRAHMA community! 🎉';
      case 'rejected':
        return '❌ Profile rejected. Please check your details and resubmit.';
      default:
        return '';
    }
  }

  Color getStatusColor() {
    switch (_profileStatus) {
      case 'draft':
        return Colors.grey;
      case 'submitted':
        return Colors.blue;
      case 'under_review':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (_profileStatus) {
      case 'draft':
        return Icons.edit;
      case 'submitted':
        return Icons.hourglass_empty;
      case 'under_review':
        return Icons.hourglass_top;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.edit;
    }
  }

  double getProgressPercentage() {
    int completed = 0;
    int total = 8;
    
    if (hasPersonalInfo()) completed++;
    if (hasBrahminDetails()) completed++;
    if (hasAddress()) completed++;
    if (hasEducation()) completed++;
    if (hasProfessional()) completed++;
    if (hasFamily()) completed++;
    if (hasSocial()) completed++;
    if (hasDocuments()) completed++;
    
    return completed / total;
  }

  int getCompletedSteps() {
    int completed = 0;
    if (hasPersonalInfo()) completed++;
    if (hasBrahminDetails()) completed++;
    if (hasAddress()) completed++;
    if (hasEducation()) completed++;
    if (hasProfessional()) completed++;
    if (hasFamily()) completed++;
    if (hasSocial()) completed++;
    if (hasDocuments()) completed++;
    return completed;
  }

  void clearProfile() {
    _profile = null;
    _isSaved = false;
    _currentStep = null;
    _profileStatus = 'draft';
    _rejectionReason = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('profile_data');
    });
    notifyListeners();
  }
}