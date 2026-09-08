class ApiException implements Exception {
  const ApiException({required this.statusCode, this.message});

  final int? statusCode;

  final String? message;

  bool get isNetworkFailure => statusCode == null;
}
