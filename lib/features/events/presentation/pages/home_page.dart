import 'package:asar/core/common/widgets/shimmer_home_page.dart';
import 'package:asar/core/routes/app_routes_main.dart';
import 'package:asar/features/events/presentation/manager/get_events_bloc/get_events_bloc.dart';
import 'package:asar/features/events/presentation/pages/place_order_page.dart';
import 'package:asar/features/events/presentation/widgets/event_card.dart';
import 'package:asar/features/events/presentation/widgets/home_page_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<GetEventsBloc>().add(FetchEventsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASAR Gaming'),
        foregroundColor: Colors.white,
      ),
      drawer: const HomePageDrawer(),
      body: BlocConsumer<GetEventsBloc, GetEventsState>(
        listener: (context, state) {
          if (state is GetEventsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GetEventsLoadingState) {
            return const ShimmerHomePage();
          } else if (state is GetEventsLoadedState) {
            final events = state.events;

            return Scaffold(
              body: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  // Assuming EventModel has the necessary properties
                  return EventCard(
                    onTapCard: () {
                      debugPrint('Event tapped: ${events[index].eventId}');
                      context.pushNamed(AppRouteNames.placeOrder, extra: events[index]);
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceOrderPage(event: events[index])));
                    },
                    title: events[index].title,
                    description: events[index].oneLinerTitle,
                    yesAmount: events[index].currentYesPrice.toDouble(),
                    noAmount: events[index].currentNoPrice.toDouble(),
                    iconUrl: events[index].iconUrl,
                    eventId: events[index].eventId,
                    onTapYes: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Yes button tapped: ${events[index].title}')),
                      );
                    },
                    onTapNo: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No button tapped: ${events[index].title}')),
                      );
                    },
                  );
                },
              ),
            );
          } else {
            // Optionally handle empty state or other states here
            return const Center(child: Text('No events available.'));
          }
        },
      ),
    );
  }
}
