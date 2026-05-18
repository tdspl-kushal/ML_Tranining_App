import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../data/model/upload_session_model.dart';
import '../../../data/model/feature_extract_model.dart';
import '../../../data/model/hparams_model.dart';
import '../../../data/model/training_result_model.dart';
import '../../../data/model/training_stream_event.dart';
import '../service/training_service.dart';

abstract class ITrainingRepository {
  Future<Either<Failure, UploadSessionModel>> uploadFile(String filePath,
      {String? profileName});
  Future<Either<Failure, FeatureExtractModel>> extractFeatures(
      String datasetId);
  Future<Either<Failure, HparamsModel>> getHparams(String useCase);
  Future<Either<Failure, TrainingResultModel>> trainModel(
      Map<String, dynamic> payload);
  Future<Either<Failure, Stream<TrainingStreamEvent>>> streamTraining(
      String modelId);
}

class TrainingRepository implements ITrainingRepository {
  final TrainingService _service;

  TrainingRepository(this._service);

  @override
  Future<Either<Failure, UploadSessionModel>> uploadFile(String filePath,
      {String? profileName}) async {
    try {
      final response =
          await _service.uploadFile(filePath, profileName: profileName);
      final session =
          UploadSessionModel.fromJson(response.data as Map<String, dynamic>);
      return Right(session);
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Upload failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FeatureExtractModel>> extractFeatures(
      String datasetId) async {
    try {
      final response = await _service.extractFeatures(datasetId);
      final model = FeatureExtractModel.fromJson(
          response.data as Map<String, dynamic>);
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Feature extraction failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HparamsModel>> getHparams(String useCase) async {
    try {
      final response = await _service.getHparams(useCase);
      final model =
          HparamsModel.fromJson(response.data as Map<String, dynamic>);
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to get hyperparameters'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TrainingResultModel>> trainModel(
      Map<String, dynamic> payload) async {
    try {
      final response = await _service.trainModel(payload);
      final result = TrainingResultModel.fromJson(
          response.data as Map<String, dynamic>);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Training failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<TrainingStreamEvent>>> streamTraining(
      String modelId) async {
    try {
      final rawStream = await _service.streamTraining(modelId);
      // Transform raw text chunks into TrainingStreamEvent objects.
      // Each chunk may contain multiple lines separated by '\n'.
      final eventStream = rawStream
          .expand((chunk) => chunk.split('\n'))
          .map(TrainingStreamEvent.parseLine)
          .where((e) => e.type != StreamEventType.log || (e.message?.isNotEmpty == true));
      return Right(eventStream);
    } on DioException catch (e) {
      return Left(ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Stream failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
