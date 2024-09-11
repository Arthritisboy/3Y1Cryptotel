import 'package:flutter/material.dart';
import 'image_with_text.dart'; // Update with the correct path if necessary

class FoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 380,
          child: ImageWithText(
            imagePath: 'assets/images/others/food.png',
            text: 'List of Foods',
            height: 129.0,
            width: 380.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0,
              child: ImageWithText(
                imagePath: 'assets/images/others/special_food.png',
                text: 'Special Food',
                height: 116.0,
                width: 150.0,
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              width: 230,
              child: ImageWithText(
                imagePath: 'assets/images/others/service_food.png',
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
