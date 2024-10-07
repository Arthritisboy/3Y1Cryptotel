import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/dummydata/rating_data.dart';
import 'package:hotel_flutter/data/model/rating_model.dart';
import 'package:hotel_flutter/data/model/room_model.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/details/roomDetails.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/input_fields.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/ratings/hotelRatings.dart';

class ActiveRoom extends StatefulWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;

  const ActiveRoom({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required RoomModel room,
  });

  @override
  State<ActiveRoom> createState() => _ActiveRoomState();
}

class _ActiveRoomState extends State<ActiveRoom> {
  int activeIndex = 1;
  void onNavTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Rating> filteredRatingList = userRatings
        .where((rating) => rating.hotelName == widget.hotelName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotelName),
        backgroundColor: const Color.fromARGB(255, 29, 53, 115),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.hotelName,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5.0),
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
                const Icon(Icons.attach_money,
                    color: Color.fromARGB(255, 142, 142, 147), size: 26),
                const SizedBox(width: 8.0),
                Text(
                  '₱${widget.price} and over',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 142, 142, 147),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Color.fromARGB(255, 142, 142, 147), size: 26),
                const SizedBox(width: 8.0),
                Text(
                  widget.location,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 142, 142, 147),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            NavigationRow(
              activeIndex: activeIndex,  
              onTap: onNavTap,            
              showRoom: false,            
            ),
            const Divider(
                thickness: 2, color: Color.fromARGB(255, 142, 142, 147)),
            if (activeIndex == 1)
              InputFields(),
            if(activeIndex == 2)
              Roomdetails(),
            if (activeIndex == 3)
              UserRatingsWidget(ratings: filteredRatingList),
          ],
        ),
      ),
    );
  }
}
