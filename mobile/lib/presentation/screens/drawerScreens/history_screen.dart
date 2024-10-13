import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_cancel.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_header.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_pending.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_accepted.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_rate.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserIdAndBookings(); // Trigger fetch each time dependencies change.
  }

  Future<void> _fetchUserIdAndBookings() async {
    String? userId = await _storage.read(key: 'userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<BookingBloc>().add(FetchBookings(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const HistoryHeader(),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1C3473),
            tabs: [
              Tab(text: 'Cancel'),
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rate'),
            ],
          ),
        ),
        body: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              // If needed, perform actions upon success
            } else if (state is BookingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookingSuccess) {
                final pendingBookings = state.bookings
                    .where((booking) => booking.status == 'pending')
                    .toList();
                final acceptedBookings = state.bookings
                    .where((booking) => booking.status == 'accepted')
                    .toList();
                final cancelBookings = state.bookings
                    .where((booking) => booking.status == 'cancelled')
                    .toList();

                return TabBarView(
                  children: [
                    HistoryCancelBody(canceledBookings: cancelBookings),
                    HistoryPendingBody(
                      pendingBookings: pendingBookings,
                      userId: _userId!,
                    ),
                    HistoryAcceptedBody(acceptedBookings: acceptedBookings),
                    const HistoryRateBody(status: 'Rate'),
                  ],
                );
              } else {
                return const Center(child: Text('No bookings found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
