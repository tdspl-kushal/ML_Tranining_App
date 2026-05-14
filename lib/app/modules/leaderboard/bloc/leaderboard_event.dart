import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadLeaderboard extends LeaderboardEvent {
  final String profileId;

  const LoadLeaderboard(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class ToggleModelExpansion extends LeaderboardEvent {
  final String modelId;

  const ToggleModelExpansion(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class DownloadModel extends LeaderboardEvent {
  final String modelId;

  const DownloadModel(this.modelId);

  @override
  List<Object?> get props => [modelId];
}

class RenameModel extends LeaderboardEvent {
  final String profileId;
  final String modelId;
  final String newName;

  const RenameModel({
    required this.profileId,
    required this.modelId,
    required this.newName,
  });

  @override
  List<Object?> get props => [profileId, modelId, newName];
}

class DeleteModel extends LeaderboardEvent {
  final String modelId;

  const DeleteModel(this.modelId);

  @override
  List<Object?> get props => [modelId];
}
