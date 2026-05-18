import 'package:equatable/equatable.dart';
import '../../../data/model/training_result_model.dart';

abstract class StreamingEvent extends Equatable {
  const StreamingEvent();
  @override
  List<Object?> get props => [];
}

class StartStreaming extends StreamingEvent {
  final TrainingResultModel initialResult;
  const StartStreaming(this.initialResult);
  @override
  List<Object?> get props => [initialResult];
}

class StreamingDone extends StreamingEvent {
  const StreamingDone();
}

class StreamingErrorOccurred extends StreamingEvent {
  final String message;
  const StreamingErrorOccurred(this.message);
  @override
  List<Object?> get props => [message];
}
