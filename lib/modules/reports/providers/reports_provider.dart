import 'package:flutter/material.dart';
import 'dart:math';

class ReportsProvider extends ChangeNotifier {
  // ============================================================
  // 📊 DATA STORES
  // ============================================================
  List<ReportItem> _reports = [];
  List<ReportItem> _filteredReports = [];
  bool _isLoading = false;

  // ============================================================
  // 📤 GETTERS
  // ============================================================
  List<ReportItem> get reports => _filteredReports;
  List<ReportItem> get allReports => _reports;
  bool get isLoading => _isLoading;

  int get totalReports => _reports.length;
  int get pendingReports => _reports.where((r) => r.status == 'Pending' || r.status == 'Under Review').length;
  int get resolvedReports => _reports.where((r) => r.status == 'Resolved').length;
  int get rejectedReports => _reports.where((r) => r.status == 'Rejected').length;

  // ============================================================
  // 🚀 LOAD DATA
  // ============================================================
  void loadSampleReports() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final types = ['Spam', 'Harassment', 'Fake Profile', 'Inappropriate Content', 'Other'];
      final statuses = ['Pending', 'Under Review', 'Resolved', 'Rejected'];
      final titles = [
        'Inappropriate Content',
        'Spam Post',
        'Fake Profile',
        'Harassment Report',
        'Misleading Information',
        'Scam Alert',
        'Privacy Violation',
        'Hate Speech',
      ];
      
      final descriptions = [
        'User posted inappropriate content that violates community guidelines.',
        'Multiple spam posts detected from this user.',
        'Suspected fake profile with stolen images.',
        'User received harassment messages from this account.',
        'Contains misleading information about community events.',
        'User is trying to scam community members.',
        'Violation of privacy by sharing personal information.',
        'Hate speech targeting community members.',
      ];
      
      _reports = List.generate(10, (index) {
        final type = types[random.nextInt(types.length)];
        final status = statuses[random.nextInt(statuses.length)];
        final title = titles[random.nextInt(titles.length)];
        final description = descriptions[random.nextInt(descriptions.length)];
        
        return ReportItem(
          id: 'report_${now.millisecondsSinceEpoch}_$index',
          title: title,
          type: type,
          description: description,
          reportedBy: 'User ${1000 + index}',
          reportedEmail: 'user${1000 + index}@email.com',
          reportedContent: 'This is the content that was reported by the user.',
          status: status,
          createdAt: now.subtract(Duration(hours: index * 3 + random.nextInt(12))),
          updatedAt: now.subtract(Duration(hours: index * 2 + random.nextInt(8))),
        );
      })..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _filteredReports = _reports;
      _isLoading = false;
      notifyListeners();
    });
  }

  // ============================================================
  // 🔍 FILTERS
  // ============================================================
  void filterReports({String? type, String? status}) {
    _filteredReports = _reports.where((report) {
      bool matches = true;
      
      if (type != null && type.isNotEmpty && type != 'All') {
        matches = matches && report.type == type;
      }
      
      if (status != null && status.isNotEmpty && status != 'All') {
        matches = matches && report.status == status;
      }
      
      return matches;
    }).toList();
    notifyListeners();
  }

  // ============================================================
  // ✅ ACTIONS
  // ============================================================
  void resolveReport(String reportId) {
    _updateReportStatus(reportId, 'Resolved');
  }

  void rejectReport(String reportId) {
    _updateReportStatus(reportId, 'Rejected');
  }

  void investigateReport(String reportId) {
    _updateReportStatus(reportId, 'Under Review');
  }

  void _updateReportStatus(String reportId, String status) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final report = _reports[index];
      _reports[index] = ReportItem(
        id: report.id,
        title: report.title,
        type: report.type,
        description: report.description,
        reportedBy: report.reportedBy,
        reportedEmail: report.reportedEmail,
        reportedContent: report.reportedContent,
        status: status,
        createdAt: report.createdAt,
        updatedAt: DateTime.now(),
      );
      _filteredReports = _reports;
      notifyListeners();
    }
  }
}

// ============================================================
// 📦 REPORT MODEL
// ============================================================
class ReportItem {
  final String id;
  final String title;
  final String type;
  final String description;
  final String reportedBy;
  final String reportedEmail;
  final String reportedContent;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportItem({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.reportedBy,
    required this.reportedEmail,
    required this.reportedContent,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}