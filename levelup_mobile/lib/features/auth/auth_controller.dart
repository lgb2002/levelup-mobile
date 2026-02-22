import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
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
  final String token;
  const AuthLoggedIn(this.token);
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
    if (token != null && token.isNotEmpty) {
      state = AuthLoggedIn(token);
    } else {
      state = const AuthAnonymous();
    }
  }

  Future<void> login(String email, String password) async {
    final token = await authApi.login(email: email, password: password);
    await api.tokenStorage.saveAccessToken(token);
    state = AuthLoggedIn(token);

    // 로그인 후 홈 요약 새로고침
    ref.invalidate(widgetSummaryProvider);
  }

  Future<void> logout() async {
    await api.tokenStorage.clear();
    state = const AuthAnonymous();
    ref.invalidate(widgetSummaryProvider);
  }
}