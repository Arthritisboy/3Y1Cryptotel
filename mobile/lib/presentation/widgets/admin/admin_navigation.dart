import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/admin/createRoom.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_header.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_modal.dart';
import 'package:intl/intl.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
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
      handleId = await _secureStorage.read(key: 'handleId');
      if (handleId != null) {
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
            // Passing the onCreateRoomPressed callback here
            AdminHeader(),
            const TabBar(
              tabs: [
                Tab(text: 'Rooms', icon: Icon(Icons.hotel)),
                Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
                Tab(text: 'Accepted', icon: Icon(Icons.check_circle)),
                Tab(text: 'Rejected', icon: Icon(Icons.cancel)),
              ],
            ),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return TabBarView(
                    children: [
                      // "Rooms" tab: Show "Create Room" button and bookings
                      _buildRoomsTab(context, state),
                      // "Pending" tab
                      _buildBookingList(_filterBookings(state, 'pending')),
                      // "Accepted" tab
                      _buildBookingList(_filterBookings(state, 'accepted')),
                      // "Rejected" tab
                      _buildBookingList(_filterBookings(state, 'rejected')),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the "Rooms" tab
  Widget _buildRoomsTab(BuildContext context, BookingState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the CreateRoomScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateRoom()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF1C3473), // Button background color
            ),
            child: const Text('Create Room'),
          ),
          const SizedBox(height: 20),
          // Check if there are bookings or display a message
          state is BookingSuccess && state.bookings.isNotEmpty
              ? Expanded(child: _buildBookingList(state.bookings))
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No registered hotels or restaurants available. Please create a room.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
        ],
      ),
    );
  }

  // Helper function to filter bookings based on status
  List<BookingModel> _filterBookings(BookingState state, String status) {
    if (state is BookingSuccess) {
      return state.bookings
          .where((b) => b.status?.toLowerCase() == status)
          .toList();
    }
    return [];
  }

  // Widget to build a list of bookings
  Widget _buildBookingList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings available.'));
    }
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
