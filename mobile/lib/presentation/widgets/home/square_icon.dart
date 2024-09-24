import 'package:flutter/material.dart';

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
    return Container(
      width: 72,
      height: 62,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1C3473)
            : backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        iconData,
        color: isSelected
            ? Colors.white 
            : iconColor,
        size: 32,
      ),
    );
  }
}
