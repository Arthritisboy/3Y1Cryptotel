import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/food_model.dart';
import 'package:hotel_flutter/data/dummydata/food_data.dart';
import 'package:hotel_flutter/presentation/widgets/meal/meal_section.dart';
import 'package:hotel_flutter/presentation/widgets/meal/menu_header.dart';
import 'package:hotel_flutter/presentation/widgets/meal/popular_section.dart';
import 'package:hotel_flutter/presentation/widgets/tab/main_drawer.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void _setScreen(String identifier) {
    if (identifier == "homescreen") {
      Navigator.of(context).pushNamed('/homescreen');
    }
  }

  List<FoodItem> selectedMeals = []; // Track selected meals

  void _addToCart(FoodItem foodItem) {
    setState(() {
      selectedMeals.add(foodItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodItem> mostPopularItems = foodData.where((item) {
      return item.categories.contains(FoodCategory.mostPopular);
    }).toList();
    final List<FoodItem> breakFastItems = foodData.where((item) {
      return item.categories.contains(FoodCategory.breakFast);
    }).toList();
    final List<FoodItem> lunchItems = foodData.where((item) {
      return item.categories.contains(FoodCategory.lunch);
    }).toList();
    final List<FoodItem> dinnerItems = foodData.where((item) {
      return item.categories.contains(FoodCategory.dinner);
    }).toList();

    return Scaffold(
      endDrawer: MainDrawer(onSelectScreen: _setScreen),
      body: Stack(
        children: [
          MenuHeader(onDrawerSelected: _setScreen),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Menu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const PopularImageSection(),
                      const SizedBox(height: 8),
                      MealSection(
                        title: 'Most Popular',
                        foodItems: mostPopularItems,
                        onMealSelected: (foodItem) {
                          _addToCart(foodItem);
                          // Pass selected meals back to HomeScreen
                          Navigator.pop(context, selectedMeals);
                        },
                      ),
                      MealSection(
                        title: 'Breakfast',
                        foodItems: breakFastItems,
                        onMealSelected: (foodItem) {
                          _addToCart(foodItem);
                          // Pass selected meals back to HomeScreen
                          Navigator.pop(context, selectedMeals);
                        },
                      ),
                      MealSection(
                        title: 'Lunch',
                        foodItems: lunchItems,
                        onMealSelected: (foodItem) {
                          _addToCart(foodItem);
                          Navigator.pop(context, selectedMeals);
                        },
                      ),
                      MealSection(
                        title: 'Dinner',
                        foodItems: dinnerItems,
                        onMealSelected: (foodItem) {
                          _addToCart(foodItem);
                          Navigator.pop(context, selectedMeals);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}