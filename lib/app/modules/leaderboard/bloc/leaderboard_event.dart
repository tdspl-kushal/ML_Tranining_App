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
  final String modelName;

  const DownloadModel(this.modelId, this.modelName);

  @override
  List<Object?> get props => [modelId, modelName];
}



class DeleteModel extends LeaderboardEvent {
  final String modelId;

  const DeleteModel(this.modelId);

  @override
  List<Object?> get props => [modelId];
}
