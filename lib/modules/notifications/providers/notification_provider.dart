import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  List<NotificationItem> _filteredNotifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  List<NotificationItem> get notifications => _filteredNotifications;
  List<NotificationItem> get allNotifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  NotificationProvider() {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notifications');
    if (data != null) {
      try {
        final list = jsonDecode(data) as List;
        _notifications = list.map((item) => NotificationItem(
          id: item['id'],
          title: item['title'],
          message: item['message'],
          type: _parseType(item['type']),
          isRead: item['isRead'] ?? false,
          createdAt: DateTime.parse(item['createdAt']),
          data: {},
        )).toList();
        _filteredNotifications = _notifications;
        _updateUnreadCount();
      } catch (e) {
        loadSampleNotifications();
      }
    } else {
      loadSampleNotifications();
    }
  }

  NotificationType _parseType(String type) {
    switch (type) {
      case 'approval': return NotificationType.approval;
      case 'rejection': return NotificationType.rejection;
      case 'message': return NotificationType.message;
      case 'announcement': return NotificationType.announcement;
      case 'reminder': return NotificationType.reminder;
      default: return NotificationType.general;
    }
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _notifications.map((n) => ({
      'id': n.id,
      'title': n.title,
      'message': n.message,
      'type': n.type.toString().split('.').last,
      'isRead': n.isRead,
      'createdAt': n.createdAt.toIso8601String(),
    })).toList();
    await prefs.setString('notifications', jsonEncode(list));
  }

  void loadSampleNotifications() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final types = [
        NotificationType.approval,
        NotificationType.message,
        NotificationType.announcement,
        NotificationType.reminder,
        NotificationType.general,
      ];
      
      final titles = [
        'Profile Approved! 🎉',
        'New Message Received',
        'Community Announcement',
        'Profile Update Reminder',
        'Welcome to BRAHMA!',
        'Document Verification Complete',
        'New Family Member Added',
      ];
      
      final messages = [
        'Your profile has been approved by admin.',
        'You have a new message from Priya.',
        'Community meeting tomorrow at 7 PM.',
        'Please complete your profile details.',
        'We are glad to have you in our community.',
        'Your documents have been verified successfully.',
        'A new family member has been added to your tree.',
      ];
      
      _notifications = List.generate(10, (index) {
        final type = types[random.nextInt(types.length)];
        final title = titles[random.nextInt(titles.length)];
        final message = messages[random.nextInt(messages.length)];
        
        return NotificationItem(
          id: 'notif_${now.millisecondsSinceEpoch}_$index',
          title: title,
          message: message,
          type: type,
          isRead: random.nextBool(),
          createdAt: now.subtract(Duration(minutes: random.nextInt(120) + index * 5)),
          data: {},
        );
      })..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      _filteredNotifications = _notifications;
      _updateUnreadCount();
      _isLoading = false;
      _saveNotifications();
      notifyListeners();
    });
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        isRead: true,
        createdAt: _notifications[index].createdAt,
        data: _notifications[index].data,
      );
      _filteredNotifications = _notifications;
      _updateUnreadCount();
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => NotificationItem(
      id: n.id,
      title: n.title,
      message: n.message,
      type: n.type,
      isRead: true,
      createdAt: n.createdAt,
      data: n.data,
    )).toList();
    _filteredNotifications = _notifications;
    _updateUnreadCount();
    _saveNotifications();
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _filteredNotifications = _notifications;
    _updateUnreadCount();
    _saveNotifications();
    notifyListeners();
  }

  void filterNotifications(String? type) {
    if (type == null || type == 'All') {
      _filteredNotifications = _notifications;
    } else {
      _filteredNotifications = _notifications
          .where((n) => n.type.toString().split('.').last == type)
          .toList();
    }
    notifyListeners();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data = const {},
  });

  String get typeIcon {
    switch (type) {
      case NotificationType.approval:
        return '✅';
      case NotificationType.rejection:
        return '❌';
      case NotificationType.message:
        return '💬';
      case NotificationType.announcement:
        return '📢';
      case NotificationType.reminder:
        return '⏰';
      default:
        return '🔔';
    }
  }

  Color get typeColor {
    switch (type) {
      case NotificationType.approval:
        return Colors.green;
      case NotificationType.rejection:
        return Colors.red;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.announcement:
        return Colors.orange;
      case NotificationType.reminder:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

enum NotificationType {
  approval,
  rejection,
  message,
  announcement,
  reminder,
  general,
}