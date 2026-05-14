import 'package:equatable/equatable.dart';

class UseCaseModel extends Equatable {
  final String id;
  final String name;
  final String? description;

  const UseCaseModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory UseCaseModel.fromJson(Map<String, dynamic> json) {
    return UseCaseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  UseCaseModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return UseCaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, description];
}
