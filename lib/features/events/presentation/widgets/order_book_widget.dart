import 'package:flutter/material.dart';

class OrderBookWidget extends StatelessWidget {
  final List<Map<double, int>> yesOrders;
  final List<Map<double, int>> noOrders;

  const OrderBookWidget({
    super.key,
    required this.yesOrders,
    required this.noOrders,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = constraints.maxWidth / 2 - 32;

        /// Find the longer list between yesOrders and noOrders
        final yesOrdersLength = yesOrders.fold(0, (sum, map) => sum + map.length);
        final noOrdersLength = noOrders.fold(0, (sum, map) => sum + map.length);
        final maxOrderCount = yesOrdersLength > noOrdersLength
            ? yesOrdersLength
            : noOrdersLength;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildHorizontalBars(
                  yesOrders,
                  halfWidth,
                  Colors.blue,
                  "Yes",
                  maxOrderCount,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildHorizontalBars(
                  noOrders,
                  halfWidth,
                  Colors.red,
                  "No",
                  maxOrderCount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildHorizontalBars(
      List<Map<double, int>> orders,
      double maxWidth,
      Color color,
      String label,
      int maxOrderCount,
      ) {
    /// Flatten the list of maps into a single list of key-value pairs
    final flattenedOrders = orders.expand((order) => order.entries).toList();

    /// Sort the orders in descending order by quantity
    flattenedOrders.sort((a, b) => b.value.compareTo(a.value));

    final totalQuantity = flattenedOrders.fold<int>(
      0,
          (sum, entry) => sum + entry.value,
    );

    final bars = <Widget>[
      Row(
        children: [
          Text(
            "QTY AT $label",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Text(
            "PRICE",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
    ];

    for (final entry in flattenedOrders) {
      final price = entry.key;
      final quantity = entry.value;

      if (quantity > 0) {
        /// Calculate bar width proportionally
        final barWidth = (quantity / totalQuantity) * (maxWidth - 40); /// Reserve space for price

        bars.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: barWidth,
                      height: 35.0,
                      color: color.withOpacity(0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  price.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }
    }

    /// Fill empty space to align both columns
    while (bars.length < maxOrderCount + 2) {
      bars.add(const SizedBox(height: 43.0));
    }

    return bars;
  }
}
