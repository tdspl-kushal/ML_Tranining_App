import 'package:equatable/equatable.dart';
import '../../../data/model/profile_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final List<ProfileModel> profiles;
  final List<ProfileModel> filteredProfiles;
  final String searchQuery;

  const DashboardLoaded({
    required this.profiles,
    required this.filteredProfiles,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [profiles, filteredProfiles, searchQuery];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
