import 'package:flutter/material.dart';
import 'circle_icon.dart';
import 'package:hotel_flutter/presentation/screens/menu_screens.dart';

class BottomHomeIconNavigation extends StatelessWidget {
  const BottomHomeIconNavigation({super.key});

  void _navigateToMenuScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/menuscreen');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {},
          child: const CircleIcon(iconData: Icons.favorite),
        ),
        GestureDetector(
          onTap: () => _navigateToMenuScreen(context),
          child: const CircleIcon(iconData: Icons.restaurant),
        ),
        GestureDetector(
          onTap: () {},
          child: const CircleIcon(iconData: Icons.room),
        ),
        GestureDetector(
          onTap: () {},
          child: const CircleIcon(iconData: Icons.person),
        ),
      ],
    );
  }
}
