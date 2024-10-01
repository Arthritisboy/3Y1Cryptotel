import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';
import 'package:hotel_flutter/presentation/screens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _selectedIndex = 0;
  String firstName = '';
  String lastName = '';
  bool _userDataFetched = false; // Track if user data has been fetched

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    // Retrieve the user ID from secure storage
    final userId = await _secureStorage.read(key: 'userId');
    if (userId != null && !_userDataFetched) {
      context.read<AuthBloc>().add(GetUserEvent(userId));
      _userDataFetched = true; // Mark as fetched
    } else {
      print('User ID not found in secure storage or already fetched.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() {
            firstName = state.user.firstName ?? '';
            lastName = state.user.lastName ?? '';
          });
        }
      },
      child: Scaffold(
        endDrawer: MainDrawer(onSelectScreen: _setScreen),
        body: Stack(
          children: [
            Column(
              children: [
                TabHeader(firstName: firstName, lastName: lastName),
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
                            const RestaurantScreen(), // chatgpt dont remove this
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
      ),
    );
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String screen) {
    // Implement navigation or screen selection logic
  }
}
