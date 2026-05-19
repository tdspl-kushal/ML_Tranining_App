import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String iconType;
  final int modelCount;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.iconType,
    required this.modelCount,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? json['profile_id']?.toString() ?? '',
      name: json['name'] ?? json['profile_name'] ?? '',
      iconType: json['icon_type'] ?? 'default',
      modelCount: json['model_count'] ?? json['models_count'] ?? json['total_models'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_type': iconType,
      'model_count': modelCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? iconType,
    int? modelCount,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconType: iconType ?? this.iconType,
      modelCount: modelCount ?? this.modelCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, iconType, modelCount, createdAt];
}
