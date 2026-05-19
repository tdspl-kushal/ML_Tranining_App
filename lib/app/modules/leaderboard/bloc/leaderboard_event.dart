import 'package:equatable/equatable.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}



class RefreshLeaderboard extends LeaderboardEvent {
  const RefreshLeaderboard();
}

class FilterByUseCase extends LeaderboardEvent {
  final String useCase; // slug string
  const FilterByUseCase(this.useCase);

  @override
  List<Object?> get props => [useCase];
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
