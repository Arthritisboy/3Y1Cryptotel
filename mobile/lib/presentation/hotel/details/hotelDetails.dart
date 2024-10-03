import 'package:flutter/material.dart';

class HotelDetails extends StatelessWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final String time;

  const HotelDetails({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on,
                color: Color.fromARGB(255, 142, 142, 147), size: 26),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Location: $location',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.money,
                color: Color.fromARGB(255, 142, 142, 147), size: 26),
            const SizedBox(width: 8.0),
            Text(
              'Price: ₱$price and over',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.access_time,
                color: Color.fromARGB(255, 142, 142, 147), size: 26),
            const SizedBox(width: 8.0),
            Text(
              'Open Hours: $time',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
