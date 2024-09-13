import 'package:flutter/material.dart';
import 'image_with_text.dart';
import 'package:hotel_flutter/presentation/screens/menu_screens.dart';

class FoodSection extends StatelessWidget {
  const FoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 380,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
            child: const ImageWithText(
              imagePath: 'assets/images/foods/food.png',
              text: 'List of Foods',
              height: 129.0,
              width: 380.0,
            ),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.0,
              child: ImageWithText(
                imagePath: 'assets/images/foods/special_food.png',
                text: 'Special Food',
                height: 116.0,
                width: 150.0,
              ),
            ),
            SizedBox(
              width: 230.0,
              child: ImageWithText(
                imagePath: 'assets/images/foods/service_food.png',
                text: 'Service Food',
                height: 116.0,
                width: 230.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
