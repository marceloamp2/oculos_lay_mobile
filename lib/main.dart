import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/auth_service.dart';
import 'data/services/access_token_storage.dart';
import 'data/services/support_channel_launcher.dart';

void main() {
  final apiClient = ApiClient();
  final authRepository = AuthRepository(
    authService: AuthService(apiClient: apiClient),
    accessTokenStorage: const AccessTokenStorage(
      secureStorage: FlutterSecureStorage(),
    ),
  );
  const supportChannelLauncher = SupportChannelLauncher(
    supportUrl: AppConfig.supportUrl,
  );

  runApp(
    App(
      authRepository: authRepository,
      supportChannelLauncher: supportChannelLauncher,
    ),
  );
}
