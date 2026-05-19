import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../data/local/preference/app_preferences.dart';
import '../repository/auth_repository.dart';
import '../service/auth_manager.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final IAuthRepository _repository;
  final Dio _dio; // To update the base URL dynamically
  SignInBloc(this._repository, this._dio) : super(const SignInState()) {
    on<ManualServerEntered>(_onManualServerEntered);
    on<SignInSubmitted>(_onSignInSubmitted);
  }



  Future<void> _onManualServerEntered(
      ManualServerEntered event, Emitter<SignInState> emit) async {
    final url = event.serverUrl.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      emit(state.copyWith(
        isServerHealthy: false,
        errorMessage: 'Invalid URL. Must start with http:// or https://',
      ));
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null));
    final result = await _repository.verifyServerHealth(url);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SignInStatus.initial,
        isServerHealthy: false,
        errorMessage: failure.message,
      )),
      (healthy) {
        emit(state.copyWith(
          status: SignInStatus.initial,
          selectedServer: url,
          isServerHealthy: true,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onSignInSubmitted(
      SignInSubmitted event, Emitter<SignInState> emit) async {
    if (state.selectedServer == null) {
      emit(state.copyWith(
        status: SignInStatus.failure,
        errorMessage: 'Please select or enter a server first.',
      ));
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null));
    final result = await _repository.signIn(
      serverUrl: state.selectedServer!,
      username: event.username,
      password: event.password,
    );

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          status: SignInStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (token) async {
        // Save token and server url to preference
        await AppPreferences.setString('auth_token', token);
        await AppPreferences.setString('api_base_url', state.selectedServer!);
        await AppPreferences.setString('auth_username', event.username);
        await AppPreferences.setString('auth_password', event.password);
        
        // Dynamically update base options baseUrl for the app-wide Dio client
        _dio.options.baseUrl = state.selectedServer!;

        // Initialize AuthManager token refresh and profile fetch
        final authManager = GetIt.instance<AuthManager>();
        authManager.startTokenRefreshTimer();
        authManager.fetchUserProfile();

        emit(state.copyWith(status: SignInStatus.success));
      },
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
