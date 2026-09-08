// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get brandName => 'LAY';

  @override
  String get brandTagline => 'EYEWEAR';

  @override
  String get loginHeaderEyebrow => 'ACESSO DO CLIENTE';

  @override
  String get loginHeaderSubtitle => 'coleções selecionadas para sua ótica';

  @override
  String get loginTitle => 'Boas-vindas.';

  @override
  String get loginSubtitle =>
      'Entre para consultar produtos, montar pedidos e acompanhar suas compras.';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Senha';

  @override
  String get loginShowPassword => 'Mostrar senha';

  @override
  String get loginHidePassword => 'Ocultar senha';

  @override
  String get loginForgotPassword => 'Esqueci minha senha';

  @override
  String get loginForgotPasswordNotice =>
      'Fale com a equipe Lay para recuperar sua senha.';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginFirstAccessDivider => 'PRIMEIRO ACESSO?';

  @override
  String get loginFirstAccess => 'Falar com a equipe Lay';

  @override
  String get loginEmailRequired => 'Informe seu e-mail.';

  @override
  String get loginEmailInvalid => 'Informe um e-mail válido.';

  @override
  String get loginPasswordRequired => 'Informe sua senha.';

  @override
  String get errorNetworkUnavailable =>
      'Não foi possível conectar. Verifique sua internet e tente novamente.';

  @override
  String get errorServerUnavailable =>
      'Estamos com instabilidade no servidor. Tente novamente em instantes.';

  @override
  String get errorUnexpected => 'Algo deu errado. Tente novamente.';

  @override
  String get loginInvalidCredentials =>
      'Não foi possível entrar. Verifique suas credenciais e tente novamente.';

  @override
  String get loginSupportUnavailable =>
      'Não foi possível abrir o canal de atendimento. Tente novamente.';

  @override
  String get homeTitle => 'Óculos Lay';

  @override
  String homeWelcome(String name) {
    return 'Olá, $name!';
  }

  @override
  String get homeSignOut => 'Sair';
}
