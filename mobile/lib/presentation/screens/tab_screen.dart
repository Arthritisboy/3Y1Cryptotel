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
    _getUserData(); // Call fetching user data
  }

  Future<void> _getUserData() async {
    final userId = await _secureStorage.read(key: 'userId');
    print('Fetched userId from storage: $userId');
    if (userId != null && !_userDataFetched) {
      context.read<AuthBloc>().add(GetUserEvent(userId));
      setState(() {
        _userDataFetched = true;
      });
    } else {
      print('User ID not found in secure storage or already fetched.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          print(
              'User authenticated: ${state.user.firstName} ${state.user.lastName}');
          setState(() {
            firstName = state.user.firstName ?? '';
            lastName = state.user.lastName ?? '';
            _userDataFetched = true;
          });
        } else if (state is AuthError) {
          print('Error fetching user data: ${state.error}');
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
                          if (_selectedIndex == 0) const HomeScreen(),
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
    Navigator.of(context).pop(); // Close the drawer

    switch (screen) {
      case 'homescreen':
        Navigator.of(context).pushNamed('/homescreen');
        break;
      case 'profile':
        Navigator.of(context).pushNamed('/profile');
        break;
      case '/cryptoTransaction':
        Navigator.of(context).pushNamed('/cryptoTransaction');
        break;
      case 'settings':
        // Assuming you have a settings screen route
        Navigator.of(context).pushNamed('/settings');
        break;
      case 'logout':
        print('Logging out...');
        break;
      default:
        return null;
    }
  }
}
