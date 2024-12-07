import 'package:asar/core/common/widgets/custom_button.dart';
import 'package:asar/core/routes/app_routes_main.dart';
import 'package:asar/features/auth/presentation/manager/auth_bloc/auth_bloc.dart';
import 'package:asar/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:asar/features/auth/presentation/widgets/custom_auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your phone number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomAuthField(
                  label: 'Phone Number',
                  hint: 'e.g. 1234567890',
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please enter a valid phone number!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                        ),
                      );
                    } else if (state is OtpGeneratedSuccessState) {
                      context.pushNamed(AppRouteNames.otpVerification, extra: _phoneController.text.trim());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OtpVerificationPage(phoneNumber: _phoneController.text.trim()),
                      //   ),
                      // );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      title: 'Get OTP',
                      onTap: () {
                        if(state is AuthLoadingState) return;
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SendOtpEvent(phoneNumber: _phoneController.text.trim()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid phone number!'),
                            ),
                          );
                        }
                      },
                      child: state is AuthLoadingState ? const SpinKitThreeBounce(color: Colors.white, size: 20) : null,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
