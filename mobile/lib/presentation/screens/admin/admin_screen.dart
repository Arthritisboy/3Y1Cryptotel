import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_pending.dart';
import 'admin_modal.dart'; // Import BookingDetailsModal
import 'admin_header.dart'; // Import AdminHeader

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage(); // Initialize secure storage
    late String hotelId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    // Retrieve the userId from secure storage


      String userId = (await _secureStorage.read(key: 'hotelId'))!; 
      context.read<BookingBloc>().add(FetchBookings(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const AdminHeader(),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1C3473),
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingSuccess) {
              // Filter pending, accepted, and rejected bookings
              final pendingBookings = state.bookings
                  .where((booking) => booking.status == 'pending')
                  .toList();
              final acceptedBookings = state.bookings
                  .where((booking) => booking.status == 'accepted')
                  .toList();
              final rejectedBookings = state.bookings
                  .where((booking) => booking.status == 'rejected')
                  .toList();

              return TabBarView(
                children: [
                  // Pass the bookings as named parameters
                  _buildBookingsTab(bookings: pendingBookings), // Fixed
                  _buildBookingsTab(bookings: acceptedBookings), // Fixed
                  _buildBookingsTab(bookings: rejectedBookings), // Fixed
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

  // Generic builder for Accepted and Rejected bookings
  Widget _buildBookingsTab({required List<BookingModel> bookings}) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${booking.fullName}',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hotel: ${booking.hotelName}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Room: ${booking.roomName}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Booking Date: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Accept Button
ElevatedButton(
  onPressed: () async {
    // Fetch the userId asynchronously
    String? hotelId = await _secureStorage.read(key: 'hotelId');

    if (hotelId != null) {
      // Create a new BookingModel instance with updated status
      BookingModel updatedBooking = booking.copyWith(status: 'accepted');

      context.read<BookingBloc>().add(UpdateBooking(
        bookingId: booking.id!,
        booking: updatedBooking, // Use the BookingModel instance
      ));
    } else {
      // Handle the case where userId is not found
      print('No hotelId found in secure storage');
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
  ),
  child: const Text('Accept'),
),

                    const SizedBox(width: 8), // Small space between buttons
                    // Reject Button
                    ElevatedButton(
                      onPressed: () {
                        // Trigger Reject action
                        //context.read<BookingBloc>().add(RejectBooking(booking.id!));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
