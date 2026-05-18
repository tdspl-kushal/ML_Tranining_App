import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/training_stream_event.dart';
import '../repository/training_repository.dart';
import 'streaming_event.dart';
import 'streaming_state.dart';

class StreamingBloc extends Bloc<StreamingEvent, StreamingState> {
  final ITrainingRepository _repository;

  StreamingBloc(this._repository) : super(const StreamingInitial()) {
    on<StartStreaming>(_onStartStreaming);
  }

  Future<void> _onStartStreaming(
      StartStreaming event, Emitter<StreamingState> emit) async {
    emit(const StreamingInProgress(logLines: []));

    final result = await _repository.streamTraining(event.initialResult.modelId);

    await result.fold(
      (failure) async {
        emit(StreamingFailed(failure.message));
      },
      (stream) async {
        final logs = <String>[];

        await for (final streamEvent in stream) {
          if (isClosed) break;

          if (streamEvent.type == StreamEventType.log) {
            final msg = streamEvent.message ?? '';
            if (msg.isNotEmpty) {
              logs.add(msg);
              emit(StreamingInProgress(
                logLines: List.unmodifiable(logs),
                progress: streamEvent.progress,
                isCompleted: false,
              ));
            }
          } else if (streamEvent.type == StreamEventType.completed) {
            logs.add('✓ Training completed.');
            
            final finalResult = streamEvent.result?.copyWith(
              modelName: event.initialResult.modelName,
              useCase: event.initialResult.useCase,
            ) ?? event.initialResult;

            emit(StreamingInProgress(
              logLines: List.unmodifiable(logs),
              progress: 1.0,
              isCompleted: true,
              result: finalResult,
            ));
            break;
          } else if (streamEvent.type == StreamEventType.error) {
            emit(StreamingFailed(
                streamEvent.errorMessage ?? 'Stream error'));
            break;
          }
        }
      },
    );
  }
}
