import 'package:dio/dio.dart';
import '../core/errors/exceptions.dart';

class ResponseHandler {
  ResponseHandler._();

  static T handle<T>(Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      return fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(
      message: response.data?['message'] ?? 'Unexpected error',
      statusCode: response.statusCode,
    );
  }

  static List<T> handleList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson, {
    String dataKey = 'data',
  }) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      final List list = data is Map ? (data[dataKey] ?? data['items'] ?? []) : data;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    throw ServerException(
      message: response.data?['message'] ?? 'Unexpected error',
      statusCode: response.statusCode,
    );
  }
}
