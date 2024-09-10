import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/screens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/favorite_screen.dart';
import 'package:hotel_flutter/presentation/screens/login_screen.dart';
import 'package:hotel_flutter/presentation/screens/profile_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageindex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();

    if (_selectedPageindex == 1) {
      activePage = FavoriteScreen();
    }
    if (_selectedPageindex == 2) {
      activePage = ProfileScreen();
    }
    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageindex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
