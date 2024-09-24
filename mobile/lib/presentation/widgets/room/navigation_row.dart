import 'package:flutter/material.dart';

class NavigationRow extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const NavigationRow({
    Key? key,
    required this.activeIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildNavItem('Reservation', 0),
        const SizedBox(width: 20), // Space between items
        _buildNavItem('Room', 1),
        const SizedBox(width: 20), // Space between items
        _buildNavItem('Details', 2),
      ],
    );
  }

  Widget _buildNavItem(String title, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              color: activeIndex == index
                  ? const Color.fromARGB(255, 29, 53, 115)
                  : Colors.black,
              fontWeight:
                  activeIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (activeIndex == index)
            Container(
              height: 2,
              width: title.length * 10.0, // Adjust width based on title length
              color: const Color.fromARGB(255, 29, 53, 115),
            ),
        ],
      ),
    );
  }
}
