import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/room_model.dart';

class RoomSelection extends StatelessWidget {
  final List<RoomModel> roomList;

  const RoomSelection({Key? key, required this.roomList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Rooms',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: roomList.length,
          itemBuilder: (context, index) {
            final room = roomList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Image.asset(room.imageUrl, fit: BoxFit.cover, width: 100),
                title: Text(
                  room.roomType,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color to black
                    fontFamily: 'Hammersmith', // Set font to Hammersmith
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      '₱${room.price}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black, // Set text color to black
                        fontFamily: 'Hammersmith', // Set font to Hammersmith
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      room.availability,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: room.availability == 'Available'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Handle room selection logic here
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
