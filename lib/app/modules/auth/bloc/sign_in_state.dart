import 'package:equatable/equatable.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  final String? selectedServer;
  final SignInStatus status;
  final String? errorMessage;
  final bool? isServerHealthy;

  const SignInState({
    this.selectedServer,
    this.status = SignInStatus.initial,
    this.errorMessage,
    this.isServerHealthy,
  });

  SignInState copyWith({
    String? selectedServer,
    SignInStatus? status,
    String? errorMessage,
    bool? isServerHealthy,
  }) {
    return SignInState(
      selectedServer: selectedServer ?? this.selectedServer,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isServerHealthy: isServerHealthy ?? this.isServerHealthy,
    );
  }

  @override
  List<Object?> get props => [
        selectedServer,
        status,
        errorMessage,
        isServerHealthy,
      ];
}
