import 'package:asar/core/error/exception.dart';
import 'package:asar/core/error/failure.dart';
import 'package:asar/features/auth/data/data_sources/auth_data_source.dart';
import 'package:asar/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Future<Either<Failure, String>> requestOtp({required String phoneNumber}) async {
    try {
      final response = await authDataSource.requestOtp(phoneNumber: phoneNumber);
      if (response == null) {
        return Left(Failure('Failed to send OTP'));
      }
      return Right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({required String otp, required String sessionId, required String phoneNumber}) async {
    try {
      final response = await authDataSource.verifyOtp(otp: otp, sessionId: sessionId, phoneNumber: phoneNumber);
      if (response == null) {
        return Left(Failure('Failed to verify OTP'));
      }
      return Right(response);
    } on ServerException catch (e) {
      throw Left(Failure(e.message));
    }
  }
}