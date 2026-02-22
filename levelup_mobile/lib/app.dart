import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_page.dart';

class LevelUpApp extends StatelessWidget {
  LevelUpApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      // TODO: /login, /report 등은 다음 단계에서 추가
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Level-UP',
      theme: ThemeData(useMaterial3: true),
      routerConfig: _router,
    );
  }
}