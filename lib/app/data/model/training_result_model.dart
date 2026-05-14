import 'package:equatable/equatable.dart';

class TrainingResultModel extends Equatable {
  final String runId;
  final String modelId;
  final String status;
  final int? estimatedDurationSeconds;
  final String? streamUrl;

  const TrainingResultModel({
    required this.runId,
    required this.modelId,
    required this.status,
    this.estimatedDurationSeconds,
    this.streamUrl,
  });

  factory TrainingResultModel.fromJson(Map<String, dynamic> json) {
    return TrainingResultModel(
      runId: json['run_id']?.toString() ?? '',
      modelId: json['model_id']?.toString() ?? '',
      status: json['status'] ?? 'unknown',
      estimatedDurationSeconds: json['estimated_duration_seconds'],
      streamUrl: json['stream_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'run_id': runId,
      'model_id': modelId,
      'status': status,
      'estimated_duration_seconds': estimatedDurationSeconds,
      'stream_url': streamUrl,
    };
  }

  TrainingResultModel copyWith({
    String? runId,
    String? modelId,
    String? status,
    int? estimatedDurationSeconds,
    String? streamUrl,
  }) {
    return TrainingResultModel(
      runId: runId ?? this.runId,
      modelId: modelId ?? this.modelId,
      status: status ?? this.status,
      estimatedDurationSeconds: estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      streamUrl: streamUrl ?? this.streamUrl,
    );
  }

  @override
  List<Object?> get props => [runId, modelId, status, estimatedDurationSeconds, streamUrl];
}
