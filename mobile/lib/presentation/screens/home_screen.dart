import 'package:flutter/material.dart';
import 'package:hotel_flutter/data/model/food_model.dart';
import 'package:hotel_flutter/presentation/screens/add_cart_screen.dart';
import 'package:hotel_flutter/presentation/widgets/home/background_image.dart';
import 'package:hotel_flutter/presentation/widgets/home/home_header.dart';
import 'package:hotel_flutter/presentation/widgets/home/popular_rooms.dart';
import 'package:hotel_flutter/presentation/widgets/home/bottom_home_icon_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _heartStatus = {
    'assets/images/others/hotelroom_1.png': false,
    'assets/images/others/hotelroom_2.png': false,
  };

  // Track selected meals
  List<FoodItem> selectedMeals = [];

  @override
  void initState() {
    super.initState();
    // Retrieve passed data if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as List<FoodItem>?;
      if (args != null) {
        setState(() {
          selectedMeals.addAll(args);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Header(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.0)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopularRooms(
                            heartStatus: _heartStatus,
                            onHeartPressed: (imagePath, isFilled) {
                              setState(() {
                                _heartStatus[imagePath] = isFilled;
                              });
                            },
                          ),
                          const BottomHomeIconNavigation(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40.0,
            right: 45.0,
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCartScreen(selectedMeals),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
