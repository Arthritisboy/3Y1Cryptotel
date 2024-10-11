/*import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final int daysInMonth;
  final int activeDay;
  final ValueChanged<int> onDayTap;

  const DaySelector({
    super.key,
    required this.daysInMonth,
    required this.activeDay,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(daysInMonth, (index) {
          return GestureDetector(
            onTap: () {
              onDayTap(index + 1);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: activeDay == index + 1
                    ? const Color.fromARGB(255, 29, 53, 115)
                    : const Color.fromARGB(255, 217, 217, 217),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 217, 217, 217),
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
                      : const Color.fromARGB(255, 127, 125, 125),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}*/
