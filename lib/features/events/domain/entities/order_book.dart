import 'package:asar/features/events/domain/entities/order_entity.dart';

class OrderBook {
  final List<OrderEntity> yesOrders;
  final List<OrderEntity> noOrders;

  OrderBook({
    required this.yesOrders,
    required this.noOrders,
  });
}


