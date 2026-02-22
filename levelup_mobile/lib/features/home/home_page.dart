import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'home_controller.dart';
import '../auth/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(widgetSummaryProvider);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level-UP'),
        actions: [
          if (auth is AuthLoggedIn)
            TextButton(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
              },
              child: const Text('Logout'),
            )
          else if (auth is AuthAnonymous)
            TextButton(
              onPressed: () => context.push('/login'),
              child: const Text('Login'),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                auth is AuthLoggedIn ? 'Status: Logged in' : 'Status: Anonymous',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
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

            // Quick Add는 로그인 다음 단계에서 고칠 거라 일단 유지
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Add (현재 백엔드 연동 예정)',
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
          ref.invalidate(widgetSummaryProvider);
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