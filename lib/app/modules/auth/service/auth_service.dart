import 'dart:async';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class AuthService {
  AuthService();



  /// Performs a pre-login health check on a specific server URL.
  Future<bool> verifyServerHealth(String serverUrl) async {
    final client = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
    ));
    try {
      final response = await client.get('$serverUrl${ApiConstants.health}');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Sends the signIn request to the backend.
  /// Expects username and encrypted password.
  Future<Response> signIn({
    required String serverUrl,
    required String username,
    required String encryptedPassword,
  }) {
    final client = Dio(BaseOptions(
      baseUrl: ApiConstants.mainUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/x-www-form-urlencoded',
    ));
    return client.post(
      ApiConstants.signIn,
      data: {
        'grant_type': 'password',
        'username': username,
        'password': encryptedPassword,
        'client_id': 'roclient',
      },
    );
  }
}
