import 'package:hotel_flutter/data/model/food_model.dart';

final List<FoodItem> foodData = [
  FoodItem(
    imagePath: 'assets/images/foods/food.png',
    title: 'Asparagus and Steak',
    shortDescription: 'Grilled asparagus with steak.',
    price: 15.0,
    categories: [FoodCategory.lunch],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/eggbreakfast.png',
    title: 'Egg ',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.breakFast],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/hamegg.png',
    title: 'Egg Sanwhich',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.breakFast],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/pancake2.png',
    title: 'Pancake',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.breakFast, FoodCategory.mostPopular],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/steak2.png',
    title: 'Steak',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [
      FoodCategory.lunch,
      FoodCategory.mostPopular,
      FoodCategory.dinner
    ],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/salad.png',
    title: 'Salad',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.lunch, FoodCategory.mostPopular],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/cordon_blue.png',
    title: 'Cordon Bleu',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.dinner],
  ),
  FoodItem(
    imagePath: 'assets/images/foods/roastbeef.png',
    title: 'Roast Beef',
    shortDescription: 'Lorem ipsum dolor sit amet, consectetur...',
    price: 15.0,
    categories: [FoodCategory.dinner, FoodCategory.mostPopular],
  ),
];
