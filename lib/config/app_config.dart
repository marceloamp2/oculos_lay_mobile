class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const String supportUrl = String.fromEnvironment(
    'SUPPORT_URL',
    defaultValue: 'https://wa.me/5511999999999',
  );
}
