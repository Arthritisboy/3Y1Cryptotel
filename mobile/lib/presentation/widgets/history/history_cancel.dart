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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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

                // Determine which image to display
                String? displayImage = booking.hotelImage?.isNotEmpty == true
                    ? booking.hotelImage
                    : booking.restaurantImage;

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: displayImage != null
                                    ? Image.network(
                                        displayImage,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/icons/placeholder.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Text(
                                      'Status: Canceled',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width:
                                        200, // Set a maximum width to ensure wrapping
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      softWrap:
                                          true, // Ensures the text wraps to the next line
                                      overflow: TextOverflow
                                          .visible, // Prevents truncation
                                    ),
                                  ),
                                ],
                              ),
                              // Status Badge

                              SizedBox(
                                width: 50,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
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
                                  _buildInfoRow(
                                    Icons.calendar_today_outlined,
                                    'Check-out: ${booking.checkOutDate.toLocal().toString().split(' ')[0]}',
                                  ),
                                  _buildInfoRow(
                                    Icons.access_time_filled,
                                    'Arrival: ${booking.timeOfArrival != null ? DateFormat.jm().format(booking.timeOfArrival!) : 'N/A'}',
                                  ),
                                  _buildInfoRow(
                                    Icons.access_time_outlined,
                                    'Departure: ${booking.timeOfDeparture != null ? DateFormat.jm().format(booking.timeOfDeparture!) : 'N/A'}',
                                  ),
                                ],
                              ),
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
                                  minimumSize: const Size(80, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(fontSize: 14),
                                ),
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
          : _buildEmptyState(context),
    );
  }

  // Helper widget to build information rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Helper widget for empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
