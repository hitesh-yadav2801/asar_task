import 'package:asar/features/events/data/data_sources/event_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASAR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final eventDataSource = EventDataSourceImpl();
            await eventDataSource.getAllEvents();
            print('Success');
          },
          child: const Text('Get Events'),
        ),
      )),
    );
  }
}
