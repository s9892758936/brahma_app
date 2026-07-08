import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brahma_app/core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isApproved = false;
  String _approvalStatus = 'pending';
  String? _rejectionReason;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isApproved => _isApproved;
  String get approvalStatus => _approvalStatus;
  String? get rejectionReason => _rejectionReason;

  AuthProvider() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      _loadUserData(user.uid);
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromJson(doc.data()!);
        _isApproved = _currentUser?.isApproved ?? false;
        _approvalStatus = _isApproved ? 'approved' : 'pending';
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  // ✅ Firebase OTP
  Future<void> sendOTP(String phoneNumber) async {
    setState(true);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _loadUserData(_auth.currentUser!.uid);
          setState(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(false);
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          setState(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(false);
      rethrow;
    }
  }

  // ✅ Firebase OTP Verification
  Future<bool> verifyOTP(String otp) async {
    setState(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      _loadUserData(userCredential.user!.uid);
      setState(false);
      return true;
    } catch (e) {
      setState(false);
      return false;
    }
  }

  // ✅ Firebase Register
  Future<void> registerUser(UserModel user) async {
    setState(true);
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      _currentUser = user;
      _isApproved = false;
      _approvalStatus = 'pending';
      notifyListeners();
    } catch (e) {
      print('Error registering user: $e');
    } finally {
      setState(false);
    }
  }

  // ✅ Firebase Admin Approval
  void approveUser() {
    _isApproved = true;
    _approvalStatus = 'approved';
    _rejectionReason = null;
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        isVerified: true,
        isApproved: true,
        role: _currentUser!.role,
      );
      _firestore.collection('users').doc(_currentUser!.id).update({
        'isApproved': true,
      });
    }
    notifyListeners();
  }

  void rejectUser({String? reason}) {
    _isApproved = false;
    _approvalStatus = 'rejected';
    _rejectionReason = reason ?? 'Not specified';
    if (_currentUser != null) {
      _firestore.collection('users').doc(_currentUser!.id).update({
        'isApproved': false,
        'rejectionReason': _rejectionReason,
      });
    }
    notifyListeners();
  }

  void resubmitForApproval() {
    _approvalStatus = 'pending';
    _rejectionReason = null;
    if (_currentUser != null) {
      _firestore.collection('users').doc(_currentUser!.id).update({
        'isApproved': false,
        'rejectionReason': null,
      });
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    _isApproved = false;
    _approvalStatus = 'pending';
    _rejectionReason = null;
    notifyListeners();
  }

  void setState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}