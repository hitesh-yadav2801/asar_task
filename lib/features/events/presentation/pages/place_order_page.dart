import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:asar/features/events/domain/entities/event.dart';
import 'package:asar/features/events/presentation/manager/create_order_bloc/create_order_bloc.dart';
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
  final bool _isLoadingOrderBook = false;

  @override
  void initState() {
    authToken = (context
        .read<SessionCubit>()
        .state as SessionLoggedInState).token;
    super.initState();
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
          ],
        ),
      ),
    );
  }
}
