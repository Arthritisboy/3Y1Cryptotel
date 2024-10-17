import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino icons
import '../home/square_icon.dart';

class BottomTabIconNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIconTapped;

  const BottomTabIconNavigation({
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => onIconTapped(0),
                child: _buildIconWithText(
                  icon: CupertinoIcons.home,
                  isSelected: selectedIndex == 0,
                ),
              ),
              GestureDetector(
                onTap: () => onIconTapped(1),
                child: _buildIconWithText(
                  icon: Icons.restaurant,
                  isSelected: selectedIndex == 1,
                ),
              ),
              GestureDetector(
                onTap: () => onIconTapped(2),
                child: _buildIconWithText(
                  icon: CupertinoIcons.bed_double,
                  isSelected: selectedIndex == 2,
                ),
              ),
              GestureDetector(
                onTap: () => onIconTapped(3),
                child: _buildIconWithText(
                  icon: CupertinoIcons.map,
                  isSelected: selectedIndex == 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build the icon with optional text
  Widget _buildIconWithText({
    required IconData icon,
    required bool isSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SquareIcon(
          iconData: icon,
          isSelected: isSelected,
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
          ),
      ],
    );
  }

}
