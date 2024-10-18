import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_app/admin_appNav.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_header.dart';

class AdminAppscreen extends StatelessWidget {
  const AdminAppscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        endDrawer: _buildEndDrawer(context),
        body: Column(
          children: [
            AdminHeader(
              name: 'Admin',
            ),
            const Expanded(
              child: AdminAppnav(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1C3473),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/others/cryptotel_removebg.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Admin Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _handleLogout(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    context.read<AuthBloc>().add(LogoutEvent());
  }
}
