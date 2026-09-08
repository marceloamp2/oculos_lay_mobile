import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
    : _httpClient = httpClient ?? http.Client(),
      _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  static const Duration _timeout = Duration(seconds: 20);

  final http.Client _httpClient;
  final String _baseUrl;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? accessToken,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl$path'),
            headers: _buildHeaders(accessToken),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(_timeout);

      return _decodeResponse(response);
    } on SocketException {
      throw const ApiException(statusCode: null);
    } on TimeoutException {
      throw const ApiException(statusCode: null);
    } on http.ClientException {
      throw const ApiException(statusCode: null);
    }
  }

  void dispose() => _httpClient.close();

  Map<String, String> _buildHeaders(String? accessToken) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      if (accessToken != null)
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final body = _decodeBody(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: body['message'] as String?,
    );
  }

  Map<String, dynamic> _decodeBody(String body) {
    if (body.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(body);

    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }
}
