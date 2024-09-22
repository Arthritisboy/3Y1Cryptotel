import 'package:flutter/material.dart';

class SquareIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const SquareIcon({
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
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: size / 2,
      ),
    );
  }
}
