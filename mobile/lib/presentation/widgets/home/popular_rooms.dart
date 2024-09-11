import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/image_with_heart.dart'; // Update with the correct path if necessary
import 'package:hotel_flutter/presentation/screens/room_screen.dart'; // Update with the correct path
import 'package:hotel_flutter/data/dummydata/room_data.dart';

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
                children: _buildRoomList(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoomList(BuildContext context) {
    return roomData.map((room) {
      final imagePath = room['imagePath'] as String;
      final roomName = room['roomName'] as String;
      final typeOfRoom = room['typeOfRoom'] as String;
      final star = room['star'] as double;
      final price = room['price'] as int; // Assuming price is an integer

      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomScreen(
                  backgroundImage: imagePath,
                  roomName: roomName,
                  rating: star, // Pass the rating to RoomScreen
                  price: price, // Pass the price to RoomScreen
                ),
              ),
            );
          },
          child: ImageWithHeart(
            imagePath: imagePath,
            isHeartFilled: heartStatus[imagePath] ?? false,
            onHeartPressed: (isFilled) => onHeartPressed(imagePath, isFilled),
            roomName: roomName,
            typeOfRoom: typeOfRoom,
          ),
        ),
      );
    }).toList();
  }
}
