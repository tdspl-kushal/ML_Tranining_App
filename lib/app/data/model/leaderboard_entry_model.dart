import 'package:equatable/equatable.dart';

class LeaderboardEntryModel extends Equatable {
  final String id;
  final String? modelName;
  final int version;
  final String useCase;
  final double precision;
  final double accuracy;
  final double recall;
  final String status;
  final Map<String, dynamic> parameters;
  final Map<String, double>? metrics;
  final Map<String, dynamic>? featureImportance;
  final String trainedOnFile;
  final String trainedOnFileUrl;
  final int? trainingDurationSeconds;

  const LeaderboardEntryModel({
    required this.id,
    this.modelName,
    required this.version,
    required this.useCase,
    required this.precision,
    required this.accuracy,
    required this.recall,
    required this.status,
    required this.parameters,
    this.metrics,
    this.featureImportance,
    required this.trainedOnFile,
    required this.trainedOnFileUrl,
    this.trainingDurationSeconds,
  });

factory LeaderboardEntryModel.fromJson(
    Map<String, dynamic> json) {

  final metricsJson =
      json['metrics'] as Map<String, dynamic>? ?? {};

  return LeaderboardEntryModel(
    id: json['id']?.toString() ?? '',

    modelName: json['model_name']?.toString(),

    version: json['version'] is int
        ? json['version'] as int
        : int.tryParse(
              json['version']?.toString() ?? '1',
            ) ??
            1,

    useCase: json['use_case'] ?? '',

    precision: metricsJson['precision'] is num
        ? (metricsJson['precision'] as num).toDouble()
        : 0.0,

    accuracy: metricsJson['accuracy'] is num
        ? (metricsJson['accuracy'] as num).toDouble()
        : 0.0,

    recall: metricsJson['recall'] is num
        ? (metricsJson['recall'] as num).toDouble()
        : 0.0,

    status: json['status'] ?? 'inactive',

    parameters: Map<String, dynamic>.from(
      json['parameters'] ??
          json['hparams'] ??
          json['hparams_used'] ??
          {},
    ),

    metrics: Map<String, double>.fromEntries(
      metricsJson.entries
          .where((e) => e.value is num)
          .map(
            (e) => MapEntry(
              e.key,
              (e.value as num).toDouble(),
            ),
          ),
    ),

    featureImportance:
        json['feature_importance'] != null
            ? Map<String, dynamic>.from(
                json['feature_importance'],
              )
            : null,

    trainedOnFile:
        json['trained_on_file'] ??
            json['dataset_file'] ??
            '',

    trainedOnFileUrl:
        json['trained_on_file_url'] ?? '',

    trainingDurationSeconds:
        json['training_duration_seconds'] is num
            ? (json['training_duration_seconds'] as num)
                .toInt()
            : int.tryParse(
                json['training_duration_seconds']
                        ?.toString() ??
                    '',
              ),
  );
}

  LeaderboardEntryModel copyWith({
    String? id,
    String? modelName,
    int? version,
    String? useCase,
    double? precision,
    double? accuracy,
    double? recall,
    String? status,
    Map<String, dynamic>? parameters,
    Map<String, double>? metrics,
    Map<String, dynamic>? featureImportance,
    String? trainedOnFile,
    String? trainedOnFileUrl,
    int? trainingDurationSeconds,
  }) {
    return LeaderboardEntryModel(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      version: version ?? this.version,
      useCase: useCase ?? this.useCase,
      precision: precision ?? this.precision,
      accuracy: accuracy ?? this.accuracy,
      recall: recall ?? this.recall,
      status: status ?? this.status,
      parameters: parameters ?? this.parameters,
      metrics: metrics ?? this.metrics,
      featureImportance: featureImportance ?? this.featureImportance,
      trainedOnFile: trainedOnFile ?? this.trainedOnFile,
      trainedOnFileUrl: trainedOnFileUrl ?? this.trainedOnFileUrl,
      trainingDurationSeconds: trainingDurationSeconds ?? this.trainingDurationSeconds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        modelName,
        version,
        useCase,
        precision,
        accuracy,
        recall,
        status,
        parameters,
        metrics,
        featureImportance,
        trainedOnFile,
        trainedOnFileUrl,
        trainingDurationSeconds,
      ];
}
