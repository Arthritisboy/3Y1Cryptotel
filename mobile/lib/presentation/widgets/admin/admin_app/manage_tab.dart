import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class ManagerTab extends StatefulWidget {
  const ManagerTab({super.key});

  @override
  State<ManagerTab> createState() => _ManagerTabState();
}

class _ManagerTabState extends State<ManagerTab> {
  @override
  void initState() {
    super.initState();
    // Use the correct event to fetch only managers
    BlocProvider.of<AuthBloc>(context).add(FetchAllManagersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersFetched) {
              print('Fetched Managers: ${state.users}'); // Debug print

              if (state.users.isEmpty) {
                return const Center(child: Text('No managers found.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final manager = state.users[index];
                  return _buildManagerCard(manager);
                },
              );
            } else {
              return const Center(child: Text('Unexpected state.'));
            }
          },
        ),
      ),
    );
  }

  // Manager Card UI
  Widget _buildManagerCard(UserModel manager) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueGrey[100],
          backgroundImage: manager.profilePicture != null
              ? NetworkImage(manager.profilePicture!)
              : null,
          child: manager.profilePicture == null
              ? Text(
                  manager.firstName?[0] ?? '?',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
        title: Text(
          '${manager.firstName ?? "N/A"} ${manager.lastName ?? ""}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              manager.email ?? 'No email provided',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              'Phone: ${manager.phoneNumber ?? "N/A"}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        onTap: () {
          _showManagerDialog(context, manager);
        },
      ),
    );
  }

  // Manager Dialog
  void _showManagerDialog(BuildContext context, UserModel manager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
              'Manager: ${manager.firstName ?? "N/A"} ${manager.lastName ?? ""}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${manager.email ?? "N/A"}'),
              const SizedBox(height: 10),
              Text('Phone: ${manager.phoneNumber ?? "N/A"}'),
              const SizedBox(height: 10),
              Text('Gender: ${manager.gender ?? "N/A"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Revoked ${manager.firstName}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Revoke'),
            ),
          ],
        );
      },
    );
  }
}
