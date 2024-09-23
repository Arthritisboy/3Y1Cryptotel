import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/room/background_room_image.dart'; // Ensure this file exists
import 'package:hotel_flutter/presentation/widgets/room/room_details.dart'; // Ensure this file exists

class RoomScreen extends StatefulWidget {
  final String backgroundImage;
  final String roomName;
  final double rating;
  final int price;
  final String location;
  final String time;

  const RoomScreen({
    super.key,
    required this.backgroundImage,
    required this.roomName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
  });

  @override
  State<StatefulWidget> createState() {
    return _RoomScreenState();
  }
}

class _RoomScreenState extends State<RoomScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            color: const Color.fromARGB(255, 52, 46, 46),
            onPressed: () {
              // Add favorite functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: BackgroundRoomImage(image: widget.backgroundImage),
            ),
            RoomDetails(
              roomName: widget.roomName,
              rating: widget.rating,
              price: widget.price,
              location: widget.location,
              time: widget.time,
              activeIndex: _activeIndex,
              onNavTap: (index) {
                setState(() {
                  _activeIndex = index;
                });
              },
            ),
            // Other buttons or widgets...
          ],
        ),
      ),
    );
  }
}
