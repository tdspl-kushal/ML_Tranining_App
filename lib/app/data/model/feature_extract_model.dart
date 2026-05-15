import 'package:equatable/equatable.dart';

class FeatureExtractModel extends Equatable {
  final String featureSchemaId;
  final String datasetId;
  final List<String> tags;
  final List<String> mandatoryFeatures;
  final List<String> optionalFeatures;
  final List<String> crossTagAvailable;
  final List<String> crossTagPresentInData;
  final String targetCol;
  final bool targetPresent;
  final int totalColumns;
  final List<String> resolvedColumnsSample;

  const FeatureExtractModel({
    required this.featureSchemaId,
    required this.datasetId,
    required this.tags,
    required this.mandatoryFeatures,
    required this.optionalFeatures,
    required this.crossTagAvailable,
    required this.crossTagPresentInData,
    required this.targetCol,
    required this.targetPresent,
    required this.totalColumns,
    required this.resolvedColumnsSample,
  });

  factory FeatureExtractModel.fromJson(Map<String, dynamic> json) {
    final perTag = json['per_tag_features'] as Map<String, dynamic>? ?? {};
    final crossTag = json['cross_tag_features'] as Map<String, dynamic>? ?? {};

    return FeatureExtractModel(
      featureSchemaId: json['feature_schema_id']?.toString() ?? '',
      datasetId: json['dataset_id']?.toString() ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      mandatoryFeatures: List<String>.from(perTag['mandatory'] ?? []),
      optionalFeatures: List<String>.from(perTag['optional'] ?? []),
      crossTagAvailable: List<String>.from(crossTag['available'] ?? []),
      crossTagPresentInData: List<String>.from(crossTag['present_in_data'] ?? []),
      targetCol: json['target_col']?.toString() ?? '',
      targetPresent: json['target_present'] as bool? ?? false,
      totalColumns: json['total_columns'] as int? ?? 0,
      resolvedColumnsSample: List<String>.from(json['resolved_columns_sample'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
        featureSchemaId,
        datasetId,
        tags,
        mandatoryFeatures,
        optionalFeatures,
        crossTagAvailable,
        crossTagPresentInData,
        targetCol,
        targetPresent,
        totalColumns,
        resolvedColumnsSample,
      ];
}
