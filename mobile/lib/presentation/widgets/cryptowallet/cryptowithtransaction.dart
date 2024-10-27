import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';
import 'package:intl/intl.dart';

import 'crypto_navigation.dart'; // Import the CryptoNavigation widget

class CryptoWithTransaction extends StatefulWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final Future<void> Function(String, String, BookingModel)
      sendTransaction; // Update function signature
  final List<BookingModel> acceptedBookings;

  const CryptoWithTransaction({
    super.key,
    required this.acceptedBookings,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.sendTransaction,
  });

  @override
  State<CryptoWithTransaction> createState() => _CryptoWithTransactionState();
}

class _CryptoWithTransactionState extends State<CryptoWithTransaction> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    userId = await _storage.read(key: 'userId');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.acceptedBookings.isEmpty) {
      return _buildNoTransactionView();
    }
    return ListView.builder(
      itemCount: widget.acceptedBookings.length,
      itemBuilder: (context, index) {
        final booking = widget.acceptedBookings[index];

        // Determine display name and image
        String displayName = (booking.restaurantName != null &&
                booking.restaurantName!.isNotEmpty)
            ? booking.restaurantName!
            : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';

        String? displayImage = booking.hotelImage?.isNotEmpty == true
            ? booking.hotelImage
            : booking.restaurantImage;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circular Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: displayImage != null
                            ? Image.network(
                                displayImage,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/icons/placeholder.png',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 10),
                      // Booking Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusBadge('Status: ${booking.status}'),
                          const SizedBox(height: 5),
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildBookingDetails(booking),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to display status badge
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C3473),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Helper method to display booking details
  Widget _buildBookingDetails(BookingModel booking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.calendar_today,
              'Check-in: ${_formatDate(booking.checkInDate)}',
            ),
            const SizedBox(height: 5),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Check-out: ${_formatDate(booking.checkOutDate)}',
            ),
            const SizedBox(height: 5),
            _buildInfoRow(
              Icons.access_time_filled,
              'Arrival: ${_formatTime(booking.timeOfArrival)}',
            ),
            const SizedBox(height: 5),
            _buildInfoRow(
              Icons.access_time_outlined,
              'Departure: ${_formatTime(booking.timeOfDeparture)}',
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => widget.sendTransaction(
              '0xc818CfdA6B36b5569E6e681277b2866956863fAd', booking.totalPrice.toString(), booking),
        ),
      ],
    );
  }

  // Helper method to format dates
  String _formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  // Helper method to format times
  String _formatTime(DateTime? time) {
    return time != null ? DateFormat.jm().format(time) : 'N/A';
  }

  // Helper method to display information rows with icons
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
      ],
    );
  }

  // View for when there are no accepted bookings
  Widget _buildNoTransactionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/others/wallet.jpg',
          width: 150.0,
          height: 150.0,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const Text(
          "No transaction, yet!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Make a booking with CRYPTOTEL & Enjoy your stay",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3473),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text("Book Now"),
        ),
      ],
    );
  }
}
