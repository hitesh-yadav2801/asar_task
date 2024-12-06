import 'package:asar/core/error/failure.dart';
import 'package:asar/core/usecase/usecase.dart';
import 'package:asar/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendOtpUseCase implements UseCase<String, String> {
  final AuthRepository authRepository;

  SendOtpUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await authRepository.requestOtp(phoneNumber: params);
  }
}
