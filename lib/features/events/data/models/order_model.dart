import 'package:asar/features/events/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.eventId,
    required super.type,
    required super.quantity,
    required super.price,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      eventId: json['eventId'],
      type: json['type'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'type': type,
      'quantity': quantity,
      'price': price,
    };
  }

  OrderModel copyWith({
    String? eventId,
    String? type,
    num? quantity,
    num? price,
  }) {
    return OrderModel(
      eventId: eventId ?? this.eventId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'OrderModel(eventId: $eventId, type: $type, quantity: $quantity, price: $price)';
  }
}
