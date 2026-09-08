import 'permission.dart';

class Role {
  Role({
    required this.key,
    required this.name,
    required List<Permission> permissions,
  }) : permissions = List.unmodifiable(permissions);

  final String key;
  final String name;
  final List<Permission> permissions;
}
