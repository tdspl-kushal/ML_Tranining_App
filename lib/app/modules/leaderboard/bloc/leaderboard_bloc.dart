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
    on<RenameModel>(_onRenameModel);
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
    // TODO: Implement model download
  }

  Future<void> _onRenameModel(RenameModel event, Emitter<LeaderboardState> emit) async {
    // TODO: Implement rename API call with payload: profileId, modelId, newName
    // For now, optimistic update
    final currentState = state;
    if (currentState is LeaderboardLoaded) {
      final updatedEntries = currentState.entries.map((e) {
        if (e.id == event.modelId) {
          return e.copyWith(name: event.newName);
        }
        return e;
      }).toList();
      emit(LeaderboardLoaded(
        entries: updatedEntries,
        expandedIds: currentState.expandedIds,
      ));
    }
  }

  Future<void> _onDeleteModel(DeleteModel event, Emitter<LeaderboardState> emit) async {
    // TODO: Implement delete API call
    // For now, optimistic update
    final currentState = state;
    if (currentState is LeaderboardLoaded) {
      final updatedEntries = currentState.entries.where((e) => e.id != event.modelId).toList();
      emit(LeaderboardLoaded(
        entries: updatedEntries,
        expandedIds: currentState.expandedIds,
      ));
    }
  }
}
