import 'package:flutter_bloc/flutter_bloc.dart';
import 'leaderboard_event.dart';
import 'leaderboard_state.dart';
import '../repository/leaderboard_repository.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final ILeaderboardRepository _repository;

  LeaderboardBloc(this._repository) : super(const LeaderboardInitial()) {
    on<RefreshLeaderboard>(_onRefreshLeaderboard);
    on<FilterByUseCase>(_onFilterByUseCase);
    on<ToggleModelExpansion>(_onToggleExpansion);
    on<DownloadModel>(_onDownloadModel);
    on<DeleteModel>(_onDeleteModel);
  }



  Future<void> _onRefreshLeaderboard(
      RefreshLeaderboard event, Emitter<LeaderboardState> emit) async {
    // Re-fetch with the currently active filter, fallback to default
    final currentFilter =
        state is LeaderboardLoaded ? (state as LeaderboardLoaded).activeFilter : 'failure_prediction';
    emit(const LeaderboardLoading());
    final result = await _repository.fetchModels(useCase: currentFilter);
    result.fold(
      (failure) => emit(LeaderboardError(failure.message)),
      (entries) => emit(LeaderboardLoaded(
        entries: entries,
        activeFilter: currentFilter,
      )),
    );
  }

  Future<void> _onFilterByUseCase(
      FilterByUseCase event, Emitter<LeaderboardState> emit) async {
    emit(const LeaderboardLoading());
    final result = await _repository.fetchModels(useCase: event.useCase);
    result.fold(
      (failure) => emit(LeaderboardError(failure.message)),
      (entries) => emit(LeaderboardLoaded(
        entries: entries,
        expandedIds: const {},
        activeFilter: event.useCase,
      )),
    );
  }

  void _onToggleExpansion(
      ToggleModelExpansion event, Emitter<LeaderboardState> emit) {
    final currentState = state;
    if (currentState is LeaderboardLoaded) {
      final expandedIds = Set<String>.from(currentState.expandedIds);
      if (expandedIds.contains(event.modelId)) {
        expandedIds.remove(event.modelId);
      } else {
        expandedIds.add(event.modelId);
      }
      emit(currentState.copyWith(expandedIds: expandedIds));
    }
  }

  Future<void> _onDownloadModel(
      DownloadModel event, Emitter<LeaderboardState> emit) async {
    emit(ModelDownloading(event.modelId));
    final result =
        await _repository.downloadModel(event.modelId, event.modelName);
    result.fold(
      (failure) => emit(ModelDownloadError(failure.message)),
      (filePath) => emit(ModelDownloadSuccess(filePath)),
    );
  }

  Future<void> _onDeleteModel(
      DeleteModel event, Emitter<LeaderboardState> emit) async {
    // Snapshot loaded state before emitting deleting
    LeaderboardLoaded? snapshot;
    if (state is LeaderboardLoaded) snapshot = state as LeaderboardLoaded;

    emit(ModelDeleting());
    final result = await _repository.deleteModel(event.modelId);
    result.fold(
      (failure) => emit(ModelDeleteError(failure.message)),
      (_) {
        if (snapshot != null) {
          final updated =
              snapshot.entries.where((e) => e.id != event.modelId).toList();
          emit(snapshot.copyWith(entries: updated));
        }
        emit(ModelDeleteSuccess(event.modelId));
      },
    );
  }
}
