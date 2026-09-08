import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      userName = authRepository.currentUser?.name ?? '';

  final AuthRepository _authRepository;

  final String userName;

  bool _isSigningOut = false;
  bool get isSigningOut => _isSigningOut;

  bool _hasSignOutFailure = false;
  bool get hasSignOutFailure => _hasSignOutFailure;

  Future<void> logout() async {
    if (_isSigningOut) {
      return;
    }

    _isSigningOut = true;
    _hasSignOutFailure = false;
    notifyListeners();

    try {
      await _authRepository.logout();
    } catch (_) {
      _hasSignOutFailure = true;
    } finally {
      _isSigningOut = false;
      notifyListeners();
    }
  }
}
