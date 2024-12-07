import 'package:asar/features/events/data/models/order_model.dart';
import 'package:asar/features/events/domain/entities/order_book.dart';

class OrderBookModel extends OrderBook {
  OrderBookModel({
    required super.yesOrders,
    required super.noOrders,
  });

  factory OrderBookModel.fromJson(Map<String, dynamic> json) {
    return OrderBookModel(
      yesOrders: (json['data']['yesOrders'] as List?)
          ?.map((orderJson) =>
          OrderModel.fromJson(orderJson as Map<String, dynamic>))
          .toList() ??
          [],
      noOrders: (json['data']['noOrders'] as List?)
          ?.map((orderJson) =>
          OrderModel.fromJson(orderJson as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

}
