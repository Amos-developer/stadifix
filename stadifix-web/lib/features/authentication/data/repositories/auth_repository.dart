import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/register_request.dart';

class RegistrationException implements Exception {
  const RegistrationException(this.message);
  final String message;
}

class AuthRepository {
  const AuthRepository({
    this.baseUrl = const String.fromEnvironment('API_BASE_URL'),
  });

  final String baseUrl;

  Future<void> register(RegisterRequest request) async {
    final base = Uri.tryParse(baseUrl);
    if (base == null ||
        !base.hasAuthority ||
        (base.scheme != 'http' && base.scheme != 'https')) {
      throw const RegistrationException(
        'Registration is not configured. Set API_BASE_URL to your API server.',
      );
    }
    final client = http.Client();
    try {
      final response = await client
          .post(
            Uri.parse(
              '${baseUrl.replaceFirst(RegExp(r'/+$'), '')}/api/v1/auth/register',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 201) return;
      if (response.statusCode == 409) {
        throw const RegistrationException(
          'This email is already registered. Please sign in.',
        );
      }
      if (response.statusCode == 400) {
        throw const RegistrationException(
          'Check your details and password requirements, then try again.',
        );
      }
      throw const RegistrationException(
        'Unable to create your account. Please try again later.',
      );
    } on TimeoutException {
      throw const RegistrationException(
        'The request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const RegistrationException(
        'Cannot reach the server. Check your connection and try again.',
      );
    } finally {
      client.close();
    }
  }
}
