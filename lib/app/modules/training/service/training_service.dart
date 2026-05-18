import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class TrainingService {
  final Dio _dio;

  TrainingService(this._dio);

  Future<Response> uploadFile(String filePath, {String? profileName}) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last.split('\\').last),
      if (profileName != null) 'config': '{"profile_name": "$profileName"}',
    });
    return _dio.post(
      ApiConstants.ingest,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
  }

  Future<Response> extractFeatures(String datasetId) {
    return _dio.post(
      ApiConstants.featuresExtract,
      data: {'dataset_id': datasetId},
    );
  }

  Future<Response> getHparams(String useCase) {
    return _dio.get(ApiConstants.hparams(useCase));
  }

  Future<Response> trainModel(Map<String, dynamic> payload) {
    return _dio.post(ApiConstants.train, data: payload);
  }

  /// Returns a Stream of raw text lines from the SSE endpoint.
  Future<Stream<String>> streamTraining(String modelId) async {
    final response = await _dio.get(
      ApiConstants.trainStream(modelId),
      options: Options(
        responseType: ResponseType.stream,
        receiveTimeout: const Duration(minutes: 30),
      ),
    );
    final responseBody = response.data as ResponseBody;
    return responseBody.stream.transform(
      StreamTransformer<Uint8List, String>.fromHandlers(
        handleData: (data, sink) => sink.add(utf8.decode(data, allowMalformed: true)),
      ),
    );
  }
}
