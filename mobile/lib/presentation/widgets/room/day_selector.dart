import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final int daysInMonth;
  final int activeDay;

  const DaySelector({
    Key? key,
    required this.daysInMonth,
    required this.activeDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(daysInMonth, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: activeDay == index + 1
                  ? const Color.fromARGB(255, 29, 53, 115)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color.fromARGB(255, 142, 142, 147),
                width: 1,
              ),
            ),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: activeDay == index + 1
                    ? Colors.white
                    : const Color.fromARGB(255, 29, 53, 115),
              ),
            ),
          );
        }),
      ),
    );
  }
}
