import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/home_screen.dart';
import 'package:hotel_flutter/presentation/widgets/main_drawer.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:hotel_flutter/presentation/screens/favorite_screen.dart';
import 'package:hotel_flutter/presentation/screens/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    if (identifier == "homescreen") {
      // Handle navigation or screen selection logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage;

    switch (_selectedPageIndex) {
      case 1:
        activePage = const FavoriteScreen();
        break;
      case 2:
        activePage = const ProfileScreen();
        break;
      default:
        activePage = const HomeScreen();
    }

    return Scaffold(
      endDrawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30.0,
        elevation: 0.0,
        selectedItemColor: Colors.black,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: Stack(
        children: [
          activePage,
          Positioned(
            top: 40.0,
            right: 10.0,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer(); // Open the end drawer
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
