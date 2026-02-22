import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

class AuthApi {
  final ApiClient api;
  AuthApi(this.api);

  /// ✅ 너 백엔드에 맞춰 여기만 바꾸면 됨.
  ///
  /// [가정 기본값]
  /// POST /api/auth/login
  /// body: { "email": "...", "password": "..." }
  /// resp: { "access_token": "..." } 또는 { "token": "..." }
  Future<String> login({required String email, required String password}) async {
    try {
      final Response res = await api.dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = res.data;
      if (data is Map<String, dynamic>) {
        final token = (data['access_token'] ?? data['token']) as String?;
        if (token != null && token.isNotEmpty) return token;
      }

      throw Exception('Login response has no token field');
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'login failed';
      throw Exception(msg);
    }
  }
}