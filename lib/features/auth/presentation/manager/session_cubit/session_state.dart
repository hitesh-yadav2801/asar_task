part of 'session_cubit.dart';

@immutable
sealed class SessionState extends Equatable {
}

final class SessionInitialState extends SessionState {
  @override
  List<Object> get props => [];
}

final class SessionLoggedInState extends SessionState {
  final User user;
  final String token;

   SessionLoggedInState({required this.user, required this.token});

  @override
  List<Object> get props => [token];
}

final class SessionLoadingState extends SessionState {
  @override
  List<Object> get props => [];
}

final class SessionProfileSetupState extends SessionState {
  final String phoneNumber;

   SessionProfileSetupState({required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}

final class SessionLoggedOutState extends SessionState {
  @override
  List<Object> get props => [];
}

final class SessionErrorState extends SessionState {
  final String message;

   SessionErrorState(this.message);
  @override
  List<Object> get props => [message];
}
