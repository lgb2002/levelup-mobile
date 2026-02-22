class Env {
  // Codemagic/빌드에서: --dart-define=BASE_URL=https://...
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}