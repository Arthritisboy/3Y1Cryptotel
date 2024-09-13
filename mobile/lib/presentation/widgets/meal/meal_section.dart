import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/food_model.dart';
import 'package:hotel_flutter/presentation/widgets/meal/meal_card.dart';

class MealSection extends StatelessWidget {
  final String title;
  final List<FoodItem> foodItems;
  final Function(FoodItem) onMealSelected;

  const MealSection({
    super.key,
    required this.title,
    required this.foodItems,
    required this.onMealSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: MealCardWidget(
                  foodItem: item,
                  onButtonPressed: (foodItem) {
                    onMealSelected(foodItem);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
