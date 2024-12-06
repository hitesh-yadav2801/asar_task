import 'package:asar/core/routes/app_routes_main.dart';
import 'package:asar/core/theme/app_colors.dart';
import 'package:asar/features/auth/presentation/manager/session_cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authToken = (context.read<SessionCubit>().state as SessionLoggedInState).token;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is SessionLoggedOutState) {
                context.goNamed(AppRouteNames.login);
              } else if (state is SessionErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is SessionLoadingState) {
                return const ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text("Logging out..."),
                );
              }

              return ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  context.read<SessionCubit>().logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}