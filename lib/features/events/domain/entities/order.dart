class Order {
  final String eventId;
  final String type;
  final int quantity;
  final double price;

  Order({
    required this.eventId,
    required this.type,
    required this.quantity,
    required this.price,
  });
}