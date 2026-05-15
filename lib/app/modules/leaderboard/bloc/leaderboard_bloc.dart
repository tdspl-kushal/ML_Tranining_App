import 'package:flutter_bloc/flutter_bloc.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';
import '../repository/leaderboard_repository.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final ILeaderboardRepository _repository;

  LeaderboardBloc(this._repository) : super(const LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
    on<ToggleModelExpansion>(_onToggleExpansion);
    on<DownloadModel>(_onDownloadModel);
    on<DeleteModel>(_onDeleteModel);
  }

  Future<void> _onLoadLeaderboard(LoadLeaderboard event, Emitter<LeaderboardState> emit) async {
    emit(const LeaderboardLoading());
    final result = await _repository.getLeaderboard(event.profileId);
    result.fold(
      (failure) => emit(LeaderboardError(failure.message)),
      (entries) => emit(LeaderboardLoaded(entries: entries)),
    );
  }

  void _onToggleExpansion(ToggleModelExpansion event, Emitter<LeaderboardState> emit) {
    final currentState = state;
    if (currentState is LeaderboardLoaded) {
      final expandedIds = Set<String>.from(currentState.expandedIds);
      if (expandedIds.contains(event.modelId)) {
        expandedIds.remove(event.modelId);
      } else {
        expandedIds.add(event.modelId);
      }
      emit(LeaderboardLoaded(
        entries: currentState.entries,
        expandedIds: expandedIds,
      ));
    }
  }

  Future<void> _onDownloadModel(DownloadModel event, Emitter<LeaderboardState> emit) async {
    emit(ModelDownloading(event.modelId));
    final result = await _repository.downloadModel(event.modelId, event.modelName);
    result.fold(
      (failure) => emit(ModelDownloadError(failure.message)),
      (filePath) => emit(ModelDownloadSuccess(filePath)),
    );
  }

  Future<void> _onDeleteModel(DeleteModel event, Emitter<LeaderboardState> emit) async {
    emit(ModelDeleting());
    final result = await _repository.deleteModel(event.modelId);
    result.fold(
      (failure) => emit(ModelDeleteError(failure.message)),
      (_) {
        if (state is LeaderboardLoaded) {
          final current = (state as LeaderboardLoaded);
          final updated = current.entries
              .where((e) => e.id != event.modelId)
              .toList();
          emit(current.copyWith(entries: updated));
          emit(ModelDeleteSuccess(event.modelId));
        }
      },
    );
  }
}

