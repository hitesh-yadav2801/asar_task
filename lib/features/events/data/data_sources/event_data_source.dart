import 'dart:convert';
import 'package:asar/core/error/exception.dart';
import 'package:asar/features/events/data/models/event_model.dart';
import 'package:asar/features/events/data/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract interface class EventDataSource {
  Future<List<EventModel?>> getAllEvents();

  Future<OrderModel> placeOrder({required OrderModel orderModel});
}

class EventDataSourceImpl implements EventDataSource {
  final String? baseUrl = dotenv.env['BASE_URL'];

  @override
  Future<List<EventModel?>> getAllEvents() async {
    try {
      /// Send a GET request to the /events endpoint
      final response = await http.get(Uri.parse('$baseUrl/events'));

      /// Check if the response status code is 200 OK
      if (response.statusCode == 200) {
        /// Decode the JSON response into a List<dynamic>
        debugPrint(response.body);
        final List<dynamic> jsonData = json.decode(response.body);

        /// Map each JSON object to an EventModel instance
        return jsonData.map((json) => EventModel.fromJson(json)).toList();
      } else {
        /// Throw an exception if the response is an error
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } on ServerException catch (e) {
      debugPrint(e.message);
      /// Handle any errors that may occur during the request or parsing process
      throw ServerException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      /// Handle any other exceptions that may occur
      throw Exception('Failed to load events: $e');
    }
  }

  @override
  Future<OrderModel> placeOrder({required OrderModel orderModel}) async {
    // TODO: Implement placeOrder
    throw UnimplementedError();
  }
}