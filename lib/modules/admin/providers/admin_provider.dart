import 'package:flutter/material.dart';
import 'dart:math';
import 'package:brahma_app/modules/admin/models/admin_models.dart';

class AdminProvider extends ChangeNotifier {
  List<ProfileReview> _pendingReviews = [];
  List<ProfileReview> _filteredReviews = [];
  bool _isLoading = false;
  String _selectedFilter = 'all';
  String _searchQuery = '';
  DashboardStats _stats = DashboardStats();
  AnalyticsData _analytics = AnalyticsData();

  List<ProfileReview> get pendingReviews => _filteredReviews;
  List<ProfileReview> get allReviews => _pendingReviews;
  bool get isLoading => _isLoading;
  DashboardStats get stats => _stats;
  AnalyticsData get analytics => _analytics;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  int get pendingCount => _pendingReviews.where((r) => r.status == UserStatus.submitted || r.status == UserStatus.underReview).length;
  int get priorityCount => _pendingReviews.where((r) => r.isPriority && (r.status == UserStatus.submitted || r.status == UserStatus.underReview)).length;

  void loadAllData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _loadSampleReviews();
      _calculateStats();
      _loadAnalyticsData();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _loadSampleReviews() {
    final random = Random();
    final now = DateTime.now();
    
    _pendingReviews = List.generate(25, (index) {
      final statuses = [UserStatus.submitted, UserStatus.submitted, UserStatus.submitted, UserStatus.underReview];
      final types = [UserProfileType.general, UserProfileType.professional, UserProfileType.elite];
      final states = ['Uttar Pradesh', 'Bihar', 'Delhi', 'Maharashtra', 'Rajasthan', 'Madhya Pradesh'];
      final districts = ['Varanasi', 'Patna', 'New Delhi', 'Mumbai', 'Jaipur', 'Bhopal', 'Lucknow', 'Kanpur'];
      final brahminTypes = ['Saryuparin', 'Shakdwipi', 'Kanyakubj', 'Maithil', 'Gaud'];
      final gotras = ['Bharadwaj', 'Shandilya', 'Kashyap', 'Vashishtha', 'Atri'];
      final names = ['Rahul Sharma', 'Priya Patel', 'Amit Singh', 'Sneha Verma', 'Vikram Yadav', 'Neha Gupta', 'Rajesh Kumar', 'Anjali Mishra'];
      
      final type = types[random.nextInt(types.length)];
      final status = statuses[random.nextInt(statuses.length)];
      final daysAgo = random.nextInt(14);
      
      return ProfileReview(
        id: 'review_${now.millisecondsSinceEpoch}_$index',
        userId: 'user_${1000 + index}',
        userName: names[random.nextInt(names.length)],
        phone: '987654${1000 + index}',
        email: 'user${1000 + index}@email.com',
        state: states[random.nextInt(states.length)],
        district: districts[random.nextInt(districts.length)],
        profileType: type,
        status: status,
        brahminType: brahminTypes[random.nextInt(brahminTypes.length)],
        gotra: gotras[random.nextInt(gotras.length)],
        submittedDate: now.subtract(Duration(days: daysAgo, hours: random.nextInt(24))),
        verificationScore: (60 + random.nextInt(35)).toDouble(),
        documentCount: 2 + random.nextInt(4),
        remarks: [],
      );
    })..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));

    _filteredReviews = _pendingReviews;
  }

  void _calculateStats() {
    _stats = DashboardStats(
      totalUsers: 2847,
      approvedUsers: _pendingReviews.where((r) => r.status == UserStatus.approved).length,
      pendingReviews: pendingCount,
      rejectedProfiles: _pendingReviews.where((r) => r.status == UserStatus.rejected).length,
      activeToday: 342,
      newRegistrations: 56,
      eliteMembers: _pendingReviews.where((r) => r.profileType == UserProfileType.elite && r.status == UserStatus.approved).length,
      paidMembers: 178,
    );
  }

  void _loadAnalyticsData() {
    final now = DateTime.now();
    _analytics = AnalyticsData(
      stateWiseGrowth: {
        'Uttar Pradesh': 1250,
        'Bihar': 890,
        'Delhi': 540,
        'Maharashtra': 420,
        'Rajasthan': 380,
        'Madhya Pradesh': 320,
      },
      districtWiseGrowth: {
        'Varanasi': 450,
        'Patna': 320,
        'Lucknow': 280,
        'Jaipur': 250,
        'Mumbai': 220,
      },
      professionDistribution: {
        'Engineer': 320,
        'Doctor': 280,
        'Lawyer': 180,
        'Teacher': 250,
        'Business': 200,
        'Student': 400,
      },
      gotraDistribution: {
        'Bharadwaj': 320,
        'Shandilya': 280,
        'Kashyap': 250,
        'Vashishtha': 200,
        'Atri': 180,
      },
      dailyRegistrations: List.generate(7, (index) {
        return DailyRegistration(
          date: now.subtract(Duration(days: 6 - index)),
          count: 20 + index * 5 + Random().nextInt(10),
        );
      }),
      approvalRatio: 68.5,
      engagementRate: 42.3,
    );
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilter();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_selectedFilter == 'pending') {
      _filteredReviews = _pendingReviews.where((r) => 
        r.status == UserStatus.submitted || r.status == UserStatus.underReview
      ).toList();
    } else if (_selectedFilter == 'priority') {
      _filteredReviews = _pendingReviews.where((r) => 
        r.isPriority && (r.status == UserStatus.submitted || r.status == UserStatus.underReview)
      ).toList();
    } else if (_selectedFilter == 'elite') {
      _filteredReviews = _pendingReviews.where((r) => 
        r.profileType == UserProfileType.elite
      ).toList();
    } else if (_selectedFilter == 'resubmission') {
      _filteredReviews = _pendingReviews.where((r) => 
        r.isResubmission
      ).toList();
    } else {
      _filteredReviews = _pendingReviews;
    }
    
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      _filteredReviews = _filteredReviews.where((r) =>
        r.userName.toLowerCase().contains(q) ||
        r.phone.contains(q) ||
        r.email.toLowerCase().contains(q)
      ).toList();
    }
    notifyListeners();
  }

  void approveUser(String reviewId, String remarks) {
    _updateReviewStatus(reviewId, UserStatus.approved, remarks);
    _calculateStats();
    notifyListeners();
  }

  void rejectUser(String reviewId, String remarks) {
    _updateReviewStatus(reviewId, UserStatus.rejected, remarks);
    _calculateStats();
    notifyListeners();
  }

  void requestMoreDocuments(String reviewId, String remarks) {
    _updateReviewStatus(reviewId, UserStatus.submitted, remarks);
    notifyListeners();
  }

  void flagSuspicious(String reviewId, String remarks) {
    final index = _pendingReviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final review = _pendingReviews[index];
      _pendingReviews[index] = ProfileReview(
        id: review.id,
        userId: review.userId,
        userName: review.userName,
        phone: review.phone,
        email: review.email,
        state: review.state,
        district: review.district,
        profileType: review.profileType,
        status: review.status,
        brahminType: review.brahminType,
        gotra: review.gotra,
        submittedDate: review.submittedDate,
        verificationScore: review.verificationScore,
        documentCount: review.documentCount,
        remarks: [...review.remarks, '🚩 Flagged: $remarks'],
        reviewedBy: review.reviewedBy,
        reviewedAt: review.reviewedAt,
      );
      _filteredReviews = _pendingReviews;
      notifyListeners();
    }
  }

  void suspendUser(String reviewId, String remarks) {
    _updateReviewStatus(reviewId, UserStatus.suspended, remarks);
    _calculateStats();
    notifyListeners();
  }

  void _updateReviewStatus(String reviewId, UserStatus status, String remarks) {
    final index = _pendingReviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final review = _pendingReviews[index];
      _pendingReviews[index] = ProfileReview(
        id: review.id,
        userId: review.userId,
        userName: review.userName,
        phone: review.phone,
        email: review.email,
        state: review.state,
        district: review.district,
        profileType: review.profileType,
        status: status,
        brahminType: review.brahminType,
        gotra: review.gotra,
        submittedDate: review.submittedDate,
        verificationScore: review.verificationScore,
        documentCount: review.documentCount,
        remarks: [...review.remarks, '$status: $remarks'],
        reviewedBy: 'current_admin',
        reviewedAt: DateTime.now(),
      );
      _filteredReviews = _pendingReviews;
      notifyListeners();
    }
  }

  void updateReviewStatus(String reviewId, String status, String remarks) {
    UserStatus newStatus;
    switch (status) {
      case 'under_review':
        newStatus = UserStatus.underReview;
        break;
      case 'approved':
        newStatus = UserStatus.approved;
        break;
      case 'rejected':
        newStatus = UserStatus.rejected;
        break;
      case 'suspended':
        newStatus = UserStatus.suspended;
        break;
      default:
        newStatus = UserStatus.submitted;
    }
    _updateReviewStatus(reviewId, newStatus, remarks);
    _calculateStats();
    notifyListeners();
  }

  List<String> getStates() {
    final states = _pendingReviews.map((r) => r.state).toSet();
    return ['All', ...states];
  }

  List<String> getDistricts() {
    final districts = _pendingReviews.map((r) => r.district).toSet();
    return ['All', ...districts];
  }

  List<String> getProfileTypes() {
    return ['All', 'General Member', 'Professional Member', 'Elite Member'];
  }

  List<String> getGotras() {
    final gotras = _pendingReviews.map((r) => r.gotra).toSet();
    return ['All', ...gotras];
  }

  List<String> getStatuses() {
    return ['All', 'Submitted', 'Under Review', 'Approved', 'Rejected', 'Suspended'];
  }
}