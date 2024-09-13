import 'package:hotel_flutter/data/model/food_item.dart';

final List<FoodItem> foodData = [
  FoodItem(
    imagePath: 'assets/images/others/hotelroom_1.png',
    title: 'Steak',
    shortDescription: 'A juicy steak served with sides.',
    price: 13.0,
    categories: [FoodCategory.Lunch, FoodCategory.mostPopular],
  ),
  FoodItem(
    imagePath: 'assets/images/others/food.png',
    title: 'Asparagus and Steak',
    shortDescription: 'Grilled asparagus with steak.',
    price: 15.0,
    categories: [FoodCategory.Lunch],
  ),
];
