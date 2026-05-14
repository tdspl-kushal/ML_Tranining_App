import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../repository/profile_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final IProfileRepository _repository;

  DashboardBloc(this._repository) : super(const DashboardInitial()) {
    on<LoadProfiles>(_onLoadProfiles);
    on<SearchProfiles>(_onSearchProfiles);
    on<RefreshProfiles>(_onRefreshProfiles);
    on<RenameProfile>(_onRenameProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  Future<void> _onLoadProfiles(LoadProfiles event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    final result = await _repository.getProfiles();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (profiles) => emit(DashboardLoaded(
        profiles: profiles,
        filteredProfiles: profiles,
      )),
    );
  }

  Future<void> _onSearchProfiles(SearchProfiles event, Emitter<DashboardState> emit) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final query = event.query.toLowerCase();
      final filtered = query.isEmpty
          ? currentState.profiles
          : currentState.profiles
              .where((p) => p.name.toLowerCase().contains(query))
              .toList();
      emit(DashboardLoaded(
        profiles: currentState.profiles,
        filteredProfiles: filtered,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onRefreshProfiles(RefreshProfiles event, Emitter<DashboardState> emit) async {
    final result = await _repository.getProfiles();
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (profiles) {
        final currentState = state;
        final query = currentState is DashboardLoaded ? currentState.searchQuery : '';
        final filtered = query.isEmpty
            ? profiles
            : profiles.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
        emit(DashboardLoaded(
          profiles: profiles,
          filteredProfiles: filtered,
          searchQuery: query,
        ));
      },
    );
  }

  Future<void> _onRenameProfile(RenameProfile event, Emitter<DashboardState> emit) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      // Optimistic update
      final updatedProfiles = currentState.profiles.map((p) {
        if (p.id == event.profileId) {
          return p.copyWith(name: event.newName);
        }
        return p;
      }).toList();
      final filtered = currentState.searchQuery.isEmpty
          ? updatedProfiles
          : updatedProfiles.where((p) => p.name.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();
      emit(DashboardLoaded(
        profiles: updatedProfiles,
        filteredProfiles: filtered,
        searchQuery: currentState.searchQuery,
      ));

      // API call
      final result = await _repository.renameProfile(event.profileId, event.newName);
      if (result.isLeft()) {
        // Rollback or show error, for simplicity just reload
        add(const RefreshProfiles());
      }
    }
  }

  Future<void> _onDeleteProfile(DeleteProfile event, Emitter<DashboardState> emit) async {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      // Optimistic update
      final updatedProfiles = currentState.profiles.where((p) => p.id != event.profileId).toList();
      final filtered = currentState.searchQuery.isEmpty
          ? updatedProfiles
          : updatedProfiles.where((p) => p.name.toLowerCase().contains(currentState.searchQuery.toLowerCase())).toList();
      emit(DashboardLoaded(
        profiles: updatedProfiles,
        filteredProfiles: filtered,
        searchQuery: currentState.searchQuery,
      ));

      // API call
      final result = await _repository.deleteProfile(event.profileId);
      if (result.isLeft()) {
        // Rollback or show error
        add(const RefreshProfiles());
      }
    }
  }
}
