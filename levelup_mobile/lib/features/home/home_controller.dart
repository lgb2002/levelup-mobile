import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/widget_summary.dart';
import '../../core/network/api_client.dart';

/// main.dart에서 override로 실제 ApiClient를 주입할 Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  throw UnimplementedError('apiClientProvider must be overridden in main.dart');
});

/// 위젯/홈 공통 요약 API
final widgetSummaryProvider = FutureProvider<WidgetSummary>((ref) async {
  final api = ref.watch(apiClientProvider);
  final res = await api.dio.get('/api/widget/summary');
  return WidgetSummary.fromJson(res.data as Map<String, dynamic>);
});

/// Quick Add: 서버에 맞춰 endpoint/payload는 나중에 바꿔도 됨
class QuickAddService {
  final ApiClient api;
  QuickAddService(this.api);

  Future<void> quickAdd(String code) async {
    // TODO: 실제 서버 API에 맞춰 수정
    await api.dio.post('/api/quick-add', data: {'code': code});
  }
}

final quickAddServiceProvider = Provider<QuickAddService>((ref) {
  final api = ref.watch(apiClientProvider);
  return QuickAddService(api);
});