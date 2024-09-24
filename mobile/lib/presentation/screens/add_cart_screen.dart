import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/food_model.dart';

class AddCartScreen extends StatelessWidget {
  final List<FoodItem> selectedMeals;

  const AddCartScreen(this.selectedMeals, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: selectedMeals.length,
        itemBuilder: (context, index) {
          final meal = selectedMeals[index];
          return ListTile(
            leading: Image.asset(
              meal.imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(meal.title),
            subtitle: Text(meal.shortDescription),
          );
        },
      ),
    );
  }
}
