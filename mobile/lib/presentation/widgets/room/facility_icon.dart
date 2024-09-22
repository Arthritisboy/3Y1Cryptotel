import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/square_icon.dart';

class FacilityIcon extends StatelessWidget {
  const FacilityIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SquareIcon(iconData: Icons.home, size: 60),
        SquareIcon(iconData: Icons.wifi, size: 60),
        SquareIcon(iconData: Icons.car_rental, size: 60),
        SquareIcon(iconData: Icons.severe_cold, size: 60),
      ],
    );
  }
}
