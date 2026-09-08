import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/services/support_channel_launcher.dart';
import '../../../../domain/errors/auth_failure.dart';
import 'login_ui_models.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AuthRepository authRepository,
    required SupportChannelLauncher supportChannelLauncher,
  }) : _authRepository = authRepository,
       _supportChannelLauncher = supportChannelLauncher;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final AuthRepository _authRepository;
  final SupportChannelLauncher _supportChannelLauncher;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isOpeningSupport = false;
  bool get isOpeningSupport => _isOpeningSupport;

  bool get isBusy => _isSubmitting || _isOpeningSupport;

  AuthFailure? _authFailure;
  AuthFailure? get authFailure => _authFailure;

  bool _hasSupportFailure = false;
  bool get hasSupportFailure => _hasSupportFailure;

  LoginEmailValidationError? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return LoginEmailValidationError.required;
    }

    if (!_emailPattern.hasMatch(email)) {
      return LoginEmailValidationError.invalid;
    }

    return null;
  }

  LoginPasswordValidationError? validatePassword(String? value) {
    return (value ?? '').isEmpty ? LoginPasswordValidationError.required : null;
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    if (isBusy) {
      return;
    }

    _startSubmission();

    try {
      await _authRepository.login(email: email.trim(), password: password);
    } on AuthFailure catch (failure) {
      _authFailure = failure;
    } catch (_) {
      _authFailure = const AuthFailure(AuthFailureType.unexpected);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> openSupportChannel() async {
    if (isBusy) {
      return;
    }

    _isOpeningSupport = true;
    _authFailure = null;
    _hasSupportFailure = false;
    notifyListeners();

    try {
      final didOpen = await _supportChannelLauncher.openSupportChannel();

      if (!didOpen) {
        _hasSupportFailure = true;
      }
    } catch (_) {
      _hasSupportFailure = true;
    } finally {
      _isOpeningSupport = false;
      notifyListeners();
    }
  }

  void clearFailures() {
    if (_authFailure == null && !_hasSupportFailure) {
      return;
    }

    _authFailure = null;
    _hasSupportFailure = false;
    notifyListeners();
  }

  void _startSubmission() {
    _isSubmitting = true;
    _authFailure = null;
    _hasSupportFailure = false;
    notifyListeners();
  }
}
