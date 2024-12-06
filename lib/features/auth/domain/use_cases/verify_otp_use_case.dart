import 'package:asar/core/error/failure.dart';
import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOtpUseCase implements UseCase<String, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await authRepository.verifyOtp(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
      sessionId: params.sessionId,
    );
  }
}

/// Parameters needed for OTP verification
class VerifyOtpParams {
  final String phoneNumber;
  final String otp;
  final String sessionId;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
    required this.sessionId,
  });
}
