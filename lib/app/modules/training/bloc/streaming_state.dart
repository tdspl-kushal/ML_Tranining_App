import 'package:equatable/equatable.dart';
import '../../../data/model/training_result_model.dart';

abstract class StreamingState extends Equatable {
  const StreamingState();
  @override
  List<Object?> get props => [];
}

class StreamingInitial extends StreamingState {
  const StreamingInitial();
}

class StreamingInProgress extends StreamingState {
  final List<String> logLines;
  final double? progress;
  final bool isCompleted;
  final TrainingResultModel? result;

  const StreamingInProgress({
    required this.logLines,
    this.progress,
    this.isCompleted = false,
    this.result,
  });

  StreamingInProgress copyWith({
    List<String>? logLines,
    double? progress,
    bool? isCompleted,
    TrainingResultModel? result,
  }) {
    return StreamingInProgress(
      logLines: logLines ?? this.logLines,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [logLines, progress, isCompleted, result];
}

class StreamingFailed extends StreamingState {
  final String message;
  const StreamingFailed(this.message);
  @override
  List<Object?> get props => [message];
}
