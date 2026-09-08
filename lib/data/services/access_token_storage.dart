import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenStorage {
  const AccessTokenStorage({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  static const String _accessTokenKey = 'access_token';

  final FlutterSecureStorage _secureStorage;

  Future<String?> readAccessToken() {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> saveAccessToken(String accessToken) {
    return _secureStorage.write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> clear() {
    return _secureStorage.delete(key: _accessTokenKey);
  }
}
