import 'dart:convert';
import 'training_result_model.dart';

enum StreamEventType { log, progress, completed, error }

class TrainingStreamEvent {
  final StreamEventType type;
  final String? message;
  final double? progress;
  final TrainingResultModel? result;
  final String? errorMessage;

  const TrainingStreamEvent({
    required this.type,
    this.message,
    this.progress,
    this.result,
    this.errorMessage,
  });

  /// Plain log line (non-JSON)
  factory TrainingStreamEvent.log(String message) => TrainingStreamEvent(
        type: StreamEventType.log,
        message: message,
      );

  /// Parse from a JSON chunk arriving on the stream
  factory TrainingStreamEvent.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String?;
    if (status == 'completed') {
      return TrainingStreamEvent(
        type: StreamEventType.completed,
        result: TrainingResultModel.fromJson(json),
      );
    }
    if (status == 'error' || json.containsKey('error')) {
      return TrainingStreamEvent(
        type: StreamEventType.error,
        errorMessage: json['error']?.toString() ??
            json['message']?.toString() ??
            'Training error',
      );
    }
    return TrainingStreamEvent(
      type: StreamEventType.log,
      message: json['message']?.toString() ?? json.toString(),
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }

  /// Parse a raw line coming from the SSE stream.
  /// Handles "data: {...}" SSE envelope and plain text.
  static TrainingStreamEvent parseLine(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return TrainingStreamEvent.log('');

    final raw =
        trimmed.startsWith('data:') ? trimmed.substring(5).trim() : trimmed;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return TrainingStreamEvent.fromJson(json);
    } catch (_) {
      return TrainingStreamEvent.log(raw);
    }
  }
}
