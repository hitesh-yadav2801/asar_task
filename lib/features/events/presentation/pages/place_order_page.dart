import 'dart:async';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/presentation/manager/create_order_bloc/create_order_bloc.dart';
import 'package:asar/features/events/presentation/manager/order_book_bloc/order_book_bloc.dart';
import 'package:asar/features/events/presentation/widgets/order_book_widget.dart';
import 'package:asar/features/events/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlaceOrderPage extends StatefulWidget {
  final Event event;

  const PlaceOrderPage({super.key, required this.event});

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  late String authToken;
  late Timer _timer;
  int _errorCount = 0;

  @override
  void initState() {
    super.initState();
    authToken = (context.read<SessionCubit>().state as SessionLoggedInState).token;

    /// Initially fetch the order book
    context.read<OrderBookBloc>().add(FetchOrderBookEvent(eventId: widget.event.eventId));

    /// Start a timer to fetch the order book every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), _fetchOrderBook);
  }

  @override
  void dispose() {
    /// Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void _fetchOrderBook(Timer timer) {
    final currentState = context.read<OrderBookBloc>().state;
    /// If the current state is loading or we've had 5 consecutive errors, don't call again
    if (currentState is OrderBookLoading || _errorCount >= 5) {
      return;
    }
    /// Trigger the event to fetch the order book again
    context.read<OrderBookBloc>().add(FetchOrderBookEvent(eventId: widget.event.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(widget.event.iconUrl, height: 50, width: 50, fit: BoxFit.cover),
                const SizedBox(width: 16.0),
                Expanded(child: Text(widget.event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 16.0),
            BlocConsumer<CreateOrderBloc, CreateOrderState>(
              listener: (context, state) {
                if (state is OrderPlacedSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully')),
                  );
                } else if (state is OrderPlacedErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return OrderCard(
                  currentYesPrice: widget.event.currentYesPrice.toDouble(),
                  currentNoPrice: widget.event.currentNoPrice.toDouble(),
                  onPlaceOrder: (type, price, quantity) {
                    context.read<CreateOrderBloc>().add(
                          CreateOrderEventStarted(
                            eventId: widget.event.eventId,
                            type: type,
                            quantity: quantity,
                            price: price,
                            authToken: authToken,
                          ),
                        );
                  },
                  child: state is OrderPlacingState ? const SpinKitThreeBounce(color: Colors.white, size: 20) : null,
                );
              },
            ),
            const SizedBox(height: 16.0),
            const Text('Order Book', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            BlocConsumer<OrderBookBloc, OrderBookState>(
              listener: (context, state) {
                if (state is OrderBookError) {
                  _errorCount++;
                } else {
                  _errorCount = 0;
                }
              },
              builder: (context, state) {
                if (state is OrderBookLoaded) {
                  /// Aggregate quantities for the same price in yesOrders
                  final Map<double, int> yesOrdersMap = {};
                  for (final order in state.orderBook.yesOrders) {
                    yesOrdersMap.update(
                      order.price.toDouble(),
                      (existingQuantity) => (existingQuantity + order.quantity).toInt(),
                      ifAbsent: () => order.quantity.toInt(),
                    );
                  }

                  final yesOrders = yesOrdersMap.entries.map((entry) => {entry.key: entry.value}).toList();

                  /// Aggregate quantities for the same price in noOrders
                  final Map<double, int> noOrdersMap = {};
                  for (final order in state.orderBook.noOrders) {
                    noOrdersMap.update(
                      order.price.toDouble(),
                      (existingQuantity) => (existingQuantity + order.quantity).toInt(),
                      ifAbsent: () => order.quantity.toInt(),
                    );
                  }

                  final noOrders = noOrdersMap.entries.map((entry) => {entry.key: entry.value}).toList();

                  return OrderBookWidget(
                    yesOrders: yesOrders,
                    noOrders: noOrders,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
