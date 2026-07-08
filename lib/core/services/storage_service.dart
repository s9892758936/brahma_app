import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============================================================
  // 📝 STRING
  // ============================================================
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // ============================================================
  // 🔢 INT
  // ============================================================
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ============================================================
  // ✅ BOOL
  // ============================================================
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // ============================================================
  // 📋 LIST
  // ============================================================
  Future<void> setList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  List<String>? getList(String key) {
    return _prefs.getStringList(key);
  }

  // ============================================================
  // 🗺️ MAP (JSON)
  // ============================================================
  Future<void> setMap(String key, Map<String, dynamic> value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getMap(String key) {
    final String? data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // ============================================================
  // 🗑️ DELETE
  // ============================================================
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  // ============================================================
  // 🔐 SECURE STORAGE
  // ============================================================
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecureString(String key) async {
    await _secureStorage.delete(key: key);
  }
}