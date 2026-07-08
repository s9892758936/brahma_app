import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/family_member_model.dart';

class FamilyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<FamilyMember> _members = [];
  List<FamilyMember> _filteredMembers = [];
  bool _isLoading = false;

  List<FamilyMember> get members => _members;
  List<FamilyMember> get filteredMembers => _filteredMembers;
  bool get isLoading => _isLoading;

  FamilyProvider() {
    _listenToFamily();
  }

  // ============================================================
  // 🔥 REAL-TIME FAMILY LISTENER
  // ============================================================
  void _listenToFamily() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('family')
        .orderBy('name')
        .snapshots()
        .listen((snapshot) {
          _members = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            _members.add(FamilyMember(
              id: doc.id,
              name: data['name'] ?? '',
              relationship: data['relationship'] ?? '',
              age: data['age'],
              gender: data['gender'],
              isAlive: data['isAlive'] ?? true,
              profilePic: data['profilePic'],
              birthDate: data['birthDate'],
              spouse: data['spouse'],
              father: data['father'],
              mother: data['mother'],
              children: List<String>.from(data['children'] ?? []),
            ));
          }
          _filteredMembers = _members;
          _isLoading = false;
          notifyListeners();
        });
  }

  // ============================================================
  // 🔥 ADD FAMILY MEMBER - FIREBASE
  // ============================================================
  Future<void> addMember(FamilyMember member) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('family')
          .doc(member.id)
          .set(member.toJson());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error adding family member: $e');
    }
  }

  // ============================================================
  // 🔥 UPDATE FAMILY MEMBER - FIREBASE
  // ============================================================
  Future<void> updateMember(FamilyMember member) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('family')
          .doc(member.id)
          .update(member.toJson());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error updating family member: $e');
    }
  }

  // ============================================================
  // 🗑️ DELETE FAMILY MEMBER - FIREBASE
  // ============================================================
  Future<void> deleteMember(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('family')
          .doc(id)
          .delete();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error deleting family member: $e');
    }
  }

  // ============================================================
  // 🔍 SEARCH FAMILY MEMBERS
  // ============================================================
  void searchMembers(String query) {
    if (query.isEmpty) {
      _filteredMembers = _members;
    } else {
      final q = query.toLowerCase();
      _filteredMembers = _members.where((m) =>
        m.name.toLowerCase().contains(q) ||
        m.relationship.toLowerCase().contains(q)
      ).toList();
    }
    notifyListeners();
  }

  // ============================================================
  // 📝 LOAD SAMPLE DATA (For testing)
  // ============================================================
  void loadSampleFamily() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _members = [
        FamilyMember(
          id: '1',
          name: 'Ram Sharma',
          relationship: 'Father',
          age: 65,
          gender: 'Male',
          isAlive: true,
        ),
        FamilyMember(
          id: '2',
          name: 'Sita Sharma',
          relationship: 'Mother',
          age: 60,
          gender: 'Female',
          isAlive: true,
        ),
        FamilyMember(
          id: '3',
          name: 'Rahul Sharma',
          relationship: 'Self',
          age: 35,
          gender: 'Male',
          isAlive: true,
        ),
        FamilyMember(
          id: '4',
          name: 'Priya Sharma',
          relationship: 'Sister',
          age: 30,
          gender: 'Female',
          isAlive: true,
        ),
      ];
      _filteredMembers = _members;
      _isLoading = false;
      notifyListeners();
    });
  }
}