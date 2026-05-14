import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfiles extends DashboardEvent {
  const LoadProfiles();
}

class SearchProfiles extends DashboardEvent {
  final String query;

  const SearchProfiles(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshProfiles extends DashboardEvent {
  const RefreshProfiles();
}

class RenameProfile extends DashboardEvent {
  final String profileId;
  final String newName;

  const RenameProfile({required this.profileId, required this.newName});

  @override
  List<Object?> get props => [profileId, newName];
}

class DeleteProfile extends DashboardEvent {
  final String profileId;

  const DeleteProfile(this.profileId);

  @override
  List<Object?> get props => [profileId];
}
