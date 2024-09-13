import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/background_image.dart';
import 'package:hotel_flutter/presentation/widgets/home/header.dart';
import 'package:hotel_flutter/presentation/widgets/main_drawer.dart';
import 'package:hotel_flutter/presentation/widgets/room/meal_card.dart';
import 'package:hotel_flutter/data/model/food_item.dart';
import 'package:hotel_flutter/data/dummydata/food_data.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void _setScreen(String identifier) {
    if (identifier == "homescreen") {
      Navigator.of(context).pushNamed('/homescreen');
    }
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: const BackgroundImage(
              image: 'assets/images/others/homepage.jpg',
            ),
          ),
          Header(),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
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
                                fontSize: 25, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Stack(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.1),
                                BlendMode.darken,
                              ),
                              child: Image.asset(
                                'assets/images/foods/food.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 170,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Asparagus and Steak',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: List.generate(5, (index) {
                                        return const Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(255, 229, 160, 0),
                                          size: 20,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Most Popular',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mostPopularItems.length,
                          itemBuilder: (context, index) {
                            final item = mostPopularItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: MealCardWidget(
                                foodItem: item,
                                onButtonPressed: () {
                                  // Implement order functionality here
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Text(
                        'Breakfast',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: breakFastItems.length,
                          itemBuilder: (context, index) {
                            final item = breakFastItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: MealCardWidget(
                                foodItem: item,
                                onButtonPressed: () {
                                  // Implement order functionality here
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Text(
                        'Lunch',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: lunchItems.length,
                          itemBuilder: (context, index) {
                            final item = lunchItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: MealCardWidget(
                                foodItem: item,
                                onButtonPressed: () {
                                  // Implement order functionality here
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const Text(
                        'Dinner',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dinnerItems.length,
                          itemBuilder: (context, index) {
                            final item = dinnerItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: MealCardWidget(
                                foodItem: item,
                                onButtonPressed: () {
                                  // Implement order functionality here
                                },
                              ),
                            );
                          },
                        ),
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