enum AuthFailureType { invalidCredentials, network, server, unexpected }

class AuthFailure implements Exception {
  const AuthFailure(this.type, {this.message});

  final AuthFailureType type;
  final String? message;
}
