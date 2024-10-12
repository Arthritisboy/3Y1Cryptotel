import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_pendingmodal.dart';

class HistoryPendingBody extends StatelessWidget {
  final List<BookingModel> pendingBookings;

  const HistoryPendingBody({super.key, required this.pendingBookings});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: pendingBookings.length,
            itemBuilder: (context, index) {
              final booking = pendingBookings[index];
              // Determine the display name
              String displayName = (booking.restaurantName != null &&
                      booking.restaurantName!.isNotEmpty)
                  ? booking.restaurantName!
                  : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';
              return Padding(
                padding:
                    const EdgeInsets.only(top: 24.0), // Add space for the label
                child: Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1C3473),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: const Text(
                                            'Status: Pending',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        displayName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Check-in: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Check-out: ${booking.checkOutDate.toLocal().toString().split(' ')[0]}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const PendingModal();
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1C3473),
                                  ),
                                  child: const Text('Options'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
