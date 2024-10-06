import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/room_model.dart';

class ActiveRoom extends StatelessWidget {
  final RoomModel room; // Added room parameter

  const ActiveRoom({super.key, required this.room}); // Constructor with room parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.hotelName), // Room type as the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.roomType, // Display room type
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(room.imageUrl), // Room image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: ₱${room.price}', // Display room price
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Max Guests: ${room.numberofGuest}', // Display max guests
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              room.isAvailable ? 'Status: Available' : 'Status: Not Available', // Display room availability
              style: TextStyle(
                fontSize: 18.0,
                color: room.isAvailable ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for booking or other actions here
              },
              child: const Text('Book Now'), // Button to book the room
            ),
          ],
        ),
      ),
    );
  }
}
