import 'package:equatable/equatable.dart';

class FeatureModel extends Equatable {
  final String name;
  final String dataType;
  final bool isMandatory;

  const FeatureModel({
    required this.name,
    required this.dataType,
    this.isMandatory = false,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      name: json['name'] ?? '',
      dataType: json['data_type'] ?? 'string',
      isMandatory: json['is_mandatory'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data_type': dataType,
      'is_mandatory': isMandatory,
    };
  }

  FeatureModel copyWith({
    String? name,
    String? dataType,
    bool? isMandatory,
  }) {
    return FeatureModel(
      name: name ?? this.name,
      dataType: dataType ?? this.dataType,
      isMandatory: isMandatory ?? this.isMandatory,
    );
  }

  @override
  List<Object?> get props => [name, dataType, isMandatory];
}
