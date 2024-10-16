import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
import 'package:hotel_flutter/data/model/hotel/room_model.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/ratings/hotel_rating_widget.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/navigation/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/utils/hotel_input_fields/hotel_input_fields.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/details/roomDetails.dart';

class ActiveRoom extends StatefulWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final RoomModel room;
  final String hotelId;
  final String roomId;

  const ActiveRoom({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.room,
    required this.hotelId,
    required this.roomId,
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
        title: Text(widget.room.type),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {}, // Placeholder for future tap actions
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(currentImage), // Use the current image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            NavigationRow(
              activeIndex: activeIndex,
              onTap: onNavTap,
              showRoom: false,
            ),
            Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Column(
                  children: [
                    if (activeIndex == 1)
                      HotelInputFields(
                        capacity: widget.room.capacity,
                        hotelId: widget.hotelId,
                        roomId: widget.roomId,
                      ),
                    if (activeIndex == 2) Roomdetails(),
                    if (activeIndex == 3)
                      HotelRatingWidget(ratings: filteredRatingList),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
