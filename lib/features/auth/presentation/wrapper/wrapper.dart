import 'package:asar/core/common/widgets/shimmer_home_page.dart';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:asar/features/auth/presentation/pages/login_page.dart';
import 'package:asar/features/events/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is SessionLoggedInState) {
          FlutterNativeSplash.remove();
          return const HomePage();
        } else if (state is SessionLoggedOutState) {
          FlutterNativeSplash.remove();
          return const LoginPage();
        }  else if (state is SessionErrorState) {
          FlutterNativeSplash.remove();
          return const LoginPage();
        }
        return const ShimmerHomePage();
      },
    );
  }
}
