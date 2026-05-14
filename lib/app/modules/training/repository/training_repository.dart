import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../data/model/upload_session_model.dart';
import '../../../data/model/training_result_model.dart';
import '../service/training_service.dart';

abstract class ITrainingRepository {
  Future<Either<Failure, UploadSessionModel>> uploadFile(String filePath, {String? profileName});
  Future<Either<Failure, Map<String, dynamic>>> extractFeatures(String datasetId);
  Future<Either<Failure, Map<String, dynamic>>> getHparams(String useCase);
  Future<Either<Failure, TrainingResultModel>> trainModel({
    required String datasetId,
    required String featureSchemaId,
    required String modelName,
    required String useCase,
    required List<String> tags,
    required List<String> mandatoryFeatures,
    required List<String> optionalFeatures,
    required double trainSplit,
    required int cvFolds,
    required Map<String, dynamic> hparams,
  });
}

class TrainingRepository implements ITrainingRepository {
  final TrainingService _service;

  TrainingRepository(this._service);

  @override
  Future<Either<Failure, UploadSessionModel>> uploadFile(String filePath, {String? profileName}) async {
    try {
      final response = await _service.uploadFile(filePath, profileName: profileName);
      final session = UploadSessionModel.fromJson(response.data as Map<String, dynamic>);
      return Right(session);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Upload failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> extractFeatures(String datasetId) async {
    try {
      final response = await _service.extractFeatures(datasetId);
      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Feature extraction failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getHparams(String useCase) async {
    try {
      final response = await _service.getHparams(useCase);
      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get hyperparameters'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TrainingResultModel>> trainModel({
    required String datasetId,
    required String featureSchemaId,
    required String modelName,
    required String useCase,
    required List<String> tags,
    required List<String> mandatoryFeatures,
    required List<String> optionalFeatures,
    required double trainSplit,
    required int cvFolds,
    required Map<String, dynamic> hparams,
  }) async {
    try {
      final response = await _service.trainModel(
        datasetId: datasetId,
        featureSchemaId: featureSchemaId,
        modelName: modelName,
        useCase: useCase,
        tags: tags,
        mandatoryFeatures: mandatoryFeatures,
        optionalFeatures: optionalFeatures,
        trainSplit: trainSplit,
        cvFolds: cvFolds,
        hparams: hparams,
      );
      final result = TrainingResultModel.fromJson(response.data as Map<String, dynamic>);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Training failed'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
