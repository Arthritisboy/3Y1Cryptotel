import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_modal.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_header.dart';
import 'package:intl/intl.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() {
    context.read<BookingBloc>().add(FetchBookings(userId: 'adminUserId'));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          const AdminHeader(),
          Expanded(
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingSuccess) {
                  final bookings = state.bookings;
                  return _buildBookingList(bookings);
                } else if (state is BookingFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(child: Text('No bookings available.'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Accepted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Rejected',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBookingList(List<BookingModel> bookings) {
    // Filter bookings based on the selected tab.
    final filteredBookings = bookings.where((booking) {
      switch (_selectedIndex) {
        case 0:
          return booking.status == 'pending';
        case 1:
          return booking.status == 'accepted';
        case 2:
          return booking.status == 'rejected';
        default:
          return false;
      }
    }).toList();

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AdminModal(
                    booking: booking,
                    userId: 'adminUserId',
                  );
                },
              );
            },
            child: ListTile(
              title: Text(
                'User: ${booking.fullName}',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hotel: ${booking.hotelName ?? 'N/A'}',
                      style: const TextStyle(color: Colors.black)),
                  Text('Room: ${booking.roomName ?? 'N/A'}',
                      style: const TextStyle(color: Colors.black)),
                  Text(
                    'Booking Date: ${DateFormat('MMMM d, y').format(booking.checkInDate)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
