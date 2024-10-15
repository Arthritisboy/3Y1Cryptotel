import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_cancel_modal.dart';
import 'package:intl/intl.dart';

class HistoryCancelBody extends StatelessWidget {
  final List<BookingModel> canceledBookings;

  const HistoryCancelBody({
    super.key,
    required this.canceledBookings,
  });

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
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: canceledBookings.isNotEmpty
              ? ListView.builder(
                  itemCount: canceledBookings.length,
                  itemBuilder: (context, index) {
                    final booking = canceledBookings[index];

                    // Determine display name
                    String displayName = (booking.restaurantName != null &&
                            booking.restaurantName!.isNotEmpty)
                        ? booking.restaurantName!
                        : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';

                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: const Text(
                                            'Status: Canceled',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          displayName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 18,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Check-in: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_outlined,
                                                size: 18,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Check-out: ${booking.checkOutDate.toLocal().toString().split(' ')[0]}',
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time_filled,
                                                size: 18,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Arrival: ${booking.timeOfArrival != null ? DateFormat.jm().format(booking.timeOfArrival!) : 'N/A'}',
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time_outlined,
                                                size: 18,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Departure: ${booking.timeOfDeparture != null ? DateFormat.jm().format(booking.timeOfDeparture!) : 'N/A'}',
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CancelModal(
                                            booking: booking,
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: const Text('Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icons/booknow.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Cancelled, yet!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Make a booking with CRYPTOTEL & enjoy your stay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/homescreen');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C3473),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
