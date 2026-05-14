import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  Future<Response> fetchProfiles() {
    return _dio.get(ApiConstants.profiles);
  }

  Future<Response> fetchProfile(String profileId) {
    return _dio.get(ApiConstants.profileById(profileId));
  }

  Future<Response> fetchProfileModels(String profileId) {
    return _dio.get(ApiConstants.profileModels(profileId));
  }

  Future<Response> renameProfile(String profileId, String newName) {
    return _dio.patch(
      ApiConstants.profileById(profileId),
      data: {'profile_name': newName},
    );
  }

  Future<Response> deleteProfile(String profileId) {
    return _dio.delete(ApiConstants.profileById(profileId));
  }

  Future<Response> deleteModel(String modelId) {
    return _dio.delete(ApiConstants.modelById(modelId));
  }
}
