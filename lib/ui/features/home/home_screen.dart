import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'view_models/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.homeTitle),
            actions: [
              IconButton(
                onPressed: viewModel.isSigningOut ? null : viewModel.logout,
                icon: viewModel.isSigningOut
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),
                tooltip: l10n.homeSignOut,
              ),
            ],
          ),
          body: Center(
            child: viewModel.hasSignOutFailure
                ? Text(l10n.errorUnexpected)
                : Text(l10n.homeWelcome(viewModel.userName)),
          ),
        );
      },
    );
  }
}
