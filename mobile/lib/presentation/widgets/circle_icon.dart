import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CircleIcon({
    Key? key,
    required this.iconData,
    this.size = 50.0, // Default size
    this.backgroundColor = Colors.brown, // Default background color
    this.iconColor = Colors.white, // Default icon color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // Set width of the circle
      height: size, // Set height of the circle
      decoration: BoxDecoration(
        color: backgroundColor, // Background color (brown by default)
        shape: BoxShape.circle, // Circular shape
      ),
      child: Icon(
        iconData,
        color: iconColor, // Icon color (white by default)
        size: size / 2, // Icon size (proportional to container size)
      ),
    );
  }
}
