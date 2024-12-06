import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final double currentYesPrice;
  final double currentNoPrice;
  final Function(String type, double price, int quantity) onPlaceOrder;
  final Widget? child;

  const OrderCard({
    super.key,
    required this.currentYesPrice,
    required this.currentNoPrice,
    required this.onPlaceOrder,
    this.child,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final ValueNotifier<double> _price = ValueNotifier<double>(0.0);
  final ValueNotifier<int> _quantity = ValueNotifier<int>(1);
  final ValueNotifier<bool> _isYesSelected = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    // Initialize the price to the currentYesPrice by default
    _price.value = widget.currentYesPrice;
  }

  @override
  void dispose() {
    _price.dispose();
    _quantity.dispose();
    _isYesSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Toggle Yes/No Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isYesSelected,
                  builder: (context, isYesSelected, _) {
                    return Expanded(
                      child: _buildCustomButton(
                        label: 'Yes ₹${widget.currentYesPrice}',
                        isSelected: isYesSelected,
                        color: Colors.green,
                        onTap: () {
                          _isYesSelected.value = true;
                          _price.value = widget.currentYesPrice;
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10.0),
                ValueListenableBuilder<bool>(
                  valueListenable: _isYesSelected,
                  builder: (context, isYesSelected, _) {
                    return Expanded(
                      child: _buildCustomButton(
                        label: 'No ₹${widget.currentNoPrice}',
                        isSelected: !isYesSelected,
                        color: Colors.red,
                        onTap: () {
                          _isYesSelected.value = false;
                          _price.value = widget.currentNoPrice;
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            // Set Price Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Set price', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    _buildIconButton(Icons.remove, () {
                      if (_price.value > 0.5) _price.value -= 0.5;
                    }),
                    const SizedBox(width: 16.0),
                    ValueListenableBuilder<double>(
                      valueListenable: _price,
                      builder: (context, price, _) => Text('₹${price.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16.0),
                    _buildIconButton(Icons.add, () {
                      if (_price.value < 9.5) _price.value += 0.5;
                    }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),

            // Quantity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    _buildIconButton(Icons.remove, () {
                      if (_quantity.value > 1) _quantity.value--;
                    }),
                    const SizedBox(width: 16.0),
                    ValueListenableBuilder<int>(
                      valueListenable: _quantity,
                      builder: (context, quantity, _) => Text('   $quantity   ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16.0),
                    _buildIconButton(Icons.add, () => _quantity.value++),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Summary Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('You put', style: TextStyle(color: Colors.grey)),
                    ValueListenableBuilder2<double, int>(
                      firstNotifier: _price,
                      secondNotifier: _quantity,
                      builder: (context, price, quantity, _) => Text(
                        '₹${(price * quantity).toStringAsFixed(1)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('You get', style: TextStyle(color: Colors.grey)),
                    ValueListenableBuilder<int>(
                      valueListenable: _quantity,
                      builder: (context, quantity, _) => Text(
                        '₹${(quantity * 10).toString()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Place Order Button
            ValueListenableBuilder<bool>(
              valueListenable: _isYesSelected,
              builder: (context, isYesSelected, _) {
                return GestureDetector(
                  onTap: () {
                    widget.onPlaceOrder(
                      isYesSelected ? 'yes' : 'no',
                      _price.value,
                      _quantity.value,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: isYesSelected ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: widget.child ?? const Text(
                      'Place order',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> firstNotifier;
  final ValueListenable<B> secondNotifier;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    Key? key,
    required this.firstNotifier,
    required this.secondNotifier,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: firstNotifier,
      builder: (context, firstValue, _) {
        return ValueListenableBuilder<B>(
          valueListenable: secondNotifier,
          builder: (context, secondValue, __) {
            return builder(context, firstValue, secondValue, __);
          },
        );
      },
    );
  }
}
