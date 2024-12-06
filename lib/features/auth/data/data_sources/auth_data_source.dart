import 'dart:convert';

import 'package:asar/core/error/exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthDataSource {
  Future<String?> requestOtp({required String phoneNumber});

  Future<String?> verifyOtp({
    required String otp,
    required String sessionId,
    required String phoneNumber,
  });
}

class AuthDataSourceImpl implements AuthDataSource {
  final String? baseUrl = dotenv.env['BASE_URL'];
  @override
  Future<String?> requestOtp({required String phoneNumber}) async {
    try{
      final url = '$baseUrl/send-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      /// Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'mobile': phoneNumber,
        }),
      );
      /// Check if the response was successful
      if (response.statusCode == 200) {
        /// Decode the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint(responseData.toString());
        /// Extract and return the sessionId
        return responseData['sessionId'] as String?;
      } else {
        /// Handling non-200 responses
        debugPrint(response.body);
        throw ServerException('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } on ServerException catch (e) {
      debugPrint(e.message);
      throw ServerException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to load events: $e');
    }
  }

  @override
  Future<String?> verifyOtp({required String otp, required String sessionId, required String phoneNumber}) async {
    try{
      final url = '$baseUrl/verify-otp';
      final headers = {
        'Content-Type': 'application/json',
      };
      /// Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'otp': otp,
          'sessionId': sessionId,
          'mobile': phoneNumber,
        }),
      );
      /// Check if the response was successful
      if (response.statusCode == 200) {
        /// Decode the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        /// Extract and return the bearer token
        return responseData['token'] as String?;
      } else {
        /// Handling non-200 responses
        throw ServerException('Error: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
