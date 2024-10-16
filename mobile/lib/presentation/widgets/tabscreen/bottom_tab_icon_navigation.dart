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
                  icon: CupertinoIcons.square_list,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 25),
                child: Text(
                  _getHeaderText(selectedIndex),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          )
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

  // Helper method to get the header text based on the selected index
  String _getHeaderText(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'Top Rated Hotel and Restaurant';
      case 1:
        return 'All Available Hotels';
      case 2:
        return 'All Available Restaurants';
      case 3:
        return 'All Hotels and Restaurants';
      default:
        return '';
    }
  }
}
