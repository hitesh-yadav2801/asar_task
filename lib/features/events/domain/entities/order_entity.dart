class OrderEntity {
  final String eventId;
  final String type;
  final int quantity;
  final double price;

  OrderEntity({
    required this.eventId,
    required this.type,
    required this.quantity,
    required this.price,
  });
}