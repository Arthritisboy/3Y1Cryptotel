import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/day_selector.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/input_fields.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/month_selector.dart';


class ReservationBooking extends StatefulWidget {
  const ReservationBooking({super.key});

  @override
  _ReservationBookingState createState() => _ReservationBookingState();
}

class _ReservationBookingState extends State<ReservationBooking> {
  int activeMonthIndex = DateTime.now().month - 1;
  int activeDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonthSelector(
            activeMonthIndex: activeMonthIndex,
            onMonthTap: (index) {
              setState(() {
                activeMonthIndex = index;
                activeDay = DateTime.now().day;
              });
            },
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
            child: InputFields(),
          ),
        ],
      ),
    );
  }

  int getDaysInMonth(int month) {
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }
}
