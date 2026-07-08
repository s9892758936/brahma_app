import 'package:flutter/material.dart';

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePic;
  final String? state;
  final String? district;
  final DateTime joinedDate;
  final AdminStatus status;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePic,
    this.state,
    this.district,
    required this.joinedDate,
    this.status = AdminStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
    'state': state,
    'district': district,
    'joinedDate': joinedDate.toIso8601String(),
    'status': status.toString().split('.').last,
  };

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    profilePic: json['profilePic'],
    state: json['state'],
    district: json['district'],
    joinedDate: DateTime.parse(json['joinedDate']),
    status: _parseStatus(json['status'] ?? 'pending'),
  );

  static AdminStatus _parseStatus(String status) {
    switch (status) {
      case 'approved': return AdminStatus.approved;
      case 'rejected': return AdminStatus.rejected;
      default: return AdminStatus.pending;
    }
  }

  String getStatusDisplay() {
    switch (status) {
      case AdminStatus.approved: return '✅ Approved';
      case AdminStatus.rejected: return '❌ Rejected';
      default: return '⏳ Pending';
    }
  }

  Color getStatusColor() {
    switch (status) {
      case AdminStatus.approved: return Colors.green;
      case AdminStatus.rejected: return Colors.red;
      default: return Colors.orange;
    }
  }
}

enum AdminStatus {
  pending,
  approved,
  rejected,
}