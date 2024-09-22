import 'package:flutter/material.dart';
import 'square_icon.dart';

class BottomHomeIconNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIconTapped;

  const BottomHomeIconNavigation({
    super.key,
    required this.selectedIndex,
    required this.onIconTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () => onIconTapped(0),
          child: SquareIcon(
            iconData: Icons.home,
            isSelected: selectedIndex == 0,
          ),
        ),
        GestureDetector(
          onTap: () => onIconTapped(1),
          child: SquareIcon(
            iconData: Icons.restaurant,
            isSelected: selectedIndex == 1,
          ),
        ),
        GestureDetector(
          onTap: () => onIconTapped(2),
          child: SquareIcon(
            iconData: Icons.hotel,
            isSelected: selectedIndex == 2,
          ),
        ),
        GestureDetector(
          onTap: () => onIconTapped(3),
          child: SquareIcon(
            iconData: Icons.emoji_transportation,
            isSelected: selectedIndex == 3,
          ),
        ),
      ],
    );
  }
}
