import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import '../widgets/admin/admin_modal.dart';
import '../widgets/admin/admin_header.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  // Function to fetch bookings using Flutter Secure Storage
  Future<void> _fetchBookings() async {
    try {
      // Get the ID from secure storage (userId, hotelId, or restaurantId)
      final id = await _secureStorage.read(key: 'handleId');
      print(id);

      if (id != null) {
        // Dispatch the FetchBookings event with the retrieved ID
        context.read<BookingBloc>().add(FetchBookings(userId: id));
      }
    } catch (e) {
      print('Error fetching ID from secure storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const AdminHeader(),
            const TabBar(
              tabs: [
                Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
                Tab(text: 'Accepted', icon: Icon(Icons.check_circle)),
                Tab(text: 'Rejected', icon: Icon(Icons.cancel)),
              ],
            ),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state is BookingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookingSuccess) {
                    final bookings = state.bookings;

                    return TabBarView(
                      children: [
                        _buildBookingList(bookings
                            .where((b) => b.status == 'Pending')
                            .toList()),
                        _buildBookingList(bookings
                            .where((b) => b.status == 'Accepted')
                            .toList()),
                        _buildBookingList(bookings
                            .where((b) => b.status == 'Rejected')
                            .toList()),
                      ],
                    );
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
      ),
    );
  }

  // Widget to build a list of bookings
  Widget _buildBookingList(List<BookingModel> bookings) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BookingDetailsModal(bookingRequest: {
                    'userName': booking.fullName,
                    'hotelName': booking.hotelName ?? 'N/A',
                    'roomName': booking.roomName ?? 'N/A',
                    'date':
                        booking.checkInDate.toLocal().toString().split(' ')[0],
                    'checkIn': booking.checkInDate.toLocal().toString(),
                    'checkOut': booking.checkOutDate.toLocal().toString(),
                    'timeIn':
                        booking.timeOfArrival?.toLocal().toString() ?? 'N/A',
                    'timeOut':
                        booking.timeOfDeparture?.toLocal().toString() ?? 'N/A',
                    'email': booking.email,
                    'phoneNumber': booking.phoneNumber,
                    'address': booking.address,
                    'adults': booking.adult.toString(),
                    'children': booking.children.toString(),
                  });
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
                  Text(
                    'Hotel: ${booking.hotelName ?? 'N/A'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Room: ${booking.roomName ?? 'N/A'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Booking Date: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
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
