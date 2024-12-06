import 'package:asar/features/auth/domain/use_cases/send_otp_use_case.dart';
import 'package:asar/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  AuthBloc({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        super(AuthInitialState()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoadingState());
    });
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  void _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    final response = await _sendOtpUseCase.call(event.phoneNumber);
    response.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (sessionId) => emit(OtpGeneratedSuccessState(sessionId)),
    );
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    final response = await _verifyOtpUseCase.call(
      VerifyOtpParams(
        sessionId: event.sessionId,
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      ),
    );
    response.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (token) {
        emit(OtpVerifiedState(token));

      }
    );
  }
}
