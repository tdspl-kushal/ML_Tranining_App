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

  const LeaderboardLoaded({
    required this.entries,
    this.expandedIds = const {},
  });

  @override
  List<Object?> get props => [entries, expandedIds];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object?> get props => [message];
}
