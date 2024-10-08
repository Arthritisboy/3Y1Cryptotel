import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
import 'package:hotel_flutter/data/model/hotel/room_model.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/ratings/hotelRatings.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/input_fields.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/details/roomDetails.dart';

class ActiveRoom extends StatefulWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final RoomModel room;

  const ActiveRoom({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.room,
  });

  @override
  State<ActiveRoom> createState() => _ActiveRoomState();
}

class _ActiveRoomState extends State<ActiveRoom> {
  int activeIndex = 1;
  late String currentImage;

  @override
  void initState() {
    super.initState();
    // Initialize currentImage with the room's image URL
    currentImage = widget.room.roomImage; // Use roomImage from RoomModel
  }

  void onNavTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  void changeImage(String newImage) {
    setState(() {
      currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<RatingModel> filteredRatingList =
        widget.room.ratings; // Fetch room ratings

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotelName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {}, // Placeholder for future tap actions
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                          NetworkImage(currentImage), // Use the current image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.room.type, // Room type
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),

              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₱${widget.room.price}', // Room price
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: ' per night',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Display guests capacity with icon
              Row(
                children: [
                  const Icon(Icons.group, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    'Up to ${widget.room.capacity} Guests',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              NavigationRow(
                activeIndex: activeIndex,
                onTap: onNavTap,
                showRoom: false,
              ),
              const Divider(
                thickness: 2,
                color: Color.fromARGB(255, 142, 142, 147),
              ),
              if (activeIndex == 1)
                InputFields(), // Placeholder for input fields section
              if (activeIndex == 2)
                Roomdetails(), // Placeholder for room details section
              if (activeIndex == 3)
                HotelRatingWidget(
                    ratings: filteredRatingList), // Display user ratings
            ],
          ),
        ),
      ),
    );
  }
}
