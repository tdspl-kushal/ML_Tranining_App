import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../flavors/flavor_config.dart';
import '../network/dio_client.dart';
import '../modules/dashboard/service/profile_service.dart';
import '../modules/dashboard/repository/profile_repository.dart';
import '../modules/dashboard/bloc/dashboard_bloc.dart';
import '../modules/leaderboard/service/leaderboard_service.dart';
import '../modules/leaderboard/repository/leaderboard_repository.dart';
import '../modules/leaderboard/bloc/leaderboard_bloc.dart';
import '../modules/training/service/training_service.dart';
import '../modules/training/repository/training_repository.dart';
import '../modules/training/bloc/training_wizard_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies({FlavorConfig? config}) async {
  final flavorConfig = config ?? FlavorConfig.development;

  // 1. FlavorConfig
  getIt.registerSingleton<FlavorConfig>(flavorConfig);

  // 2. DioClient
  final dio = DioClient.create(flavorConfig);
  getIt.registerSingleton<Dio>(dio);

  // 3. Services
  getIt.registerLazySingleton<ProfileService>(() => ProfileService(getIt<Dio>()));
  getIt.registerLazySingleton<LeaderboardService>(() => LeaderboardService(getIt<Dio>()));
  getIt.registerLazySingleton<TrainingService>(() => TrainingService(getIt<Dio>()));

  // 4. Repositories
  getIt.registerLazySingleton<IProfileRepository>(() => ProfileRepository(getIt<ProfileService>()));
  getIt.registerLazySingleton<ILeaderboardRepository>(() => LeaderboardRepository(getIt<LeaderboardService>()));
  getIt.registerLazySingleton<ITrainingRepository>(() => TrainingRepository(getIt<TrainingService>()));

  // 5. BLoCs (factory — new instance per usage)
  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(getIt<IProfileRepository>()));
  getIt.registerFactory<LeaderboardBloc>(() => LeaderboardBloc(getIt<ILeaderboardRepository>()));
  getIt.registerFactory<TrainingWizardBloc>(() => TrainingWizardBloc(getIt<ITrainingRepository>()));
}
