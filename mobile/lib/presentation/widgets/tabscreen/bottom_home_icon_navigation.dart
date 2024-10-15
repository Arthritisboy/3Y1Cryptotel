import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino icons
import '../home/square_icon.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => onIconTapped(0),
            child: SquareIcon(
              iconData: CupertinoIcons.home,
              isSelected: selectedIndex == 0,
            ),
          ),
          GestureDetector(
            onTap: () => onIconTapped(1),
            child: SquareIcon(
              iconData: CupertinoIcons.square_list,
              isSelected: selectedIndex == 1,
            ),
          ),
          GestureDetector(
            onTap: () => onIconTapped(2),
            child: SquareIcon(
              iconData: CupertinoIcons.bed_double,
              isSelected: selectedIndex == 2,
            ),
          ),
          GestureDetector(
            onTap: () => onIconTapped(3),
            child: SquareIcon(
              iconData: CupertinoIcons.car_detailed,
              isSelected: selectedIndex == 3,
            ),
          ),
        ],
      ),
    );
  }
}
