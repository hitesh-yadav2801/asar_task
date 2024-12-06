part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  SendOtpEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

final class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String otp;
  final String sessionId;

  VerifyOtpEvent({
    required this.phoneNumber,
    required this.sessionId,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp, sessionId];
}
