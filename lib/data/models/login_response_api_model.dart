import 'user_api_model.dart';

class LoginResponseApiModel {
  const LoginResponseApiModel({required this.user, required this.accessToken});

  factory LoginResponseApiModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return LoginResponseApiModel(
      user: UserApiModel.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['access_token'] as String,
    );
  }

  final UserApiModel user;
  final String accessToken;
}
