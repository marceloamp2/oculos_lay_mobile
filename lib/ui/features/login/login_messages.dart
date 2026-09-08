import '../../../domain/errors/auth_failure.dart';
import '../../../l10n/app_localizations.dart';
import 'view_models/login_ui_models.dart';

extension AuthFailureMessage on AuthFailure {
  String localizedMessage(AppLocalizations l10n) {
    return switch (type) {
      AuthFailureType.invalidCredentials => l10n.loginInvalidCredentials,
      AuthFailureType.network => l10n.errorNetworkUnavailable,
      AuthFailureType.server => l10n.errorServerUnavailable,
      AuthFailureType.unexpected => l10n.errorUnexpected,
    };
  }
}

extension LoginEmailValidationErrorMessage on LoginEmailValidationError {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      LoginEmailValidationError.required => l10n.loginEmailRequired,
      LoginEmailValidationError.invalid => l10n.loginEmailInvalid,
    };
  }
}

extension LoginPasswordValidationErrorMessage on LoginPasswordValidationError {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      LoginPasswordValidationError.required => l10n.loginPasswordRequired,
    };
  }
}
