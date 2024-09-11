import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:hotel_flutter/presentation/widgets/image_with_text.dart';
import 'package:hotel_flutter/presentation/widgets/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/image_with_heart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, bool> _heartStatus = {
    'assets/images/others/hotelroom_1.png': false,
    'assets/images/others/hotelroom_2.png': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage('assets/images/others/homepage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/others/logowhite.png',
                          width: 72.0,
                          height: 107.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cryptotel',
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Hotel and Restaurant',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        errorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      onTap: () {
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Popular Rooms',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 200.0,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildImageWithHeart(
                                      'assets/images/others/hotelroom_1.png',
                                      'Deluxe Room',
                                      'King Size Bed'),
                                  SizedBox(width: 10.0),
                                  _buildImageWithHeart(
                                      'assets/images/others/hotelroom_2.png',
                                      'Suite Room',
                                      'Queen Size Bed'),
                                  SizedBox(width: 10.0),
                                  _buildImageWithHeart(
                                      'assets/images/others/hotelroom_1.png',
                                      'Deluxe Room',
                                      'King Size Bed'),
                                ],
                              ),
                            ),
                          ),
                          BottomHomeIconNavigation(),
                          Column(
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
                                      imagePath:
                                          'assets/images/others/special_food.png',
                                      text: 'Special Food',
                                      height: 116.0,
                                      width: 150.0,
                                    ),
                                  ),
                                  Container(
                                    width: 230,
                                    child: ImageWithText(
                                      imagePath:
                                          'assets/images/others/service_food.png',
                                      text: 'Service Food',
                                      height: 116.0,
                                      width: 230.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  Widget _buildImageWithHeart(
      String imagePath, String roomName, String typeOfRoom) {
    return ImageWithHeart(
      imagePath: imagePath,
      isHeartFilled: _heartStatus[imagePath] ?? false,
      onHeartPressed: (isFilled) {
        setState(() {
          _heartStatus[imagePath] = isFilled;
        });
      },
      roomName: roomName,
      typeOfRoom: typeOfRoom,
    );
  }
}
