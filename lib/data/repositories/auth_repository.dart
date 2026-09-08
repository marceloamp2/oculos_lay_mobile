import 'package:flutter/foundation.dart';

import '../../domain/errors/auth_failure.dart';
import '../../domain/models/authenticated_user.dart';
import '../../domain/models/permission.dart';
import '../../domain/models/role.dart';
import '../models/user_api_model.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/access_token_storage.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository({
    required AuthService authService,
    required AccessTokenStorage accessTokenStorage,
  }) : _authService = authService,
       _accessTokenStorage = accessTokenStorage;

  final AuthService _authService;
  final AccessTokenStorage _accessTokenStorage;

  AuthenticatedUser? _currentUser;
  AuthenticatedUser? get currentUser => _currentUser;

  String? _accessToken;

  bool get isAuthenticated => _currentUser != null && _accessToken != null;

  Future<void> login({required String email, required String password}) async {
    try {
      final loginPayload = await _authService.login(
        email: email,
        password: password,
      );
      final currentUser = _toAuthenticatedUser(loginPayload.user);

      await _accessTokenStorage.saveAccessToken(loginPayload.accessToken);
      _accessToken = loginPayload.accessToken;
      _currentUser = currentUser;
      notifyListeners();
    } on ApiException catch (exception) {
      throw _toAuthFailure(exception);
    }
  }

  Future<void> logout() async {
    await _revokeAccessTokenIgnoringApiFailures();
    await _clearSession();
  }

  Future<void> _revokeAccessTokenIgnoringApiFailures() async {
    final accessToken = _accessToken;

    if (accessToken == null) {
      return;
    }

    try {
      await _authService.logout(accessToken: accessToken);
    } on ApiException {
      return;
    }
  }

  Future<void> _clearSession() async {
    await _accessTokenStorage.clear();
    _accessToken = null;
    _currentUser = null;
    notifyListeners();
  }

  AuthenticatedUser _toAuthenticatedUser(UserApiModel user) {
    return AuthenticatedUser(
      id: user.id,
      name: user.name,
      email: user.email,
      role: Role(
        key: user.role.key,
        name: user.role.name,
        permissions: user.role.permissions
            .map(
              (permission) =>
                  Permission(key: permission.key, name: permission.name),
            )
            .toList(),
      ),
    );
  }

  AuthFailure _toAuthFailure(ApiException exception) {
    if (exception.isNetworkFailure) {
      return const AuthFailure(AuthFailureType.network);
    }

    final statusCode = exception.statusCode!;

    if (statusCode >= 500) {
      return const AuthFailure(AuthFailureType.server);
    }

    if (statusCode == 401 || statusCode == 403 || statusCode == 422) {
      return AuthFailure(
        AuthFailureType.invalidCredentials,
        message: exception.message,
      );
    }

    return const AuthFailure(AuthFailureType.unexpected);
  }
}
