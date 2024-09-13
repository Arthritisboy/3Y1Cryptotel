import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/background_image.dart';
import 'package:hotel_flutter/presentation/widgets/home/header.dart';
import 'package:hotel_flutter/presentation/widgets/home/popular_rooms.dart';
import 'package:hotel_flutter/presentation/widgets/home/food_section.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(
            image: 'assets/images/others/homepage.jpg',
          ),
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
                          const FoodSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
