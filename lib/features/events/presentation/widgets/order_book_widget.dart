import 'package:flutter/material.dart';

class OrderBook extends StatelessWidget {
  final List<OrderBookEntry> orderBook;

  const OrderBook({super.key, required this.orderBook});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Book', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1),
              ...orderBook.map((entry) => _buildRow(entry)).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildRow(OrderBookEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              entry.type.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: entry.type == 'buy' ? Colors.green : Colors.red,
              ),
            ),
          ),
          Expanded(child: Text('₹${entry.price.toStringAsFixed(2)}')),
          Expanded(child: Text('${entry.quantity}')),
        ],
      ),
    );
  }
}

class OrderBookEntry {
  final String type;
  final double price;
  final int quantity;

  OrderBookEntry({
    required this.type,
    required this.price,
    required this.quantity,
  });

  factory OrderBookEntry.fromJson(Map<String, dynamic> json) {
    return OrderBookEntry(
      type: json['type'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}

