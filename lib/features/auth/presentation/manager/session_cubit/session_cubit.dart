import 'package:asar/features/auth/domain/entities/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final FlutterSecureStorage _secureStorage;

  SessionCubit({
    required FlutterSecureStorage secureStorage,
  })  : _secureStorage = secureStorage,
        super(SessionInitialState());

  /// Initializes the session and determines the user's state
  Future<void> checkCurrentSession() async {
    emit(SessionLoadingState());

    try {
      /// Retrieve the token from secure storage
      final token = await _secureStorage.read(key: 'auth_token');

      /// Check if the token exists
      if (token != null) {
        debugPrint('Token found: $token');

        /// Verify the token validity
        final jwt = JWT.decode(token);

        debugPrint('Token is not expired');

        /// Extract user information from the JWT
        final Map<String, dynamic> decodedToken = jwt.payload;
        debugPrint(decodedToken.toString());

        final user = User(id: decodedToken['id'].toString());

        /// Emit a LoggedInState with the token and user data
        emit(SessionLoggedInState(token: token, user: user));
      } else {
        emit(SessionErrorState('No session found. Please log in.'));
      }
    } catch (e) {
      if (e is JWTExpiredException) {
        debugPrint('JWT expired');
        emit(SessionErrorState('Session is expired. Please log in again.'));
      } else if (e is JWTException) {
        debugPrint('JWT error: ${e.message}');
        emit(SessionErrorState('Invalid token. Please log in again.'));
      } else {
        emit(SessionErrorState('An unexpected error occurred'));
      }
    }
  }

  /// logout the user
  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    emit(SessionLoggedOutState());
  }
}
