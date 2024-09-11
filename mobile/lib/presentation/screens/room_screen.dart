import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/background_image.dart'; // Update with the correct path if necessary

class RoomScreen extends StatefulWidget {
  final String backgroundImage;
  final String roomName;
  final double rating; // Add rating as a parameter

  const RoomScreen({
    super.key,
    required this.backgroundImage,
    required this.roomName,
    required this.rating, // Initialize rating
  });

  @override
  State<StatefulWidget> createState() {
    return _RoomScreen();
  }
}

class _RoomScreen extends State<RoomScreen> {
  // Method to generate star rating icons
  List<Widget> _buildStarRating(double rating) {
    const int maxStars = 5;
    List<Widget> stars = [];

    for (int i = 1; i <= maxStars; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
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
            child: BackgroundImage(image: widget.backgroundImage),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.roomName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 8.0),
                          Text('Madrid, Madrid'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Row(
                              children: _buildStarRating(
                                  widget.rating)), // Use the passed rating
                          SizedBox(width: 8.0),
                          Text('${widget.rating} Stars') // Show the rating text
                        ],
                      ),
                    ),
                    // Add more widgets or details as needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
