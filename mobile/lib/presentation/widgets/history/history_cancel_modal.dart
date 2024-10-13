import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

class CancelModal extends StatelessWidget {
  final BookingModel booking;

  const CancelModal({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Canceled Booking Details',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking for: ${booking.hotelName ?? booking.restaurantName ?? 'N/A'}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Room/Location: ${booking.roomName ?? 'N/A'}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Check-in: ${booking.checkInDate.toLocal().toString().split(' ')[0]}',
          ),
          Text(
            'Check-out: ${booking.checkOutDate.toLocal().toString().split(' ')[0]}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
