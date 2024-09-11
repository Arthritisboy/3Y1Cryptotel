import 'package:flutter/material.dart';
import 'circle_icon.dart';
import 'package:hotel_flutter/presentation/screens/menu_screens.dart';

class BottomHomeIconNavigation extends StatelessWidget {
  const BottomHomeIconNavigation({Key? key}) : super(key: key);

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
          child: CircleIcon(iconData: Icons.favorite),
        ),
        GestureDetector(
          onTap: () => _navigateToMenuScreen(context),
          child: CircleIcon(iconData: Icons.restaurant),
        ),
        GestureDetector(
          onTap: () {},
          child: CircleIcon(iconData: Icons.room),
        ),
        GestureDetector(
          onTap: () {},
          child: CircleIcon(iconData: Icons.person),
        ),
      ],
    );
  }
}
