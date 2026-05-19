import 'dart:async';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/local/preference/app_preferences.dart';
import '../../../data/model/user_profile_model.dart';
import '../repository/auth_repository.dart';

class AuthManager {
  final IAuthRepository _authRepository;
  final Dio _dio;

  UserProfileModel? _profile;
  Timer? _refreshTimer;
  final StreamController<UserProfileModel?> _profileController =
      StreamController<UserProfileModel?>.broadcast();

  AuthManager(this._authRepository, this._dio);

  UserProfileModel? get currentProfile => _profile;
  Stream<UserProfileModel?> get profileStream => _profileController.stream;

  /// Fetches User Profile details from the API.
  Future<void> fetchUserProfile() async {
    try {
      final response = await _dio.post(
        '${ApiConstants.mainUrl}${ApiConstants.getUserProfile}',
        data: {},
      );

      final dynamic data = response.data['data'];
      if (data is List && data.isNotEmpty) {
        _profile = UserProfileModel.fromJson(Map<String, dynamic>.from(data.first));
        _profileController.add(_profile);
      }
    } catch (e) {
      // ignore: avoid_print
      print('AuthManager: Error fetching user profile: $e');
    }
  }

  /// Starts the token refresh timer to refresh the token every 895 seconds.
  void startTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 895), (timer) async {
      // ignore: avoid_print
      print('AuthManager: Running background token refresh...');
      await refreshToken();
    });
  }

  /// Stops the token refresh timer.
  void stopTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Background token refresh logic.
  Future<void> refreshToken() async {
    final serverUrl = AppPreferences.getString('api_base_url');
    final username = AppPreferences.getString('auth_username');
    final password = AppPreferences.getString('auth_password');

    if (serverUrl == null || username == null || password == null) {
      // ignore: avoid_print
      print('AuthManager: Missing credentials to run auto-refresh');
      return;
    }

    final result = await _authRepository.signIn(
      serverUrl: serverUrl,
      username: username,
      password: password,
    );

    result.fold(
      (failure) {
        // ignore: avoid_print
        print('AuthManager: Token refresh failed: ${failure.message}');
      },
      (newToken) async {
        // Save new token
        await AppPreferences.setString('auth_token', newToken);
        _dio.options.headers['Authorization'] = 'Bearer $newToken';
        // ignore: avoid_print
        print('AuthManager: Token successfully refreshed');
      },
    );
  }

  /// Signs the user out, cleans up preferences, and stops the timer.
  Future<void> signOut() async {
    stopTokenRefreshTimer();
    _profile = null;
    _profileController.add(null);
    await AppPreferences.remove('auth_token');
    await AppPreferences.remove('auth_username');
    await AppPreferences.remove('auth_password');
  }
}
