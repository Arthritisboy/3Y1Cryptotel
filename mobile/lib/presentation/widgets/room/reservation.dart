import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/room/input_fields.dart';
import 'navigation_row.dart';
import 'month_selector.dart';
import 'day_selector.dart';

class Reservation extends StatefulWidget {
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final String time;

  const Reservation({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required int activeIndex,
    required Null Function(dynamic index) onNavTap,
  });

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  int activeIndex = 0;
  int activeMonthIndex = DateTime.now().month - 1;
  int activeDay = DateTime.now().day;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController paxController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();

  int getDaysInMonth(int month) {
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: MonthSelector(
                activeMonthIndex: activeMonthIndex,
                onMonthTap: (index) {
                  setState(() {
                    activeMonthIndex = index;
                    activeDay = DateTime.now().day;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            DaySelector(
              daysInMonth: getDaysInMonth(activeMonthIndex),
              activeDay: activeDay,
              onDayTap: (day) {
                setState(() {
                  activeDay = day;
                });
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns children to the start
                children: [
                  const Text(
                    "Enter Details",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFields(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}
