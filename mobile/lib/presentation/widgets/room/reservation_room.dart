import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/room/navigation_row.dart';
import 'package:hotel_flutter/presentation/widgets/room/reservation_booking.dart';

class ReservationRoom extends StatefulWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final String time;
  final int activeIndex;
  final Function(int) onNavTap;

  const ReservationRoom({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.activeIndex,
    required this.onNavTap,
  });

  @override
  State<ReservationRoom> createState() => _ReservationRoomState();
}

class _ReservationRoomState extends State<ReservationRoom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 5.0),
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
              const Icon(
                Icons.access_time,
                color: Color.fromARGB(255, 142, 142, 147),
                size: 26,
              ),
              const SizedBox(width: 8.0),
              Text(
                "Open Hours: ${widget.time}",
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
              const Icon(
                Icons.location_on_outlined,
                color: Color.fromARGB(255, 142, 142, 147),
                size: 26,
              ),
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
          // NavigationRow widget
          NavigationRow(
            activeIndex: widget.activeIndex,
            onTap: widget.onNavTap,
          ),
          const Divider(
              thickness: 2, color: Color.fromARGB(255, 142, 142, 147)),
          // Conditionally rendering the ReservationRoom content
          if (widget.activeIndex == 0) const ReservationBooking(),
        ],
      ),
    );
  }
}
