import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/home_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tab/main_drawer.dart';
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
      if (identifier == "homescreen") {
        const HomeScreen();
      }
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
      body: Stack(
        children: [
          activePage,
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
