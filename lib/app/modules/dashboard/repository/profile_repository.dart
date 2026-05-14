import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../data/model/profile_model.dart';
import '../service/profile_service.dart';

abstract class IProfileRepository {
  Future<Either<Failure, List<ProfileModel>>> getProfiles();
  Future<Either<Failure, void>> renameProfile(String profileId, String newName);
  Future<Either<Failure, void>> deleteProfile(String profileId);
}

class ProfileRepository implements IProfileRepository {
  final ProfileService _service;

  ProfileRepository(this._service);

  @override
  Future<Either<Failure, List<ProfileModel>>> getProfiles() async {
    try {
      final response = await _service.fetchProfiles();
      final data = response.data;
      final List list = data is Map ? (data['data'] ?? data['items'] ?? [data]) : (data is List ? data : []);
      final models = list.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>)).toList();
      return Right(models);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> renameProfile(String profileId, String newName) async {
    try {
      await _service.renameProfile(profileId, newName);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String profileId) async {
    try {
      // 1. Fetch models for the profile
      final modelsResponse = await _service.fetchProfileModels(profileId);
      final modelsData = modelsResponse.data;
      final List modelsList = modelsData is Map ? (modelsData['data'] ?? modelsData['items'] ?? [modelsData]) : (modelsData is List ? modelsData : []);
      
      // 2. Loop and delete each model
      for (final model in modelsList) {
        final modelId = model['id']?.toString() ?? model['model_id']?.toString();
        if (modelId != null && modelId.isNotEmpty) {
          try {
            await _service.deleteModel(modelId);
          } catch (_) {
            // Ignore individual model deletion failures
          }
        }
      }

      // 3. Delete the profile itself
      await _service.deleteProfile(profileId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
