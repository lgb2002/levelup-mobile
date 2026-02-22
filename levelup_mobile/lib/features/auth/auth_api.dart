import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/models/app_user.dart';

class LoginResult {
  final AppUser user;
  final String accessToken;
  final String tokenType;

  LoginResult({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });
}

class AuthApi {
  final ApiClient api;
  AuthApi(this.api);

  /// v21 기준:
  /// POST /api/auth/login
  /// body: { email, password }
  /// resp: { user, access_token, token_type }
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response res = await api.dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid login response');
      }

      final token = data['access_token'] as String?;
      final tokenType = (data['token_type'] ?? 'bearer') as String;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (token == null || token.isEmpty) {
        throw Exception('Login response missing access_token');
      }
      if (userJson == null) {
        throw Exception('Login response missing user');
      }

      return LoginResult(
        user: AppUser.fromJson(userJson),
        accessToken: token,
        tokenType: tokenType,
      );
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'login failed';
      throw Exception(msg);
    }
  }

  /// v21 기준: GET /api/users/me (Bearer 필요)
  Future<AppUser> getMe() async {
    try {
      final res = await api.dio.get('/api/users/me');
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid /users/me response');
      }
      return AppUser.fromJson(data);
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'getMe failed';
      throw Exception(msg);
    }
  }
}