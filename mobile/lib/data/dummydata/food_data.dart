import 'package:hotel_flutter/data/model/food_item.dart';

final List<FoodItem> foodData = [
  FoodItem(
    imagePath: 'assets/images/foods/steak.png',
    title: 'Steak',
    shortDescription: 'A juicy steak served with sides.',
    price: 13.0,
    categories: [FoodCategory.lunch, FoodCategory.mostPopular],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/shrimp_pasta.png',
    title: 'Shrimp Pasta',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 13.0,
    categories: [FoodCategory.mostPopular, FoodCategory.lunch],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/food.png',
    title: 'Steak',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 13.0,
    categories: [FoodCategory.mostPopular, FoodCategory.breakFast],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/food.png',
    title: 'Asparagus and Steak',
    shortDescription: 'Grilled asparagus with steak.',
    price: 15.0,
    categories: [FoodCategory.lunch],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/avocado.png',
    title: 'Avocado',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.breakFast],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/spanish_latte.png',
    title: 'Spanish Latte',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.breakFast],
  ),
];
