import 'package:flutter/material.dart';

class NavigationRow extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final bool showRoom;
  final bool showBook;

  const NavigationRow({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.showRoom = true,
    this.showBook = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (showRoom) ...[
          _buildNavItem('Room', 0),
          const SizedBox(width: 20),
        ],
        if (showBook) ...[
          _buildNavItem('Book', 1),
          const SizedBox(width: 20),
        ],
        _buildNavItem('Details', 2),
        const SizedBox(width: 20),
        _buildNavItem('Ratings', 3),
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
              width: title.length * 10.0,
              color: const Color.fromARGB(255, 29, 53, 115),
            ),
        ],
      ),
    );
  }
}
