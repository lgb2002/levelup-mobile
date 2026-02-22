import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/models/app_user.dart';
import '../home/home_controller.dart';
import 'auth_api.dart';

sealed class AuthState {
  const AuthState();
}

class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthAnonymous extends AuthState {
  const AuthAnonymous();
}

class AuthLoggedIn extends AuthState {
  final AppUser user;
  final String token;
  const AuthLoggedIn({required this.user, required this.token});
}

final authApiProvider = Provider<AuthApi>((ref) {
  final api = ref.watch(apiClientProvider);
  return AuthApi(api);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final api = ref.watch(apiClientProvider);
  final authApi = ref.watch(authApiProvider);
  return AuthController(ref, api, authApi)..bootstrap();
});

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  final ApiClient api;
  final AuthApi authApi;

  AuthController(this.ref, this.api, this.authApi) : super(const AuthUnknown());

  Future<void> bootstrap() async {
    final token = await api.tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      state = const AuthAnonymous();
      return;
    }

    // 토큰이 있으면 유저 정보 복구 시도
    try {
      final me = await authApi.getMe();
      state = AuthLoggedIn(user: me, token: token);
      ref.invalidate(widgetSummaryProvider);
    } catch (_) {
      // 토큰이 만료/무효면 로그아웃 처리
      await api.tokenStorage.clear();
      state = const AuthAnonymous();
      ref.invalidate(widgetSummaryProvider);
    }
  }

  Future<void> login(String email, String password) async {
    final result = await authApi.login(email: email, password: password);
    await api.tokenStorage.saveAccessToken(result.accessToken);
    state = AuthLoggedIn(user: result.user, token: result.accessToken);
    ref.invalidate(widgetSummaryProvider);
  }

  Future<void> logout() async {
    await api.tokenStorage.clear();
    state = const AuthAnonymous();
    ref.invalidate(widgetSummaryProvider);
  }
}