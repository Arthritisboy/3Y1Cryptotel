import 'package:flutter/material.dart';
import 'image_with_heart.dart'; // Update with the correct path if necessary

class PopularRooms extends StatelessWidget {
  final Map<String, bool> heartStatus;
  final Function(String, bool) onHeartPressed;

  PopularRooms({required this.heartStatus, required this.onHeartPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Rooms',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 200.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildRoomList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoomList() {
    const roomData = [
      {
        'imagePath': 'assets/images/others/hotelroom_1.png',
        'roomName': 'Deluxe Room',
        'typeOfRoom': 'King Size Bed',
      },
      {
        'imagePath': 'assets/images/others/hotelroom_2.png',
        'roomName': 'Suite Room',
        'typeOfRoom': 'Queen Size Bed',
      },
    ];

    return roomData.map((room) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: ImageWithHeart(
          imagePath: room['imagePath']!,
          isHeartFilled: heartStatus[room['imagePath']!] ?? false,
          onHeartPressed: (isFilled) =>
              onHeartPressed(room['imagePath']!, isFilled),
          roomName: room['roomName']!,
          typeOfRoom: room['typeOfRoom']!,
        ),
      );
    }).toList();
  }
}
