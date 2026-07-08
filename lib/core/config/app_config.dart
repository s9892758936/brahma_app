import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  static const String appName = 'BRAHMA';
  static const String appFullName = 'Brahman Abhyudaya Hitarth Mahasangh Arohan';
  static const String apiBaseUrl = 'https://api.brahma.com/v1';
  
  static late SharedPreferences sharedPreferences;
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<void> initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}