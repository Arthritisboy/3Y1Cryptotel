import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CircleIcon({
    Key? key,
    required this.iconData,
    this.size = 50.0,
    this.backgroundColor = const Color.fromARGB(255, 52, 46, 46),
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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