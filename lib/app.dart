import 'package:flutter/material.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/support_channel_launcher.dart';
import 'l10n/app_localizations.dart';
import 'routing/app_router.dart';
import 'ui/core/themes/app_theme.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.supportChannelLauncher,
  });

  final AuthRepository authRepository;
  final SupportChannelLauncher supportChannelLauncher;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = buildAppRouter(
    authRepository: widget.authRepository,
    supportChannelLauncher: widget.supportChannelLauncher,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).homeTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
