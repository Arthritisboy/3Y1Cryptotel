import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/presentation/screens/room_screen.dart';
import 'package:hotel_flutter/data/dummydata/room_data.dart';
import 'package:hotel_flutter/data/model/room_model.dart';

class PopularRooms extends StatelessWidget {
  const PopularRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Rated Hotels',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
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
    return roomData.map((Room room) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomScreen(
                  backgroundImage: room.imagePath,
                  roomName: room.roomName,
                  rating: room.rating,
                  price: room.price,
                ),
              ),
            );
          },
          child: CardWidget(
            imagePath: room.imagePath,
            roomName: room.roomName,
            location: room.location,
            rating: room.rating,
          ),
        ),
      );
    }).toList();
  }
}
