import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:intl/intl.dart';

class HistoryRejectedModal extends StatelessWidget {
  final BookingModel booking;

  const HistoryRejectedModal({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Booking Details',
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
            'Check-in: ${DateFormat.yMMMd().format(booking.checkInDate)}',
          ),
          Text(
            'Check-out: ${DateFormat.yMMMd().format(booking.checkOutDate)}',
          ),
          const SizedBox(height: 8.0),
          Text(
            'Arrival Time: ${booking.timeOfArrival != null ? DateFormat.jm().format(booking.timeOfArrival!) : 'N/A'}',
          ),
          Text(
            'Departure Time: ${booking.timeOfDeparture != null ? DateFormat.jm().format(booking.timeOfDeparture!) : 'N/A'}',
          ),
          const SizedBox(height: 8.0),
          Text(
            'Full Name: ${booking.fullName}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Email: ${booking.email}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Phone: ${booking.phoneNumber}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Total Price: ${booking.totalPrice ?? 'N/A'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
