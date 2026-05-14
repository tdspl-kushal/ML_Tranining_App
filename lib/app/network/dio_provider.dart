import 'package:dio/dio.dart';
import '../flavors/build_config.dart';
import '../flavors/environment.dart';
import '/app/network/pretty_dio_logger.dart';
import '/app/network/request_headers.dart';

class DioProvider {
  static final String baseUrl = BuildConfig.instance.config.baseUrl;


  static Dio? _instance;
  static Dio? _instanceAicf;

  static const int _maxLineWidth = 90;
  static final _prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: BuildConfig.instance.environment == Environment.DEVELOPMENT,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: _maxLineWidth);

  static final BaseOptions _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 60) ,
    receiveTimeout: Duration(seconds: 60),
  );


  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);

      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    } else {
      _instance!.interceptors.clear();
      _instance!.interceptors.add(_prettyDioLogger);

      return _instance!;
    }
  }




  ///returns a Dio client with Access token in header
  static Dio get tokenClient {
    _addInterceptors();

    return _instance!;
  }

  ///returns a Dio client with Access token in header
  ///Also adds a token refresh interceptor which retry the request when it's unauthorized
  static Dio get dioWithHeaderToken {
    _addInterceptors();

    return _instance!;
  }


  static Dio get dioWithHeaderToken_Aicf {

    _addInterceptorsAicf();

    return _instanceAicf!;
  }



  static _addInterceptors() {
    _instance ??= httpDio;
    _instance!.interceptors.clear();
    _instance!.interceptors.add(RequestHeaderInterceptor());
    _instance!.interceptors.add(_prettyDioLogger);
  }

  static _addInterceptorsAicf() {
    _instanceAicf ??= httpDio;
    _instanceAicf!.interceptors.clear();
    _instanceAicf!.interceptors.add(RequestHeaderInterceptor());
    _instanceAicf!.interceptors.add(_prettyDioLogger);
  }


  static String _buildContentType(String version) {
    return "user_defined_content_type+$version";
  }

  DioProvider.setContentType(String version) {
    _instance?.options.contentType = _buildContentType(version);
  }

  DioProvider.setContentTypeApplicationJson() {
    _instance?.options.contentType = "application/json";
  }
}
