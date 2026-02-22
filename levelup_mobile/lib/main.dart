import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/home/home_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  final api = await ApiClient.create(tokenStorage);

  runApp(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(api),
      ],
      child: LevelUpApp(),
    ),
  );
}