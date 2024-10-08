import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/hotel/room_model.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/room/activeRoom.dart';

class RoomSelection extends StatelessWidget {
  final List<RoomModel> roomList;

  const RoomSelection({super.key, required this.roomList});

  @override
  Widget build(BuildContext context) {
    final availableRooms = roomList.where((room) => room.availability).toList();

    return Container(
      color: const Color(0xFFF8F8F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Available Rooms',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (availableRooms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No rooms available',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.red,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableRooms.length,
              itemBuilder: (context, index) {
                final room = availableRooms[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActiveRoom(
                          hotelName: 'Sample Hotel',
                          rating: room.ratings.isNotEmpty
                              ? room.ratings
                                      .map((e) => e.rating)
                                      .reduce((a, b) => a + b) /
                                  room.ratings.length
                              : 0.0,
                          price: room.price,
                          location: 'Sample Location',
                          room: room,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color.fromARGB(
                        255, 238, 237, 237), // Keep neutral background
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // No border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(room.roomImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.type,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Hammersmith',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '₱${room.price}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'Hammersmith',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Up to: ${room.capacity} Guests',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'Hammersmith',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  room.availability
                                      ? 'Available'
                                      : 'Not Available',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: room.availability
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
