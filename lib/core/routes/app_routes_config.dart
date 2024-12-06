part of 'app_routes_main.dart';

class AppRouter {
  AppRouter._();
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    //debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Wrapper(),
        name: AppRouteNames.login,
      ),
      /// OTP Verification Route
      GoRoute(
        path: '/otp_verification',
        builder: (context, state) =>  OtpVerificationPage(phoneNumber: state.extra as String),
        name: AppRouteNames.otpVerification,
      ),
      /// Home Route
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
        name: AppRouteNames.home,
      ),
      /// Place Order Route
      GoRoute(
        path: '/place_order',
        builder: (context, state) => PlaceOrderPage(event: state.extra as Event),
        name: AppRouteNames.placeOrder,
      ),
      /// Shimmer Route
      GoRoute(
        path: '/shimmer',
        builder: (context, state) => const ShimmerHomePage(),
        name: AppRouteNames.shimmer,
      ),
      /// Error Route
      GoRoute(
        path: '/error',
        name: AppRouteNames.error,
        builder: (context, state) {
          final message = state.extra as String;
          return ErrorPage(error: message);
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error.toString()),
    ),
  );
}
