import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/room/facility_icon.dart';
import 'package:hotel_flutter/presentation/widgets/room/background_room_image.dart'; // Update with the correct path if necessary

class RoomScreen extends StatefulWidget {
  final String backgroundImage;
  final String roomName;
  final double rating; // Add rating as a parameter
  final int price; // Add price as a parameter

  const RoomScreen({
    super.key,
    required this.backgroundImage,
    required this.roomName,
    required this.rating, // Initialize rating
    required this.price, // Initialize price
  });

  @override
  State<StatefulWidget> createState() {
    return _RoomScreen();
  }
}

class _RoomScreen extends State<RoomScreen> {
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
        title: Text('Room Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: BackgroundRoomImage(image: widget.backgroundImage),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 26, right: 16, top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.roomName,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: const Color.fromARGB(255, 142, 142, 147),
                            size: 26,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Madrid, Madrid',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 142, 142, 147),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Row(children: _buildStarRating(widget.rating)),
                          const SizedBox(width: 8.0),
                          Text('| ${widget.rating} Stars'),
                          const Spacer(),
                          Text(
                            '\$${widget.price}', // Display price
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Valoraciones',
                              style: TextStyle(
                                fontSize: 25,
                                color: const Color.fromARGB(255, 142, 142, 147),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 142, 142, 147),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'FACILITY',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const FacilityIcon(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Add your onPressed functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 52, 46, 46), // Background color
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              child: const Text(
                                'Choose Room',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 52, 46, 46), // Border color
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_outline),
                              color: const Color.fromARGB(
                                  255, 52, 46, 46), // Icon color
                              onPressed: () {
                                // Add your onPressed functionality here
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
