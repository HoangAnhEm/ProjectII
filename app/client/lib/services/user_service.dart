import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/api_constants.dart';

class UserService {
  final String baseUrl = 'http://localhost:3000/v1/user';
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<User> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: {...headers, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  Future<User> updateProfile(String token, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: {...headers, 'Authorization': 'Bearer $token'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}
