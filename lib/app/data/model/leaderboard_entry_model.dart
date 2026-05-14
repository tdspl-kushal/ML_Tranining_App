import 'package:equatable/equatable.dart';

class LeaderboardEntryModel extends Equatable {
  final String id;
  final String name;
  final String useCase;
  final double precision;
  final double accuracy;
  final double recall;
  final String status;
  final Map<String, dynamic> parameters;
  final Map<String, double> metrics;
  final String trainedOnFile;
  final String trainedOnFileUrl;

  const LeaderboardEntryModel({
    required this.id,
    required this.name,
    required this.useCase,
    required this.precision,
    required this.accuracy,
    required this.recall,
    required this.status,
    required this.parameters,
    required this.metrics,
    required this.trainedOnFile,
    required this.trainedOnFileUrl,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      id: json['id']?.toString() ?? json['model_id']?.toString() ?? '',
      name: json['name'] ?? json['model_name'] ?? '',
      useCase: json['use_case'] ?? '',
      precision: (json['precision'] ?? 0).toDouble(),
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      recall: (json['recall'] ?? 0).toDouble(),
      status: json['status'] ?? 'inactive',
      parameters: Map<String, dynamic>.from(json['parameters'] ?? json['hparams'] ?? {}),
      metrics: Map<String, double>.from(
        (json['metrics'] ?? {}).map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
      ),
      trainedOnFile: json['trained_on_file'] ?? json['dataset_file'] ?? '',
      trainedOnFileUrl: json['trained_on_file_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'use_case': useCase,
      'precision': precision,
      'accuracy': accuracy,
      'recall': recall,
      'status': status,
      'parameters': parameters,
      'metrics': metrics,
      'trained_on_file': trainedOnFile,
      'trained_on_file_url': trainedOnFileUrl,
    };
  }

  LeaderboardEntryModel copyWith({
    String? id,
    String? name,
    String? useCase,
    double? precision,
    double? accuracy,
    double? recall,
    String? status,
    Map<String, dynamic>? parameters,
    Map<String, double>? metrics,
    String? trainedOnFile,
    String? trainedOnFileUrl,
  }) {
    return LeaderboardEntryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      useCase: useCase ?? this.useCase,
      precision: precision ?? this.precision,
      accuracy: accuracy ?? this.accuracy,
      recall: recall ?? this.recall,
      status: status ?? this.status,
      parameters: parameters ?? this.parameters,
      metrics: metrics ?? this.metrics,
      trainedOnFile: trainedOnFile ?? this.trainedOnFile,
      trainedOnFileUrl: trainedOnFileUrl ?? this.trainedOnFileUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        useCase,
        precision,
        accuracy,
        recall,
        status,
        parameters,
        metrics,
        trainedOnFile,
        trainedOnFileUrl,
      ];
}
