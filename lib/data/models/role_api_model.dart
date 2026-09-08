import 'permission_api_model.dart';

class RoleApiModel {
  RoleApiModel({
    required this.key,
    required this.name,
    required List<PermissionApiModel> permissions,
  }) : permissions = List.unmodifiable(permissions);

  factory RoleApiModel.fromJson(Map<String, dynamic> json) {
    final permissions = json['permissions'] as List<dynamic>? ?? <dynamic>[];

    return RoleApiModel(
      key: json['key'] as String,
      name: json['name'] as String,
      permissions: permissions
          .map(
            (permission) =>
                PermissionApiModel.fromJson(permission as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String key;
  final String name;
  final List<PermissionApiModel> permissions;
}
