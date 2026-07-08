import 'package:flutter/material.dart';
import 'dart:math';

class AnalyticsProvider extends ChangeNotifier {
  // ============================================================
  // 📊 DATA STORES
  // ============================================================
  bool _isLoading = false;
  
  // Metrics
  int _totalUsers = 0;
  int _activeUsers = 0;
  int _newRegistrations = 0;
  double _approvalRate = 0.0;
  
  // Growth
  String _userGrowth = '+0%';
  String _activeGrowth = '+0%';
  String _registrationGrowth = '+0%';
  String _approvalGrowth = '+0%';
  
  // Chart Data
  List<Map<String, dynamic>> _userGrowthData = [];
  
  // Distribution
  Map<String, int> _genderDistribution = {};
  Map<String, int> _profileTypeDistribution = {};
  Map<String, int> _topStates = {};
  
  // Engagement
  int _totalMessages = 0;
  int _totalPosts = 0;
  int _totalLikes = 0;
  int _totalComments = 0;

  // ============================================================
  // 📤 GETTERS
  // ============================================================
  bool get isLoading => _isLoading;
  
  int get totalUsers => _totalUsers;
  int get activeUsers => _activeUsers;
  int get newRegistrations => _newRegistrations;
  double get approvalRate => _approvalRate;
  
  String get userGrowth => _userGrowth;
  String get activeGrowth => _activeGrowth;
  String get registrationGrowth => _registrationGrowth;
  String get approvalGrowth => _approvalGrowth;
  
  List<Map<String, dynamic>> get userGrowthData => _userGrowthData;
  
  Map<String, int> get genderDistribution => _genderDistribution;
  Map<String, int> get profileTypeDistribution => _profileTypeDistribution;
  Map<String, int> get topStates => _topStates;
  
  int get totalMessages => _totalMessages;
  int get totalPosts => _totalPosts;
  int get totalLikes => _totalLikes;
  int get totalComments => _totalComments;

  // ============================================================
  // 🚀 LOAD DATA
  // ============================================================
  void loadAnalyticsData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final random = Random();
      
      // Metrics
      _totalUsers = 2847;
      _activeUsers = 342;
      _newRegistrations = 56;
      _approvalRate = 68.5;
      
      // Growth
      _userGrowth = '+12.5%';
      _activeGrowth = '+8.3%';
      _registrationGrowth = '+15.2%';
      _approvalGrowth = '+5.7%';
      
      // User Growth Data (Last 7 days)
      _userGrowthData = List.generate(7, (index) {
        final day = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
        return {
          'day': day,
          'count': 20 + index * 5 + random.nextInt(15),
        };
      });
      
      // Gender Distribution
      _genderDistribution = {
        'Male': 65 + random.nextInt(10),
        'Female': 30 + random.nextInt(10),
        'Other': 5 + random.nextInt(5),
      };
      
      // Profile Type Distribution
      _profileTypeDistribution = {
        'General': 45 + random.nextInt(10),
        'Professional': 35 + random.nextInt(10),
        'Elite': 20 + random.nextInt(10),
      };
      
      // Top States
      _topStates = {
        'Uttar Pradesh': 1250,
        'Bihar': 890,
        'Delhi': 540,
        'Maharashtra': 420,
        'Rajasthan': 380,
        'Madhya Pradesh': 320,
      };
      
      // Engagement Stats
      _totalMessages = 2847;
      _totalPosts = 1250;
      _totalLikes = 8432;
      _totalComments = 2145;
      
      _isLoading = false;
      notifyListeners();
    });
  }
}