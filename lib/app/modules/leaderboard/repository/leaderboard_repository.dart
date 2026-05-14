import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import '../service/leaderboard_service.dart';

abstract class ILeaderboardRepository {
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard(String profileId);
}

class LeaderboardRepository implements ILeaderboardRepository {
  final LeaderboardService _service;

  LeaderboardRepository(this._service);

  @override
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard(String profileId) async {
    try {
      final response = await _service.fetchProfileModels(profileId);
      final data = response.data;
      final List list = data is Map
          ? (data['data'] ?? data['items'] ?? [data])
          : (data is List ? data : []);
      final models = list
          .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(models);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
