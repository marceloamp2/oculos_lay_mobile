import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.isVisible,
    required this.onVisibilityToggled,
    required this.onSubmitted,
    required this.validator,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool isVisible;
  final VoidCallback onVisibilityToggled;
  final VoidCallback onSubmitted;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: !isVisible,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        hintText: l10n.loginPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: onVisibilityToggled,
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          tooltip: isVisible ? l10n.loginHidePassword : l10n.loginShowPassword,
        ),
      ),
      validator: validator,
    );
  }
}
