import 'package:equatable/equatable.dart';

class ModelParameterModel extends Equatable {
  final String name;
  final dynamic defaultValue;
  final String? type;
  final double? min;
  final double? max;
  final String? description;

  const ModelParameterModel({
    required this.name,
    required this.defaultValue,
    this.type,
    this.min,
    this.max,
    this.description,
  });

  factory ModelParameterModel.fromJson(String name, Map<String, dynamic> json) {
    return ModelParameterModel(
      name: name,
      defaultValue: json['value'] ?? json['default'],
      type: json['type'],
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': defaultValue,
      'type': type,
      'min': min,
      'max': max,
      'description': description,
    };
  }

  ModelParameterModel copyWith({
    String? name,
    dynamic defaultValue,
    String? type,
    double? min,
    double? max,
    String? description,
  }) {
    return ModelParameterModel(
      name: name ?? this.name,
      defaultValue: defaultValue ?? this.defaultValue,
      type: type ?? this.type,
      min: min ?? this.min,
      max: max ?? this.max,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [name, defaultValue, type, min, max, description];
}
