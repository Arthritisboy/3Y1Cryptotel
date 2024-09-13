import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CircleIcon({
    super.key,
    required this.iconData,
    this.size = 50.0,
    this.backgroundColor = const Color.fromARGB(255, 52, 46, 46),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: size / 2,
      ),
    );
  }
}
