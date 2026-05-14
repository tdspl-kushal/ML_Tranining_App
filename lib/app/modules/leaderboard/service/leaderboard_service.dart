import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class LeaderboardService {
  final Dio _dio;

  LeaderboardService(this._dio);

  Future<Response> fetchProfileModels(String profileId) {
    return _dio.get(ApiConstants.profileModels(profileId));
  }

  Future<Response> fetchModelDetails(String modelId) {
    return _dio.get(ApiConstants.modelById(modelId));
  }

  Future<Response> downloadModel(String modelId) {
    return _dio.get(
      ApiConstants.modelDownload(modelId),
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
