import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_header.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_pending.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_accepted.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_rate.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    String? userId = await _storage.read(key: 'userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      // Trigger the fetch bookings event when the userId is retrieved
      context.read<BookingBloc>().add(FetchBookings(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rate'),
            ],
          ),
        ),
        body: _userId == null
            ? const Center(child: CircularProgressIndicator()) // Loading state
            : BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingSuccess) {
                    // Filter pending bookings
                    final pendingBookings = state.bookings
                        .where((booking) => booking.status == 'pending')
                        .toList();

                    return TabBarView(
                      children: [
                        HistoryPendingBody(pendingBookings: pendingBookings),
                        const HistoryAcceptedBody(),
                        const HistoryRateBody(status: 'Rate'),
                      ],
                    );
                  } else if (state is BookingFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const Center(child: Text('No bookings found.'));
                  }
                },
              ),
      ),
    );
  }
}
