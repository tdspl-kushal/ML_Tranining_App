import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/errors/failures.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import '../service/leaderboard_service.dart';

abstract class ILeaderboardRepository {
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard(
      String profileId);
  Future<Either<Failure, List<LeaderboardEntryModel>>> fetchModels(
      {required String useCase});
  Future<Either<Failure, void>> deleteModel(String modelId);
  Future<Either<Failure, String>> downloadModel(String modelId, String modelName);
}

class LeaderboardRepository implements ILeaderboardRepository {
  final LeaderboardService _service;

  LeaderboardRepository(this._service);

  List<LeaderboardEntryModel> _parseItems(dynamic data) {
    final List list = data is Map
        ? (data['items'] ?? data['data'] ?? [data])
        : (data is List ? data : []);
    return list
        .map((e) {
          if (e is Map) {
            return LeaderboardEntryModel.fromJson(Map<String, dynamic>.from(e));
          }
          return LeaderboardEntryModel.fromJson(const {});
        })
        .toList();
  }

  @override
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard(
      String profileId) async {
    try {
      final response = await _service.fetchProfileModels(profileId);
      return Right(_parseItems(response.data));
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data?['message'] ?? e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardEntryModel>>> fetchModels(
      {required String useCase}) async {
    try {
      final response = await _service.fetchModels(useCase: useCase);
      return Right(_parseItems(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Fetch failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteModel(String modelId) async {
    try {
      await _service.deleteModel(modelId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.response?.data?['message'] ?? 'Delete failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> downloadModel(
      String modelId, String modelName) async {
    try {
      final response = await _service.downloadModel(modelId);
      final dir = await getApplicationDocumentsDirectory();
      final fileName = _resolveFileName(response, modelName);
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.data as List<int>, flush: true);
      return Right(filePath);
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? 'Download failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  String _resolveFileName(Response response, String fallback) {
    final disposition = response.headers.value('content-disposition');
    if (disposition != null && disposition.contains('filename=')) {
      return disposition.split('filename=').last.replaceAll('"', '').trim();
    }
    return '$fallback.zip';
  }
}
