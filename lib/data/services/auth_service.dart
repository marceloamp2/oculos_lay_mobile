import 'api_client.dart';
import '../models/login_response_api_model.dart';

class AuthService {
  const AuthService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<LoginResponseApiModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );

    return LoginResponseApiModel.fromJson(response);
  }

  Future<void> logout({required String accessToken}) {
    return _apiClient.post('/auth/logout', accessToken: accessToken);
  }
}
