import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// Brand name shown in the login header
  ///
  /// In pt, this message translates to:
  /// **'LAY'**
  String get brandName;

  /// Brand segment shown under the brand name
  ///
  /// In pt, this message translates to:
  /// **'EYEWEAR'**
  String get brandTagline;

  /// Small label at the top of the login header
  ///
  /// In pt, this message translates to:
  /// **'ACESSO DO CLIENTE'**
  String get loginHeaderEyebrow;

  /// Context sentence at the bottom of the login header
  ///
  /// In pt, this message translates to:
  /// **'coleções selecionadas para sua ótica'**
  String get loginHeaderSubtitle;

  /// Login form title
  ///
  /// In pt, this message translates to:
  /// **'Boas-vindas.'**
  String get loginTitle;

  /// Login form supporting text
  ///
  /// In pt, this message translates to:
  /// **'Entre para consultar produtos, montar pedidos e acompanhar suas compras.'**
  String get loginSubtitle;

  /// Email field placeholder
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get loginEmailLabel;

  /// Password field placeholder
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPasswordLabel;

  /// Accessibility label for the button that reveals the password
  ///
  /// In pt, this message translates to:
  /// **'Mostrar senha'**
  String get loginShowPassword;

  /// Accessibility label for the button that hides the password
  ///
  /// In pt, this message translates to:
  /// **'Ocultar senha'**
  String get loginHidePassword;

  /// Password recovery action
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get loginForgotPassword;

  /// Message shown while the password recovery screen does not exist
  ///
  /// In pt, this message translates to:
  /// **'Fale com a equipe Lay para recuperar sua senha.'**
  String get loginForgotPasswordNotice;

  /// Primary login action
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// Divider label above the first access action
  ///
  /// In pt, this message translates to:
  /// **'PRIMEIRO ACESSO?'**
  String get loginFirstAccessDivider;

  /// First access action that opens the support channel
  ///
  /// In pt, this message translates to:
  /// **'Falar com a equipe Lay'**
  String get loginFirstAccess;

  /// Validation message for an empty email field
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail.'**
  String get loginEmailRequired;

  /// Validation message for a malformed email
  ///
  /// In pt, this message translates to:
  /// **'Informe um e-mail válido.'**
  String get loginEmailInvalid;

  /// Validation message for an empty password field
  ///
  /// In pt, this message translates to:
  /// **'Informe sua senha.'**
  String get loginPasswordRequired;

  /// Message shown when the device cannot reach the API
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível conectar. Verifique sua internet e tente novamente.'**
  String get errorNetworkUnavailable;

  /// Message shown when the API returns a server error
  ///
  /// In pt, this message translates to:
  /// **'Estamos com instabilidade no servidor. Tente novamente em instantes.'**
  String get errorServerUnavailable;

  /// Fallback message for unexpected failures
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado. Tente novamente.'**
  String get errorUnexpected;

  /// Message shown when login credentials are rejected
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível entrar. Verifique suas credenciais e tente novamente.'**
  String get loginInvalidCredentials;

  /// Message shown when the support channel cannot be opened
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir o canal de atendimento. Tente novamente.'**
  String get loginSupportUnavailable;

  /// Title of the placeholder screen shown after login
  ///
  /// In pt, this message translates to:
  /// **'Óculos Lay'**
  String get homeTitle;

  /// Greeting shown to the authenticated user
  ///
  /// In pt, this message translates to:
  /// **'Olá, {name}!'**
  String homeWelcome(String name);

  /// Sign out action
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get homeSignOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
