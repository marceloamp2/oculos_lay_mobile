import 'role_api_model.dart';

class UserApiModel {
  const UserApiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: RoleApiModel.fromJson(json['role'] as Map<String, dynamic>),
    );
  }

  final int id;
  final String name;
  final String email;
  final RoleApiModel role;
}
