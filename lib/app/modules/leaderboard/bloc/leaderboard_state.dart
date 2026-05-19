import 'package:equatable/equatable.dart';
import '../../../data/model/leaderboard_entry_model.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntryModel> entries;
  final Set<String> expandedIds;
  final String activeFilter; // use_case slug

  const LeaderboardLoaded({
    required this.entries,
    this.expandedIds = const {},
    required this.activeFilter,
  });

  LeaderboardLoaded copyWith({
    List<LeaderboardEntryModel>? entries,
    Set<String>? expandedIds,
    String? activeFilter,
  }) {
    return LeaderboardLoaded(
      entries: entries ?? this.entries,
      expandedIds: expandedIds ?? this.expandedIds,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [entries, expandedIds, activeFilter];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class ModelDeleting extends LeaderboardState {}

class ModelDeleteSuccess extends LeaderboardState {
  final String modelId;
  const ModelDeleteSuccess(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class ModelDeleteError extends LeaderboardState {
  final String message;
  const ModelDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}

class ModelDownloading extends LeaderboardState {
  final String modelId;
  const ModelDownloading(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class ModelDownloadSuccess extends LeaderboardState {
  final String filePath;
  const ModelDownloadSuccess(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ModelDownloadError extends LeaderboardState {
  final String message;
  const ModelDownloadError(this.message);

  @override
  List<Object?> get props => [message];
}
