import 'package:equatable/equatable.dart';

class LeaderboardEntryModel extends Equatable {
  final String id;
  final String? modelName;
  final String useCase;
  final String modelType;
  final int version;
  final String status;
  final Map<String, dynamic>? metrics;
  final Map<String, double>? featureImportance;
  final Map<String, dynamic> hparamsUsed;
  final List<String> tagsUsed;
  final double? trainingDurationSeconds;
  final String? completedAt;
  final String createdAt;

  const LeaderboardEntryModel({
    required this.id,
    this.modelName,
    required this.useCase,
    this.modelType = '',
    required this.version,
    required this.status,
    this.metrics,
    this.featureImportance,
    this.hparamsUsed = const {},
    this.tagsUsed = const [],
    this.trainingDurationSeconds,
    this.completedAt,
    this.createdAt = '',
  });

  /// Display name: prefer model_name, fall back to "v{version}"
  String get displayName => modelName?.isNotEmpty == true ? modelName! : 'v$version';

  // Dynamic IMP Metrics Helpers
  String? get impPrimaryMetric => _getImpMetricName('primary');
  double? get impPrimaryValue => _getImpMetricValue('primary');
  String? get impPrimaryDirection => _getImpMetricDirection('primary');

  String? get impSecondaryMetric => _getImpMetricName('secondary');
  double? get impSecondaryValue => _getImpMetricValue('secondary');
  String? get impSecondaryDirection => _getImpMetricDirection('secondary');

  String? get impTertiaryMetric => _getImpMetricName('tertiary');
  double? get impTertiaryValue => _getImpMetricValue('tertiary');
  String? get impTertiaryDirection => _getImpMetricDirection('tertiary');

  String? _getImpMetricName(String level) {
    if (metrics == null || metrics!['imp'] == null) return null;
    final imp = metrics!['imp'];
    if (imp is Map && imp[level] is Map) {
      return imp[level]['metric']?.toString();
    }
    return null;
  }

  double? _getImpMetricValue(String level) {
    if (metrics == null || metrics!['imp'] == null) return null;
    final imp = metrics!['imp'];
    if (imp is Map && imp[level] is Map) {
      final val = imp[level]['value'];
      if (val is num) return val.toDouble();
    }
    return null;
  }

  String? _getImpMetricDirection(String level) {
    if (metrics == null || metrics!['imp'] == null) return null;
    final imp = metrics!['imp'];
    if (imp is Map && imp[level] is Map) {
      return imp[level]['direction']?.toString();
    }
    return null;
  }

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    // Metrics
    Map<String, dynamic>? metricsMap;
    if (json['metrics'] is Map) {
      metricsMap = Map<String, dynamic>.from(json['metrics'] as Map);
    }

    // Feature importance
    Map<String, double>? fi;
    if (json['feature_importance'] is Map) {
      fi = Map<String, double>.fromEntries(
        (json['feature_importance'] as Map).entries
            .where((e) => e.value is num)
            .map((e) => MapEntry(e.key.toString(), (e.value as num).toDouble())),
      );
    }

    // Hparams used
    Map<String, dynamic> hparams = {};
    for (final key in ['hparams_used', 'hparams', 'parameters']) {
      if (json[key] is Map) {
        hparams = Map<String, dynamic>.from(json[key] as Map);
        break;
      }
    }

    // Tags used
    List<String> tags = [];
    if (json['tags_used'] is List) {
      tags = (json['tags_used'] as List).map((e) => e.toString()).toList();
    } else if (json['tags'] is List) {
      tags = (json['tags'] as List).map((e) => e.toString()).toList();
    }

    return LeaderboardEntryModel(
      id: json['id']?.toString() ?? '',
      modelName: json['model_name']?.toString(),
      useCase: json['use_case']?.toString() ?? '',
      modelType: json['model_type']?.toString() ?? '',
      version: json['version'] is int
          ? json['version'] as int
          : int.tryParse(json['version']?.toString() ?? '1') ?? 1,
      status: json['status']?.toString() ?? 'inactive',
      metrics: metricsMap,
      featureImportance: fi,
      hparamsUsed: hparams,
      tagsUsed: tags,
      trainingDurationSeconds: json['training_duration_seconds'] is num
          ? (json['training_duration_seconds'] as num).toDouble()
          : null,
      completedAt: json['completed_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  LeaderboardEntryModel copyWith({
    String? id,
    String? modelName,
    String? useCase,
    String? modelType,
    int? version,
    String? status,
    Map<String, dynamic>? metrics,
    Map<String, double>? featureImportance,
    Map<String, dynamic>? hparamsUsed,
    List<String>? tagsUsed,
    double? trainingDurationSeconds,
    String? completedAt,
    String? createdAt,
  }) {
    return LeaderboardEntryModel(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      useCase: useCase ?? this.useCase,
      modelType: modelType ?? this.modelType,
      version: version ?? this.version,
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      featureImportance: featureImportance ?? this.featureImportance,
      hparamsUsed: hparamsUsed ?? this.hparamsUsed,
      tagsUsed: tagsUsed ?? this.tagsUsed,
      trainingDurationSeconds: trainingDurationSeconds ?? this.trainingDurationSeconds,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, modelName, useCase, modelType, version, status,
        metrics, featureImportance, hparamsUsed, tagsUsed,
        trainingDurationSeconds, completedAt, createdAt,
      ];
}
