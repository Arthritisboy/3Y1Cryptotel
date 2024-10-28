import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_user/createRoom.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/admin_modal.dart';
import 'package:intl/intl.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_user/booking_card_widget.dart';
import 'dart:async';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? handleId;

  @override
  void initState() {
    super.initState();
    _fetchBookings(); // Initial fetch on load
  }

  Future<void> _fetchBookings() async {
    if (!mounted) return;

    try {
      handleId = await _secureStorage.read(key: 'handleId');
      if (handleId != null) {
        print('Fetching bookings for userId: $handleId');
        context.read<BookingBloc>().add(FetchBookings(userId: handleId!));
      } else {
        print('handleId is null');
      }
    } catch (e) {
      print('Error fetching handleId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener for BookingBloc
        BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              print('Successfully fetched bookings: ${state.bookings}');
            } else if (state is BookingFailure) {
              print('Error fetching bookings: ${state.error}');
            }
          },
        ),
        // Listener for AuthBloc to handle logout
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed('/login');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Logged out successfully!',
                    style: TextStyle(
                        color: Colors.white), // Ensures text is readable
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor:
                      Colors.green, // Set the background color to green
                ),
              );
            }
          },
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          endDrawer: _buildEndDrawer(context),
          body: Stack(
            children: [
              Column(
                children: [
                  AdminHeader(name: 'Manager'),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Rooms', icon: Icon(Icons.hotel)),
                      Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
                      Tab(text: 'Accepted', icon: Icon(Icons.check_circle)),
                      Tab(text: 'Rejected', icon: Icon(Icons.cancel)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRoomsTab(context),
                        _buildFilteredBookingList(context, 'pending'),
                        _buildFilteredBookingList(context, 'accepted'),
                        _buildFilteredBookingList(context, 'rejected'),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 250,
                right: 16,
                child: BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    return FloatingActionButton(
                      onPressed: _fetchBookings,
                      backgroundColor: const Color(0xFF1C3473),
                      child: state is BookingLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 82, 27, 27),
                              ),
                            )
                          : const Icon(Icons.refresh, color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsTab(BuildContext contextRoom) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            contextRoom,
            MaterialPageRoute(
              builder: (context) => const CreateRoom(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C3473),
        ),
        child: const Text('Create Room'),
      ),
    );
  }

  Widget _buildFilteredBookingList(BuildContext context, String status) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingSuccess) {
          final bookings = state.bookings
              .where((booking) => booking.status?.toLowerCase() == status)
              .toList();
          return _buildBookingList(bookings);
        } else if (state is BookingFailure) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const Center(child: Text('Unexpected state.'));
      },
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings available.'));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return BookingCard(
          booking: booking,
          onDetailsPressed: () {
            showDialog(
              context: context,
              builder: (_) => AdminModal(booking: booking, userId: handleId!),
            );
          },
        );
      },
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
