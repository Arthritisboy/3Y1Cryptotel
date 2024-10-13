import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:intl/intl.dart';
import '../widgets/admin/admin_modal.dart';
import '../widgets/admin/admin_header.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? handleId;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  // Function to fetch bookings using Flutter Secure Storage
  Future<void> _fetchBookings() async {
    try {
      // Get the handleId from secure storage
      handleId = await _secureStorage.read(key: 'handleId');
      print(handleId);

      if (handleId != null) {
        // Dispatch the FetchBookings event with the retrieved ID
        context.read<BookingBloc>().add(FetchBookings(userId: handleId!));
      }
    } catch (e) {
      print('Error fetching ID from secure storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            const AdminHeader(),
            const TabBar(
              tabs: [
                Tab(text: 'Jem', icon: Icon(Icons.hotel)),
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
                        _buildBookingList(
                          bookings
                              .where(
                                  (b) => b.status?.toLowerCase() == 'pending')
                              .toList(),
                        ),
                        _buildBookingList(
                          bookings
                              .where(
                                  (b) => b.status?.toLowerCase() == 'accepted')
                              .toList(),
                        ),
                        _buildBookingList(
                          bookings
                              .where(
                                  (b) => b.status?.toLowerCase() == 'rejected')
                              .toList(),
                        ),
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

        // Determine which venue to display (Hotel or Restaurant)
        final venueName = booking.hotelName?.isNotEmpty == true
            ? 'Hotel: ${booking.hotelName ?? ''}'
            : 'Restaurant: ${booking.restaurantName ?? ''}';

        // Determine which detail to display (Room or Table Number)
        final venueDetail = booking.hotelName?.isNotEmpty == true
            ? 'Room: ${booking.roomName ?? 'N/A'}'
            : 'Table Number: ${booking.tableNumber ?? 'N/A'}';

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AdminModal(
                    booking: booking,
                    userId: handleId!,
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3473),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Status: ${booking.status?.capitalize() ?? 'Pending'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: Text(
                    'User: ${booking.fullName}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Venue: $venueName',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    venueDetail,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Check-in: ${DateFormat.yMMMd().format(booking.checkInDate)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Check-out: ${DateFormat.yMMMd().format(booking.checkOutDate)}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Arrival Time: ${booking.timeOfArrival != null ? DateFormat.jm().format(booking.timeOfArrival!) : 'N/A'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: Text(
                    'Departure Time: ${booking.timeOfDeparture != null ? DateFormat.jm().format(booking.timeOfDeparture!) : 'N/A'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
