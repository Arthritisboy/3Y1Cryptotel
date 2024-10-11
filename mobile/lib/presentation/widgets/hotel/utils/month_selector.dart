/*import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final ValueChanged<int> onMonthTap;
  final int activeMonthIndex;

  const MonthSelector({
    super.key,
    required this.onMonthTap,
    required this.activeMonthIndex,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(months.length, (index) {
          return GestureDetector(
            onTap: () => onMonthTap(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    months[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: activeMonthIndex == index
                          ? const Color.fromARGB(255, 29, 53, 115)
                          : const Color.fromARGB(255, 142, 142, 147),
                      fontWeight: activeMonthIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (activeMonthIndex == index)
                    Container(
                      height: 2,
                      width: 24,
                      color: const Color.fromARGB(255, 29, 53, 115),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}*/
