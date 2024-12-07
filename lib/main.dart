import 'package:asar/core/common/functions/bloc_observer.dart';
import 'package:asar/core/routes/app_routes_main.dart';
import 'package:asar/core/theme/app_theme.dart';
import 'package:asar/dependency_injection/dependency_injection_imports.dart';
import 'package:asar/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:asar/features/events/presentation/manager/create_order_bloc/create_order_bloc.dart';
import 'package:asar/features/events/presentation/manager/get_events_bloc/get_events_bloc.dart';
import 'package:asar/features/events/presentation/manager/order_book_bloc/order_book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Bloc.observer = MyBlocObserver();
  await initDependencies();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<SessionCubit>()..checkCurrentSession(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<GetEventsBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<CreateOrderBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<OrderBookBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: GlobalKey<NavigatorState>(),
      title: 'ASAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
