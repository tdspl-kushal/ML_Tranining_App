import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}



class ManualServerEntered extends SignInEvent {
  final String serverUrl;
  const ManualServerEntered(this.serverUrl);

  @override
  List<Object?> get props => [serverUrl];
}

class SignInSubmitted extends SignInEvent {
  final String username;
  final String password;

  const SignInSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
