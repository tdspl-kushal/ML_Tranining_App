import 'package:equatable/equatable.dart';

class UploadSessionModel extends Equatable {
  final String sessionId;
  final bool profileExists;
  final String? profileName;
  final List<String> columns;
  final int rowCount;

  const UploadSessionModel({
    required this.sessionId,
    required this.profileExists,
    this.profileName,
    required this.columns,
    required this.rowCount,
  });

  factory UploadSessionModel.fromJson(Map<String, dynamic> json) {
    return UploadSessionModel(
      sessionId: json['session_id']?.toString() ?? json['dataset_id']?.toString() ?? '',
      profileExists: json['profile_exists'] ?? json['is_duplicate'] ?? false,
      profileName: json['profile_name'],
      columns: List<String>.from(
        json['inferred_schema']?['columns'] ??
            json['tags_detected'] ??
            [],
      ),
      rowCount: json['inferred_schema']?['row_count'] ?? json['row_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'profile_exists': profileExists,
      'profile_name': profileName,
      'inferred_schema': {
        'columns': columns,
        'row_count': rowCount,
      },
    };
  }

  UploadSessionModel copyWith({
    String? sessionId,
    bool? profileExists,
    String? profileName,
    List<String>? columns,
    int? rowCount,
  }) {
    return UploadSessionModel(
      sessionId: sessionId ?? this.sessionId,
      profileExists: profileExists ?? this.profileExists,
      profileName: profileName ?? this.profileName,
      columns: columns ?? this.columns,
      rowCount: rowCount ?? this.rowCount,
    );
  }

  @override
  List<Object?> get props => [sessionId, profileExists, profileName, columns, rowCount];
}
