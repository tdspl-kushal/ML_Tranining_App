import 'package:equatable/equatable.dart';

class HparamDefinition extends Equatable {
  final dynamic value;
  final String type; // "int" | "float" | "string"
  final double? min;
  final double? max;
  final String description;

  const HparamDefinition({
    required this.value,
    required this.type,
    this.min,
    this.max,
    required this.description,
  });

  factory HparamDefinition.fromJson(Map<String, dynamic> json) {
    return HparamDefinition(
      value: json['value'],
      type: json['type']?.toString() ?? 'string',
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      description: json['description']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [value, type, min, max, description];
}

class HparamsModel extends Equatable {
  final String useCase;
  final String modelType;
  final String outputTag;
  final bool requiresTraining;
  final Map<String, HparamDefinition> tier1;
  final Map<String, HparamDefinition> tier2;
  final Map<String, HparamDefinition> tier3;

  const HparamsModel({
    required this.useCase,
    required this.modelType,
    required this.outputTag,
    required this.requiresTraining,
    required this.tier1,
    required this.tier2,
    required this.tier3,
  });

  factory HparamsModel.fromJson(Map<String, dynamic> json) {
    Map<String, HparamDefinition> parseParams(Map<String, dynamic>? raw) {
      if (raw == null) return {};
      return raw.map((k, v) => MapEntry(k, HparamDefinition.fromJson(v as Map<String, dynamic>)));
    }

    return HparamsModel(
      useCase: json['use_case']?.toString() ?? '',
      modelType: json['model_type']?.toString() ?? '',
      outputTag: json['output_tag']?.toString() ?? '',
      requiresTraining: json['requires_training'] as bool? ?? true,
      tier1: parseParams(json['tier1'] as Map<String, dynamic>?),
      tier2: parseParams(json['tier2'] as Map<String, dynamic>?),
      tier3: parseParams(json['tier3'] as Map<String, dynamic>?),
    );
  }

  @override
  List<Object?> get props => [useCase, modelType, outputTag, requiresTraining, tier1, tier2, tier3];
}
