import 'package:flutter/material.dart';

// ============================================================
// 👤 USER TYPES
// ============================================================
enum UserProfileType {
  general,
  professional,
  elite,
}

extension UserProfileTypeExtension on UserProfileType {
  String get displayName {
    switch (this) {
      case UserProfileType.general:
        return 'General Member';
      case UserProfileType.professional:
        return 'Professional Member';
      case UserProfileType.elite:
        return 'Elite Member';
    }
  }

  Color get color {
    switch (this) {
      case UserProfileType.general:
        return Colors.blue;
      case UserProfileType.professional:
        return Colors.green;
      case UserProfileType.elite:
        return Colors.amber;
    }
  }

  String get badgeIcon {
    switch (this) {
      case UserProfileType.general:
        return '👤';
      case UserProfileType.professional:
        return '💼';
      case UserProfileType.elite:
        return '⭐';
    }
  }
}

// ============================================================
// 📊 USER STATUS
// ============================================================
enum UserStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  suspended,
}

extension UserStatusExtension on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.draft:
        return 'Draft';
      case UserStatus.submitted:
        return 'Submitted';
      case UserStatus.underReview:
        return 'Under Review';
      case UserStatus.approved:
        return '✅ Approved';
      case UserStatus.rejected:
        return '❌ Rejected';
      case UserStatus.suspended:
        return '⛔ Suspended';
    }
  }

  Color get color {
    switch (this) {
      case UserStatus.draft:
        return Colors.grey;
      case UserStatus.submitted:
        return Colors.blue;
      case UserStatus.underReview:
        return Colors.orange;
      case UserStatus.approved:
        return Colors.green;
      case UserStatus.rejected:
        return Colors.red;
      case UserStatus.suspended:
        return Colors.purple;
    }
  }
}

// ============================================================
// 👑 ADMIN ROLES
// ============================================================
enum AdminRole {
  superAdmin,
  admin,
  moderator,
}

extension AdminRoleExtension on AdminRole {
  String get displayName {
    switch (this) {
      case AdminRole.superAdmin:
        return '👑 Super Admin';
      case AdminRole.admin:
        return '🛡️ Admin';
      case AdminRole.moderator:
        return '🔍 Moderator';
    }
  }

  bool get canCreateAdmin => this == AdminRole.superAdmin;
  bool get canDeleteAdmin => this == AdminRole.superAdmin;
  bool get canSuspendAdmin => this == AdminRole.superAdmin;
  bool get canApproveUsers => this != AdminRole.moderator;
  bool get canViewAnalytics => this != AdminRole.moderator;
  bool get canManagePosts => this != AdminRole.moderator;
}

// ============================================================
// 📋 ADMIN USER MODEL
// ============================================================
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final AdminRole role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = AdminRole.moderator,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role.toString().split('.').last,
    'createdAt': createdAt.toIso8601String(),
    'lastLogin': lastLogin?.toIso8601String(),
    'isActive': isActive,
  };

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    role: _parseRole(json['role'] ?? 'moderator'),
    createdAt: DateTime.parse(json['createdAt']),
    lastLogin: json['lastLogin'] != null 
        ? DateTime.parse(json['lastLogin']) 
        : null,
    isActive: json['isActive'] ?? true,
  );

  static AdminRole _parseRole(String role) {
    switch (role) {
      case 'superAdmin': return AdminRole.superAdmin;
      case 'admin': return AdminRole.admin;
      default: return AdminRole.moderator;
    }
  }
}

// ============================================================
// 📝 PROFILE REVIEW MODEL
// ============================================================
class ProfileReview {
  final String id;
  final String userId;
  final String userName;
  final String phone;
  final String email;
  final String state;
  final String district;
  final UserProfileType profileType;
  final UserStatus status;
  final String brahminType;
  final String gotra;
  final DateTime submittedDate;
  final double verificationScore;
  final int documentCount;
  final List<String> remarks;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  ProfileReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.email,
    required this.state,
    required this.district,
    required this.profileType,
    required this.status,
    required this.brahminType,
    required this.gotra,
    required this.submittedDate,
    this.verificationScore = 0.0,
    this.documentCount = 0,
    this.remarks = const [],
    this.reviewedBy,
    this.reviewedAt,
  });

  bool get isPriority => profileType == UserProfileType.elite;
  bool get isResubmission => remarks.isNotEmpty && status == UserStatus.submitted;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'phone': phone,
    'email': email,
    'state': state,
    'district': district,
    'profileType': profileType.toString().split('.').last,
    'status': status.toString().split('.').last,
    'brahminType': brahminType,
    'gotra': gotra,
    'submittedDate': submittedDate.toIso8601String(),
    'verificationScore': verificationScore,
    'documentCount': documentCount,
    'remarks': remarks,
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt?.toIso8601String(),
  };

  factory ProfileReview.fromJson(Map<String, dynamic> json) => ProfileReview(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    phone: json['phone'],
    email: json['email'],
    state: json['state'],
    district: json['district'],
    profileType: _parseProfileType(json['profileType'] ?? 'general'),
    status: _parseStatus(json['status'] ?? 'submitted'),
    brahminType: json['brahminType'],
    gotra: json['gotra'],
    submittedDate: json['submittedDate'] != null 
        ? DateTime.parse(json['submittedDate']) 
        : DateTime.now(),
    verificationScore: json['verificationScore'] ?? 0.0,
    documentCount: json['documentCount'] ?? 0,
    remarks: List<String>.from(json['remarks'] ?? []),
    reviewedBy: json['reviewedBy'],
    reviewedAt: json['reviewedAt'] != null 
        ? DateTime.parse(json['reviewedAt']) 
        : null,
  );

  static UserProfileType _parseProfileType(String type) {
    switch (type) {
      case 'professional': return UserProfileType.professional;
      case 'elite': return UserProfileType.elite;
      default: return UserProfileType.general;
    }
  }

  static UserStatus _parseStatus(String status) {
    switch (status) {
      case 'submitted': return UserStatus.submitted;
      case 'underReview': return UserStatus.underReview;
      case 'approved': return UserStatus.approved;
      case 'rejected': return UserStatus.rejected;
      case 'suspended': return UserStatus.suspended;
      default: return UserStatus.draft;
    }
  }
}

// ============================================================
// 📊 STATS MODEL
// ============================================================
class DashboardStats {
  final int totalUsers;
  final int approvedUsers;
  final int pendingReviews;
  final int rejectedProfiles;
  final int activeToday;
  final int newRegistrations;
  final int eliteMembers;
  final int paidMembers;

  DashboardStats({
    this.totalUsers = 0,
    this.approvedUsers = 0,
    this.pendingReviews = 0,
    this.rejectedProfiles = 0,
    this.activeToday = 0,
    this.newRegistrations = 0,
    this.eliteMembers = 0,
    this.paidMembers = 0,
  });

  Map<String, dynamic> toJson() => {
    'totalUsers': totalUsers,
    'approvedUsers': approvedUsers,
    'pendingReviews': pendingReviews,
    'rejectedProfiles': rejectedProfiles,
    'activeToday': activeToday,
    'newRegistrations': newRegistrations,
    'eliteMembers': eliteMembers,
    'paidMembers': paidMembers,
  };
}

// ============================================================
// 📈 ANALYTICS DATA
// ============================================================
class AnalyticsData {
  final Map<String, int> stateWiseGrowth;
  final Map<String, int> districtWiseGrowth;
  final Map<String, int> professionDistribution;
  final Map<String, int> gotraDistribution;
  final List<DailyRegistration> dailyRegistrations;
  final double approvalRatio;
  final double engagementRate;

  AnalyticsData({
    this.stateWiseGrowth = const {},
    this.districtWiseGrowth = const {},
    this.professionDistribution = const {},
    this.gotraDistribution = const {},
    this.dailyRegistrations = const [],
    this.approvalRatio = 0.0,
    this.engagementRate = 0.0,
  });
}

class DailyRegistration {
  final DateTime date;
  final int count;

  DailyRegistration({required this.date, required this.count});
}

// ============================================================
// 📝 POST MODEL
// ============================================================
class ContentPost {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isReported;
  final bool isHidden;

  ContentPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isReported = false,
    this.isHidden = false,
  });
}

// ============================================================
// 📋 GROUP MODEL
// ============================================================
class CommunityGroup {
  final String id;
  final String name;
  final String description;
  final String type;
  final String? state;
  final String? district;
  final String? profession;
  final int memberCount;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.state,
    this.district,
    this.profession,
    this.memberCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.createdBy,
  });
}