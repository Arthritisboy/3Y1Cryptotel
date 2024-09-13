import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/circle_icon.dart';

class FacilityIcon extends StatelessWidget {
  const FacilityIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleIcon(iconData: Icons.home, size: 60),
        CircleIcon(iconData: Icons.wifi, size: 60),
        CircleIcon(iconData: Icons.car_rental, size: 60),
        CircleIcon(iconData: Icons.severe_cold, size: 60),
      ],
    );
  }
}
