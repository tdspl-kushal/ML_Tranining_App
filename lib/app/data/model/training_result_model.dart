import 'package:equatable/equatable.dart';

/// Used for the initial POST /v1/train response (runId, modelId, status).
/// Also used as the "completed" event payload from the SSE stream.
class TrainingResultModel extends Equatable {
  final String runId;
  final String modelId;
  final String modelName;
  final String status;
  final String useCase;
  final String outputTag;
  final Map<String, dynamic>? metrics;
  final Map<String, double>? featureImportance;
  final double? trainingDurationSeconds;
  final String? artifactPath;
  final int? estimatedDurationSeconds;
  final String? streamUrl;

  const TrainingResultModel({
    required this.runId,
    required this.modelId,
    this.modelName = '',
    required this.status,
    this.useCase = '',
    this.outputTag = '',
    this.metrics,
    this.featureImportance,
    this.trainingDurationSeconds,
    this.artifactPath,
    this.estimatedDurationSeconds,
    this.streamUrl,
  });

  factory TrainingResultModel.fromJson(Map<String, dynamic> json) {
    // Feature importance can be Map<String, num> — cast safely
    Map<String, double>? fi;
    final fiRaw = json['feature_importance'];
    if (fiRaw is Map) {
      fi = Map<String, double>.fromEntries(
        fiRaw.entries
            .where((e) => e.value is num)
            .map((e) => MapEntry(e.key as String, (e.value as num).toDouble())),
      );
    }

    return TrainingResultModel(
      runId: json['run_id']?.toString() ?? '',
      modelId: json['model_id']?.toString() ?? '',
      modelName: json['model_name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      useCase: json['use_case']?.toString() ?? '',
      outputTag: json['output_tag']?.toString() ?? '',
      metrics: json['metrics'] is Map
          ? Map<String, dynamic>.from(json['metrics'] as Map)
          : null,
      featureImportance: fi,
      trainingDurationSeconds: json['training_duration_seconds'] is num
          ? (json['training_duration_seconds'] as num).toDouble()
          : null,
      artifactPath: json['artifact_path']?.toString(),
      estimatedDurationSeconds: json['estimated_duration_seconds'] is int
          ? json['estimated_duration_seconds'] as int
          : null,
      streamUrl: json['stream_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'run_id': runId,
      'model_id': modelId,
      'model_name': modelName,
      'status': status,
      'use_case': useCase,
      'output_tag': outputTag,
      'metrics': metrics,
      'feature_importance': featureImportance,
      'training_duration_seconds': trainingDurationSeconds,
      'artifact_path': artifactPath,
      'estimated_duration_seconds': estimatedDurationSeconds,
      'stream_url': streamUrl,
    };
  }

  TrainingResultModel copyWith({
    String? runId,
    String? modelId,
    String? modelName,
    String? status,
    String? useCase,
    String? outputTag,
    Map<String, dynamic>? metrics,
    Map<String, double>? featureImportance,
    double? trainingDurationSeconds,
    String? artifactPath,
    int? estimatedDurationSeconds,
    String? streamUrl,
  }) {
    return TrainingResultModel(
      runId: runId ?? this.runId,
      modelId: modelId ?? this.modelId,
      modelName: modelName ?? this.modelName,
      status: status ?? this.status,
      useCase: useCase ?? this.useCase,
      outputTag: outputTag ?? this.outputTag,
      metrics: metrics ?? this.metrics,
      featureImportance: featureImportance ?? this.featureImportance,
      trainingDurationSeconds: trainingDurationSeconds ?? this.trainingDurationSeconds,
      artifactPath: artifactPath ?? this.artifactPath,
      estimatedDurationSeconds: estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      streamUrl: streamUrl ?? this.streamUrl,
    );
  }

  @override
  List<Object?> get props => [
        runId,
        modelId,
        modelName,
        status,
        useCase,
        outputTag,
        metrics,
        featureImportance,
        trainingDurationSeconds,
        artifactPath,
        estimatedDurationSeconds,
        streamUrl,
      ];
}
