import 'dart:async';

import 'package:asar/core/common/functions/secure_storage_service.dart';
import 'package:asar/core/common/widgets/custom_button.dart';
import 'package:asar/core/routes/app_routes_main.dart';
import 'package:asar/core/theme/app_colors.dart';
import 'package:asar/dependency_injection/dependency_injection_imports.dart';
import 'package:asar/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final ValueNotifier<int> _timer = ValueNotifier<int>(30);
  late final Timer _countdownTimer;
  String otp = "";
  String sessionId = "";
  final SecureStorageService _secureStorageService = serviceLocator<SecureStorageService>();

  @override
  void initState() {
    super.initState();
    sessionId = (context.read<AuthBloc>().state as OtpGeneratedSuccessState).sessionId;
    /// Start the countdown
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer.value > 0) {
        _timer.value--;
      } else {
        _countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Page build');
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is OtpVerifiedState) {
              await _secureStorageService.saveToken(state.token);
              debugPrint('Token saved: ${state.token}');
              context.read<SessionCubit>().checkCurrentSession();
            }
          },
        ),
        BlocListener<SessionCubit, SessionState>(
          listener: (context, state) {
            debugPrint('Current session state: $state');
            if (state is SessionLoggedInState) {
              /// Navigate to Home Page when user is logged in
              Future.delayed(const Duration(seconds: 3), () {
                context.goNamed(AppRouteNames.home);
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => const HomePage()),
                //   (route) => false,
                // );
              });
            } else if (state is SessionErrorState) {
              /// Display error message if login fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        )
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'OTP Verification',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enter the code sent to the number',
                      style: TextStyle(fontSize: 14, color: AppColors.secondaryColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text(
                            'Edit ✎',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Using Pinput for OTP Input
                    Pinput(
                      length: 6,
                      onCompleted: (value) {
                        otp = value;
                      },
                      pinAnimationType: PinAnimationType.scale,
                      defaultPinTheme: PinTheme(
                        width: MediaQuery.of(context).size.width / 8.5,
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      title: 'Verify',
                      onTap: () {
                        if (otp.isNotEmpty && otp.length == 6) {
                          context.read<AuthBloc>().add(VerifyOtpEvent(sessionId: sessionId, phoneNumber: widget.phoneNumber, otp: otp));
                        }
                      },
                      child: state is AuthLoadingState ? const SpinKitThreeBounce(color: Colors.white, size: 20) : null,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Didn\'t receive the code?'),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<int>(
                          valueListenable: _timer,
                          builder: (context, value, child) {
                            return value > 0
                                ? Text(
                                    ' Resend in $value seconds',
                                    style: const TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 16,
                                    ),
                                  )
                                : InkWell(
                              onTap: () {
                                if (_timer.value == 0) {
                                  context.read<AuthBloc>().add(SendOtpEvent(phoneNumber: widget.phoneNumber));
                                  _timer.value = 30;
                                  _countdownTimer.cancel();

                                  Timer.periodic(const Duration(seconds: 1), (timer) {
                                    if (_timer.value > 0) {
                                      _timer.value--;
                                    } else {
                                      timer.cancel();
                                    }
                                  });


                                }
                              },
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
