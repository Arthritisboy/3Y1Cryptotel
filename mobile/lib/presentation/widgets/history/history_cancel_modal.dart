import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';
import 'package:intl/intl.dart';

class CancelModal extends StatelessWidget {
  final BookingModel booking;

  const CancelModal({super.key, required this.booking});

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Canceled Booking Details',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Booking For:',
                booking.hotelName ?? booking.restaurantName ?? 'N/A'),
            _buildInfoRow('Room/Location:', booking.roomName ?? 'N/A'),
            _buildInfoRow(
                'Check-in Date:', _formatDateTime(booking.checkInDate)),
            _buildInfoRow(
                'Check-out Date:', _formatDateTime(booking.checkOutDate)),
            _buildInfoRow(
                'Arrival Time:', _formatDateTime(booking.timeOfArrival)),
            _buildInfoRow(
                'Departure Time:', _formatDateTime(booking.timeOfDeparture)),
            _buildInfoRow('Customer Name:', booking.fullName),
            _buildInfoRow('Contact Number:', booking.phoneNumber),
            _buildInfoRow('Email:', booking.email),
            _buildInfoRow('Address:', booking.address),
            _buildInfoRow('Adults:', '${booking.adult}'),
            _buildInfoRow('Children:', '${booking.children}'),
            if (booking.tableNumber != null)
              _buildInfoRow('Table Number:', '${booking.tableNumber}'),
            _buildInfoRow('Status:', booking.status ?? 'N/A'),
            _buildInfoRow(
              'Total Price:',
              booking.totalPrice != null
                  ? '\$${booking.totalPrice!.toStringAsFixed(2)}'
                  : 'N/A',
            ),
          ],
        ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
