import 'package:flutter/material.dart';
import 'dart:math';

class GroupsProvider extends ChangeNotifier {
  // ============================================================
  // 📊 DATA STORES
  // ============================================================
  List<GroupItem> _groups = [];
  List<GroupItem> _filteredGroups = [];
  bool _isLoading = false;

  // ============================================================
  // 📤 GETTERS
  // ============================================================
  List<GroupItem> get groups => _filteredGroups;
  List<GroupItem> get allGroups => _groups;
  bool get isLoading => _isLoading;

  int get totalGroups => _groups.length;
  int get totalMembers => _groups.fold(0, (sum, group) => sum + group.members);
  int get activeGroups => _groups.where((g) => g.isActive).length;
  int get pendingGroups => _groups.where((g) => !g.isActive).length;

  // ============================================================
  // 🚀 LOAD DATA
  // ============================================================
  void loadSampleGroups() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final now = DateTime.now();
      final random = Random();
      
      final groupNames = [
        'UP Brahmin Community',
        'Varanasi Brahmins',
        'Brahmin Doctors Network',
        'Bihar Brahmin Samaj',
        'Delhi Brahmin Group',
        'Brahmin Engineers Forum',
        'Family Tree Connect',
        'Brahmin Business Network',
      ];
      
      final descriptions = [
        'Official group for Brahmins in Uttar Pradesh. Connect, collaborate, and grow together.',
        'Local community group for Varanasi Brahmins. Join to stay connected with your community.',
        'Professional network for Brahmin doctors. Share knowledge and collaborate.',
        'Community group for Brahmins in Bihar. Stay connected with your roots.',
        'Network for Brahmins in Delhi NCR. Professional and social networking.',
        'Forum for Brahmin engineers and technologists. Share ideas and opportunities.',
        'Connect with your extended family. Share family news and stay in touch.',
        'Network for Brahmin business owners and entrepreneurs.',
      ];
      
      final locations = [
        'Uttar Pradesh',
        'Varanasi',
        'All India',
        'Bihar',
        'Delhi NCR',
        'All India',
        'Worldwide',
        'All India',
      ];
      
      final types = ['State', 'District', 'Professional', 'State', 'District', 'Professional', 'Family', 'Professional'];
      
      _groups = List.generate(8, (index) {
        final type = types[index % types.length];
        final daysAgo = random.nextInt(30);
        
        return GroupItem(
          id: 'group_${index + 1}',
          name: groupNames[index],
          type: type,
          description: descriptions[index],
          location: locations[index],
          members: 50 + random.nextInt(200),
          isActive: random.nextBool(),
          createdAt: now.subtract(Duration(days: daysAgo)),
          createdBy: 'admin_${index + 1}',
        );
      });
      
      _filteredGroups = _groups;
      _isLoading = false;
      notifyListeners();
    });
  }

  // ============================================================
  // 🔍 FILTERS
  // ============================================================
  void filterGroups(String? type) {
    if (type == null || type == 'All') {
      _filteredGroups = _groups;
    } else {
      _filteredGroups = _groups.where((g) => g.type == type).toList();
    }
    notifyListeners();
  }

  // ============================================================
  // 📝 CREATE GROUP
  // ============================================================
  void createGroup(GroupItem group) {
    _groups.add(group);
    _filteredGroups = _groups;
    notifyListeners();
  }

  // ============================================================
  // 🗑️ DELETE GROUP
  // ============================================================
  void deleteGroup(String groupId) {
    _groups.removeWhere((g) => g.id == groupId);
    _filteredGroups = _groups;
    notifyListeners();
  }
}

// ============================================================
// 📦 GROUP MODEL
// ============================================================
class GroupItem {
  final String id;
  final String name;
  final String type;
  final String description;
  final String location;
  final int members;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;

  GroupItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.members,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
  });
}