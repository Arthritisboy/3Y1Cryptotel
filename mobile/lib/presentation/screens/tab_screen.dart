import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/home/home_header.dart';
import 'package:hotel_flutter/presentation/widgets/home/popular_restaurant.dart';
import 'package:hotel_flutter/presentation/widgets/home/popular_hotel.dart';
import 'package:hotel_flutter/presentation/widgets/tab/main_drawer.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;
  int _selectedPageIndex = 0;

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    if (identifier == "homescreen") {
      if (identifier == "homescreen") {
        const TabScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;

    switch (_selectedPageIndex) {
      case 1:
        activePage = const TabScreen();
        break;
    }
    return Scaffold(
      endDrawer: MainDrawer(onSelectScreen: _setScreen),
      body: Stack(
        children: [
          Column(
            children: [
              Header(),
              const SizedBox(height: 10),
              BottomHomeIconNavigation(
                selectedIndex: _selectedIndex,
                onIconTapped: _onIconTapped, // Pass the callback
              ),
              Expanded(
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
                        // Conditional rendering based on selected index
                        if (_selectedIndex == 0) ...[
                          const PopularRooms(),
                          const PopularRestaurant()
                        ],
                        if (_selectedIndex == 1) const PopularRestaurant(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
