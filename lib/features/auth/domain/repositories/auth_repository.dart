import 'package:asar/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> requestOtp({required String phoneNumber});
  Future<Either<Failure, String>> verifyOtp({required String otp, required String sessionId, required String phoneNumber});
}