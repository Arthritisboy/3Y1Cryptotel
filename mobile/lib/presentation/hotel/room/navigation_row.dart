import 'package:flutter/material.dart';

class NavigationRow extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const NavigationRow({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildNavItem('Room', 0),
        const SizedBox(width: 20),
        _buildNavItem('Details', 1),
        const SizedBox(width: 20),
        _buildNavItem('Ratings', 2)
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
