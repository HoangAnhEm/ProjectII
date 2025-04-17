import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;

class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _refreshExpiryKey = 'refresh_expiry';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Lưu token và user info
  Future<void> saveTokensAndUser({
    required String accessToken,
    required String accessExpires,
    required String refreshToken,
    required String refreshExpires,
    required Map<String, dynamic> user,
  }) async {
    if (kIsWeb) {
      html.window.localStorage[_accessTokenKey] = accessToken;
      html.window.localStorage[_tokenExpiryKey] = accessExpires;
      html.window.localStorage[_refreshTokenKey] = refreshToken;
      html.window.localStorage[_refreshExpiryKey] = refreshExpires;
      html.window.localStorage[_userDataKey] = json.encode(user);
    } else {
      await _secureStorage.write(key: _accessTokenKey, value: accessToken);
      await _secureStorage.write(key: _tokenExpiryKey, value: accessExpires);
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      await _secureStorage.write(key: _refreshExpiryKey, value: refreshExpires);
      await _secureStorage.write(key: _userDataKey, value: json.encode(user));
    }
  }

  Future<String?> getAccessToken() async {
    if (kIsWeb) {
      return html.window.localStorage[_accessTokenKey];
    } else {
      return await _secureStorage.read(key: _accessTokenKey);
    }
  }

  Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      return html.window.localStorage[_refreshTokenKey];
    } else {
      return await _secureStorage.read(key: _refreshTokenKey);
    }
  }

  Future<String?> getAccessTokenExpiry() async {
    if (kIsWeb) {
      return html.window.localStorage[_tokenExpiryKey];
    } else {
      return await _secureStorage.read(key: _tokenExpiryKey);
    }
  }

  Future<String?> getRefreshTokenExpiry() async {
    if (kIsWeb) {
      return html.window.localStorage[_refreshExpiryKey];
    } else {
      return await _secureStorage.read(key: _refreshExpiryKey);
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    String? userJson;
    if (kIsWeb) {
      userJson = html.window.localStorage[_userDataKey];
    } else {
      userJson = await _secureStorage.read(key: _userDataKey);
    }
    if (userJson == null) return null;
    return json.decode(userJson);
  }

  Future<void> clearAll() async {
    if (kIsWeb) {
      html.window.localStorage.remove(_accessTokenKey);
      html.window.localStorage.remove(_tokenExpiryKey);
      html.window.localStorage.remove(_refreshTokenKey);
      html.window.localStorage.remove(_refreshExpiryKey);
      html.window.localStorage.remove(_userDataKey);
    } else {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _refreshExpiryKey);
      await _secureStorage.delete(key: _userDataKey);
    }
  }
}
