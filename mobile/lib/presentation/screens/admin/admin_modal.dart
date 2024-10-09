import 'package:flutter/material.dart';

class BookingDetailsModal extends StatelessWidget {
  final Map<String, String> bookingRequest;

  const BookingDetailsModal({Key? key, required this.bookingRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking by: ${bookingRequest["userName"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Hotel: ${bookingRequest["hotelName"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Room: ${bookingRequest["roomName"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${bookingRequest["date"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Text(
              'Check-in/out:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Check-in: ${bookingRequest["checkIn"]} / Check-out: ${bookingRequest["checkOut"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Time in/out:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Time-in: ${bookingRequest["timeIn"]} / Time-out: ${bookingRequest["timeOut"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Full Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${bookingRequest["fullName"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Email Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${bookingRequest["email"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phone Number:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${bookingRequest["phoneNumber"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${bookingRequest["address"]}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Text(
              'Guests:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Adults: ${bookingRequest["adults"]}, Children: ${bookingRequest["children"]}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Accepted booking by ${bookingRequest["userName"]}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
              ),
              child: const Text('Accept'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Rejected booking by ${bookingRequest["userName"]}')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reject'),
            ),
          ],
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}
