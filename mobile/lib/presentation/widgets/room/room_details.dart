import 'package:flutter/material.dart';
import 'navigation_row.dart';
import 'month_selector.dart'; // Import the MonthSelector
import 'day_selector.dart'; // Import the DaySelector

class RoomDetails extends StatefulWidget {
  final String roomName;
  final double rating;
  final int price;
  final String location;
  final String time;

  const RoomDetails({
    Key? key,
    required this.roomName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required int activeIndex,
    required Null Function(dynamic index) onNavTap,
  }) : super(key: key);

  @override
  _RoomDetailsState createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  int activeIndex = 0;
  int activeMonthIndex = DateTime.now().month - 1; // Current month index
  int activeDay = DateTime.now().day; // Current day

  // Helper function to get the number of days in a month
  int getDaysInMonth(int month) {
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Name and Rating
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
              // Price
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
              // Open Hours
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
              // Location
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
              const SizedBox(height: 20),
              NavigationRow(
                activeIndex: activeIndex,
                onTap: (index) {
                  setState(() {
                    activeIndex = index;
                    // Reset the day selection when switching tabs
                    if (activeIndex != 0) {
                      activeDay = DateTime.now().day; // Reset to current day
                    }
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
          color: Color.fromARGB(255, 142, 142, 147),
        ),
        if (activeIndex == 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MonthSelector(
              activeMonthIndex: activeMonthIndex,
              onMonthTap: (index) {
                setState(() {
                  activeMonthIndex = index;
                  activeDay = 1; // Reset to the first day of the month
                });
              },
            ),
          ),
          const SizedBox(height: 10), // Adjust height as needed
          DaySelector(
            daysInMonth: getDaysInMonth(activeMonthIndex),
            activeDay: activeDay,
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}
