import 'package:flutter/material.dart';
import 'circle_icon.dart';

class BottomHomeIconNavigation extends StatelessWidget {
  const BottomHomeIconNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleIcon(iconData: Icons.home),
        CircleIcon(iconData: Icons.favorite),
        CircleIcon(iconData: Icons.search),
        CircleIcon(iconData: Icons.person),
      ],
    );
  }
}
