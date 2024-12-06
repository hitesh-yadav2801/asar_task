import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService({required this.storage});

  /// Save the token securely
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  /// Read the token
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  /// Delete the token
  Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }
}