import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:hotel_flutter/presentation/widgets/history/history_modal.dart';
import 'package:intl/intl.dart';

class HistoryRateBody extends StatelessWidget {
  final List<BookingModel> completedBookings;

  const HistoryRateBody({
    super.key,
    required this.completedBookings,
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
      child: completedBookings.isNotEmpty
          ? ListView.builder(
              itemCount: completedBookings.length,
              itemBuilder: (context, index) {
                final booking = completedBookings[index];

                String displayName = (booking.restaurantName != null &&
                        booking.restaurantName!.isNotEmpty)
                    ? booking.restaurantName!
                    : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';

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
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 29, 53, 115),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: const Text(
                                        'Status: Completed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
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
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
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
                                      return HistoryModal(
                                        bookingId: booking.roomId ??
                                            booking.restaurantId ??
                                            'Unknown',
                                        checkInDate:
                                            'Check-in: ${DateFormat.yMMMd().format(booking.checkInDate)}',
                                        checkoutDate:
                                            'Check-out: ${DateFormat.yMMMd().format(booking.checkOutDate)}',
                                        hotelOrResto: booking.hotelName ??
                                            booking.restaurantName ??
                                            '',
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 29, 53, 115),
                                  minimumSize: const Size(80, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Rate',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icons/completed.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Completed Bookings!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Book again and enjoy your stay!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/homescreen');
            },
            icon: const Icon(Icons.hotel),
            label: const Text('Book Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C3473),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
