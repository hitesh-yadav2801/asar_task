class OrderEntity {
  final String? eventId;
  final String? type;
  final num quantity;
  final num price;

  OrderEntity({
    required this.eventId,
    required this.type,
    required this.quantity,
    required this.price,
  });
}