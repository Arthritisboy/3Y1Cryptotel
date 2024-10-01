import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/home_header.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;
  String _currentScreen = 'homescreen'; // Track the current screen

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String identifier) {
    // Prevent navigating to the same screen
    if (identifier == _currentScreen) {
      Navigator.of(context)
          .pop(); // Close the drawer if already on the same screen
      return;
    }

    setState(() {
      _currentScreen = identifier; // Update the current screen identifier
    });

    if (identifier == 'homescreen') {
      Navigator.of(context).pushReplacementNamed('/homescreen');
    } else if (identifier == 'profile') {
      Navigator.of(context).pushReplacementNamed('/profile');
    } else if (identifier == '/cryptoTransaction') {
      Navigator.of(context).pushReplacementNamed('/cryptoTransaction');
    }
    // You can add more routes here if needed
  }

  @override
  Widget build(BuildContext context) {
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
                onIconTapped: _onIconTapped,
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
                        if (_selectedIndex == 0) ...[
                          const HomeScreen(),
                          const RestaurantScreen()
                        ],
                        if (_selectedIndex == 1) const RestaurantScreen(),
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
