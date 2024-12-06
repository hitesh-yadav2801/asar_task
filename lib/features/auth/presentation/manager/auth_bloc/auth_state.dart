part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitialState extends AuthState {}

final class OtpGeneratedSuccessState extends AuthState {
  final String sessionId;

  OtpGeneratedSuccessState(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

final class OtpVerifiedState extends AuthState {
  final String token;

  OtpVerifiedState(this.token);

  @override
  List<Object?> get props => [token];
}


final class AuthLoadingState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
