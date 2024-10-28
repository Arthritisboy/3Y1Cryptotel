import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onDetailsPressed;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onDetailsPressed,
  });

  // Get color for status label and button based on the status
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.amber; // Yellow for pending
      case 'accepted':
        return Colors.green; // Green for accepted
      case 'rejected':
        return Colors.redAccent; // Red for rejected
      default:
        return Colors.grey; // Default grey for other statuses
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName =
        (booking.restaurantName != null && booking.restaurantName!.isNotEmpty)
            ? booking.restaurantName!
            : '${booking.hotelName ?? ''} - ${booking.roomName ?? ''}';

    String? displayImage = booking.hotelImage?.isNotEmpty == true
        ? booking.hotelImage
        : booking.restaurantImage;

    // Get the color based on the status
    final statusColor = _getStatusColor(booking.status);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status label with dynamic color
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Status: ${booking.status}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 200, // Ensure text wraps within 200 width
                        child: Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
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
                        'Check-in: ${DateFormat.yMMMd().format(booking.checkInDate)}',
                      ),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        'Check-out: ${DateFormat.yMMMd().format(booking.checkOutDate)}',
                      ),
                    ],
                  ),
                  // Details button with dynamic color
                  ElevatedButton(
                    onPressed: onDetailsPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        const Text('Details', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
