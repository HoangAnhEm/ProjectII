import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'token_service.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000/v1';
  final String _loginEndpoint = '/auth/login';
  final String _registerEndpoint = '/auth/register';
  final String _refreshTokenEndpoint = '/auth/refresh-tokens';

  final TokenService _tokenService = TokenService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$_loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'];
        final tokens = data['tokens'];
        await _tokenService.saveTokensAndUser(
          accessToken: tokens['access']['token'],
          accessExpires: tokens['access']['expires'],
          refreshToken: tokens['refresh']['token'],
          refreshExpires: tokens['refresh']['expires'],
          user: user,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$_registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'];
        final tokens = data['tokens'];
        await _tokenService.saveTokensAndUser(
          accessToken: tokens['access']['token'],
          accessExpires: tokens['access']['expires'],
          refreshToken: tokens['refresh']['token'],
          refreshExpires: tokens['refresh']['expires'],
          user: user,
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Lỗi đăng ký: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _tokenService.clearAll();
      return true;
    } catch (e) {
      print('Lỗi đăng xuất: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) return false;
    return !JwtDecoder.isExpired(accessToken);
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    return await _tokenService.getUser();
  }

// ... các hàm refreshToken, getAuthHeaders cũng chỉ gọi TokenService để lấy/lưu token
}
