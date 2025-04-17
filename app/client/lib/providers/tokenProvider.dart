import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Hàm lưu token
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

// Hàm lấy token
Future<String?> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

// Provider lấy token (FutureProvider)
final tokenProvider = FutureProvider<String?>((ref) async {
  return await loadToken();
});
