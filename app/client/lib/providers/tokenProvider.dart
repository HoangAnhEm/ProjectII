import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/services/token_service.dart'; // Import TokenService

// Provider cho TokenService
final tokenServiceProvider = Provider<TokenService>((ref) => TokenService());

// Provider lấy access token
final tokenProvider = FutureProvider<String?>((ref) async {
  final tokenService = ref.watch(tokenServiceProvider);
  return await tokenService.getAccessToken();
});

// Provider lấy refresh token (nếu cần)
final refreshTokenProvider = FutureProvider<String?>((ref) async {
  final tokenService = ref.watch(tokenServiceProvider);
  return await tokenService.getRefreshToken();
});

// Provider lấy user data (nếu cần)
final userDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final tokenService = ref.watch(tokenServiceProvider);
  return await tokenService.getUser();
});
