import 'package:dio/dio.dart';
import '../flavors/flavor_config.dart';
import '../data/local/preference/app_preferences.dart';

class DioClient {
  DioClient._();

  static Dio create(FlavorConfig config) {
    final savedUrl = AppPreferences.getString('api_base_url');
    final dio = Dio(BaseOptions(
      baseUrl: (savedUrl != null && savedUrl.isNotEmpty) ? savedUrl : config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppPreferences.getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('→ ${options.method} ${options.uri}');
    if (options.data != null) {
      var loggedData = options.data;
      if (loggedData is Map) {
        final redacted = Map<String, dynamic>.from(loggedData);
        if (redacted.containsKey('password')) redacted['password'] = '***REDACTED***';
        if (redacted.containsKey('EncryptedPassword')) redacted['EncryptedPassword'] = '***REDACTED***';
        loggedData = redacted;
      }
      // ignore: avoid_print
      print('Request Data: $loggedData');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('✗ ${err.type} ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}
