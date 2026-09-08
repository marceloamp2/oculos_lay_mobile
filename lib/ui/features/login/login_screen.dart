import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../core/themes/app_colors.dart';
import 'login_messages.dart';
import 'view_models/login_view_model.dart';
import 'widgets/email_field.dart';
import 'widgets/labeled_divider.dart';
import 'widgets/login_header.dart';
import 'widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isFailureSnackBarScheduled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      backgroundColor: AppColors.lightSurface,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          _showFailureSnackBarAfterCurrentFrame(viewModel);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ColoredBox(
                  color: AppColors.darkSurface,
                  child: SafeArea(bottom: false, child: LoginHeader()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: _LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    viewModel: viewModel,
                    onSubmit: _submit,
                    onForgotPassword: _showPasswordRecoverySupportNotice,
                    onFirstAccess: viewModel.openSupportChannel,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFailureSnackBarAfterCurrentFrame(LoginViewModel viewModel) {
    final authFailure = viewModel.authFailure;

    if ((authFailure == null && !viewModel.hasSupportFailure) ||
        _isFailureSnackBarScheduled) {
      return;
    }

    _isFailureSnackBarScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              authFailure?.localizedMessage(AppLocalizations.of(context)) ??
                  AppLocalizations.of(context).loginSupportUnavailable,
            ),
          ),
        );
      viewModel.clearFailures();
      _isFailureSnackBarScheduled = false;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    await widget.viewModel.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _showPasswordRecoverySupportNotice() {
    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(l10n.loginForgotPasswordNotice)));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.viewModel,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onFirstAccess,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginViewModel viewModel;
  final Future<void> Function() onSubmit;
  final VoidCallback onForgotPassword;
  final Future<void> Function() onFirstAccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSubmitting = viewModel.isSubmitting;
    final isBusy = viewModel.isBusy;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.loginTitle,
            style: const TextStyle(
              color: AppColors.darkSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.loginSubtitle,
            style: const TextStyle(
              color: AppColors.onLightSurfaceMuted,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          EmailField(
            controller: emailController,
            enabled: !isBusy,
            validator: (value) =>
                viewModel.validateEmail(value)?.localizedMessage(l10n),
          ),
          const SizedBox(height: 15),
          PasswordField(
            controller: passwordController,
            enabled: !isBusy,
            isVisible: viewModel.isPasswordVisible,
            onVisibilityToggled: viewModel.togglePasswordVisibility,
            onSubmitted: onSubmit,
            validator: (value) =>
                viewModel.validatePassword(value)?.localizedMessage(l10n),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isBusy ? null : onForgotPassword,
              child: Text(l10n.loginForgotPassword),
            ),
          ),
          const SizedBox(height: 4),
          FilledButton(
            onPressed: isBusy ? null : onSubmit,
            child: isSubmitting
                ? const _SubmitButtonProgressIndicator()
                : Text(l10n.loginSubmit),
          ),
          const SizedBox(height: 28),
          LabeledDivider(label: l10n.loginFirstAccessDivider),
          const SizedBox(height: 8),
          TextButton(
            onPressed: isBusy ? null : onFirstAccess,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.darkSurface,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(l10n.loginFirstAccess),
          ),
        ],
      ),
    );
  }
}

class _SubmitButtonProgressIndicator extends StatelessWidget {
  const _SubmitButtonProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 22,
      width: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        color: AppColors.lightSurface,
      ),
    );
  }
}
