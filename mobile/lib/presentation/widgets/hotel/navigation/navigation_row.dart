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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5), // Divider line
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the start
        children: [
          if (showRoom) _buildNavItemWithPadding('Room', 0),
          if (showBook) _buildNavItemWithPadding('Book', 1),
          _buildNavItemWithPadding('Details', 2),
          _buildNavItemWithPadding('Ratings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItemWithPadding(String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding
      child: _buildNavItem(title, index),
    );
  }

  Widget _buildNavItem(String title, int index) {
    final bool isActive = activeIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 4.0), // Space between text and indicator
          Container(
            height: 2.0,
            width: isActive ? title.length * 8.0 : 0.0, // Dynamic width
            color: isActive ? const Color(0xFF1C3473) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
