class PermissionApiModel {
  const PermissionApiModel({required this.key, required this.name});

  factory PermissionApiModel.fromJson(Map<String, dynamic> json) {
    return PermissionApiModel(
      key: json['key'] as String,
      name: json['name'] as String,
    );
  }

  final String key;
  final String name;
}
