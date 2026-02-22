import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_page.dart';
import 'features/auth/login_page.dart';

class LevelUpApp extends StatelessWidget {
  LevelUpApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
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