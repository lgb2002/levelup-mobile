import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(widgetSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Level-UP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            summaryAsync.when(
              data: (s) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘 XP: ${s.todayXp}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('레벨: ${s.level} / 주간 점수: ${s.weekPoints}'),
                      Text('검수 대기: ${s.pendingReviewsCount}'),
                      if (s.nextActionTitle != null)
                        Text('다음 추천: ${s.nextActionTitle}'),
                      const SizedBox(height: 8),
                      Text(
                        '업데이트: ${s.lastUpdated}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('요약 로드 실패: $e'),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Add',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _quickAddButton(context, ref, '+10 XP 걷기', 'walk_10'),
                _quickAddButton(context, ref, '+15 XP 공부', 'study_15'),
                _quickAddButton(context, ref, '+5 XP 스트레칭', 'stretch_5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAddButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    String code,
  ) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final svc = ref.read(quickAddServiceProvider);
          await svc.quickAdd(code);
          ref.invalidate(widgetSummaryProvider); // 기록 후 즉시 요약 갱신
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label 기록됨')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('기록 실패: $e')),
            );
          }
        }
      },
      child: Text(label),
    );
  }
}