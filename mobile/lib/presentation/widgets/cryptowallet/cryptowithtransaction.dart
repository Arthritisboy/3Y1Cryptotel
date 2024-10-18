import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/tab_screen.dart';
import 'package:intl/intl.dart';

class CryptoWithTransaction extends StatefulWidget {
  final bool isConnected;
  final String walletAddress;
  final String balance;
  final Future<void> Function(String, String)
      sendTransaction; // Ensure this matches the signature

  const CryptoWithTransaction({
    super.key,
    required this.isConnected,
    required this.walletAddress,
    required this.balance,
    required this.sendTransaction, // Update the constructor
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
    _fetchUserId(); // Call to fetch user ID on init
  }

  Future<void> _fetchUserId() async {
    userId = await _storage.read(key: 'userId');
    if (userId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchBookings(userId: userId!));
    }
  }

  void updateWalletInfo(String walletAddress, String balance, bool isConnected,
      String? userId, String? error) {
    // Your logic here
    print('Updated Wallet Info: $walletAddress, $balance, $isConnected');
  }

  @override
  Widget build(BuildContext context) {
    // Check if the wallet is connected
    // if (!widget.isConnected) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Text(
    //           "No wallet connected or session is invalid.",
    //           style: TextStyle(fontSize: 18, color: Colors.red),
    //         ),
    //         const SizedBox(height: 20),
    //         ElevatedButton(
    //           onPressed: () {
    //             // You can add logic to connect the wallet or navigate to a wallet connection screen
    //           },
    //           child: const Text("Connect Wallet"),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is BookingSuccess) {
          // Filter accepted bookings only
          final acceptedBookings = state.bookings
              .where((booking) => booking.status?.toLowerCase() == 'accepted')
              .toList();

          if (acceptedBookings.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/others/wallet.jpg',
                  width: 200.0,
                  height: 200.0,
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: const Text(
                    "Make a booking with CRYPTOTEL & Enjoy your stay",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
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
          return ListView.builder(
            itemCount: acceptedBookings.length,
            itemBuilder: (context, index) {
              final booking = acceptedBookings[index];

              // Determine display name
              String displayName = (booking.restaurantName != null &&
                      booking.restaurantName!.isNotEmpty)
                  ? booking.restaurantName!
                  : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';

              // Determine display image
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
                        // Row with Image and Booking Details
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C3473),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'Status: accepted',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
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

                        // Check-in and Check-out Times
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  'Check-in: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
                                ),
                                const SizedBox(height: 5),
                                _buildInfoRow(
                                  Icons.calendar_today_outlined,
                                  'Check-out: ${booking.checkOutDate.toLocal().toString().split(' ')[0]}',
                                ),
                                const SizedBox(height: 5),

                                // Arrival and Departure Times (if available)
                                _buildInfoRow(
                                  Icons.access_time_filled,
                                  'Arrival: ${booking.timeOfArrival != null ? DateFormat.jm().format(booking.timeOfArrival!) : 'N/A'}',
                                ),
                                const SizedBox(height: 5),
                                _buildInfoRow(
                                  Icons.access_time_outlined,
                                  'Departure: ${booking.timeOfDeparture != null ? DateFormat.jm().format(booking.timeOfDeparture!) : 'N/A'}',
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () => widget.sendTransaction(
                                  '0xc818CfdA6B36b5569E6e681277b2866956863fAd',
                                  '0.001'), // Call the parent method with default values
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No bookings available.'));
      },
    );
  }

  // Helper Widget for Info Rows with Icon
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
}
