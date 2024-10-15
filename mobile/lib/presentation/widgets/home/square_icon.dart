import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino icons

class SquareIcon extends StatelessWidget {
  final IconData iconData;
  final bool isSelected;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const SquareIcon({
    super.key,
    required this.iconData,
    this.isSelected = false,
    this.size = 50.0,
    this.backgroundColor = const Color.fromARGB(255, 232, 232, 232),
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 300), // Smooth animation for selection
      width: 72,
      height: 62,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1C3473) : backgroundColor,
        borderRadius: const BorderRadius.all(
            Radius.circular(16)), // Rounded corners for aesthetics
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Icon(
        iconData,
        color: isSelected ? Colors.white : iconColor,
        size: 32,
      ),
    );
  }
}
