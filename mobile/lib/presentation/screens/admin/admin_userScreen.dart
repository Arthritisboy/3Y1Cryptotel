import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/widgets/admin/admin_user/createRoom.dart';
import '../../widgets/admin/admin_header.dart';
import '../../widgets/admin/admin_modal.dart';
import 'package:intl/intl.dart';

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
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      handleId = await _secureStorage.read(key: 'handleId');
      if (handleId != null) {
        context.read<BookingBloc>().add(FetchBookings(userId: handleId!));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            AdminHeader(
              name: 'Manager',
            ),
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
      ),
    );
  }

  Widget _buildRoomsTab(BuildContext contextRoom) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingSuccess && state.bookings.isNotEmpty) {
          return Stack(
            children: [
              Positioned(
                top: 16,
                left: 16,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateRoom()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3473),
                  ),
                  child: const Text('Create Room'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: _buildBookingList(state.bookings),
              ),
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No rooms available.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateRoom()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3473),
                  ),
                  child: const Text('Create Room'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildFilteredBookingList(BuildContext context, String status) {
    return BlocSelector<BookingBloc, BookingState, List<BookingModel>>(
      selector: (state) {
        if (state is BookingSuccess) {
          return state.bookings
              .where((booking) => booking.status?.toLowerCase() == status)
              .toList();
        }
        return [];
      },
      builder: (context, bookings) {
        return _buildBookingList(bookings);
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
        final venueName = booking.hotelName?.isNotEmpty == true
            ? 'Hotel: ${booking.hotelName}'
            : 'Restaurant: ${booking.restaurantName ?? ''}';
        final venueDetail = booking.hotelName?.isNotEmpty == true
            ? 'Room: ${booking.roomName ?? 'N/A'}'
            : 'Table Number: ${booking.tableNumber ?? 'N/A'}';

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AdminModal(booking: booking, userId: handleId!),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Status: ${booking.status}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text('User: ${booking.fullName}'),
                Text('Venue: $venueName'),
                Text(venueDetail),
                Text(
                    'Check-in: ${DateFormat.yMMMd().format(booking.checkInDate)}'),
                Text(
                    'Check-out: ${DateFormat.yMMMd().format(booking.checkOutDate)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
