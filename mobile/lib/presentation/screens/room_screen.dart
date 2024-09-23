import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/room/background_room_image.dart';

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
  List<Widget> _buildStarRating(double rating) {
    const int maxStars = 5;
    List<Widget> stars = [];

    for (int i = 1; i <= maxStars; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: const Color.fromARGB(255, 229, 160, 0),
          size: 20.0,
        ),
      );
    }

    return stars;
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.roomName,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          color: const Color.fromARGB(255, 29, 53, 115),
                          child: Row(
                            children: [
                              Text(
                                widget.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              const Icon(Icons.star, color: Colors.amber),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Color.fromARGB(255, 142, 142, 147),
                        size: 26,
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          '₱${widget.price} and over',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 142, 142, 147),
                          ),
                          overflow: TextOverflow
                              .ellipsis, // This will add an ellipsis if it overflows
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color.fromARGB(255, 142, 142, 147),
                        size: 26,
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          "Open Hours: ${widget.time}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 142, 142, 147),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color.fromARGB(255, 142, 142, 147),
                        size: 26,
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          widget.location,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 142, 142, 147),
                            fontSize: 15,
                          ),
                          overflow: TextOverflow
                              .visible, // This ensures the text wraps
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your onPressed functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 52, 46, 46),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                          ),
                          child: const Text(
                            'Choose Room',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 52, 46, 46),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.favorite_outline),
                          color: const Color.fromARGB(255, 52, 46, 46),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
