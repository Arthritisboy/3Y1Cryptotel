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

  String? firstName;
  String? lastName;
  String? email;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userId = await _secureStorage.read(key: 'userId');
    if (userId != null) {
      context.read<AuthBloc>().add(GetUserEvent(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(
        onSelectScreen: _setScreen,
        firstName: firstName ?? '', // Pass firstName to MainDrawer
        lastName: lastName ?? '', // Pass lastName to MainDrawer
        email: email ?? '', // Pass email to MainDrawer
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // BlocListener to update user data on authentication changes
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    setState(() {
                      firstName = state.user.firstName ?? '';
                      lastName = state.user.lastName ?? '';
                      email = state.user.email ?? '';
                    });

                    // Write user data to secure storage after successful authentication
                    _secureStorage.write(key: 'firstName', value: firstName);
                    _secureStorage.write(key: 'lastName', value: lastName);
                    _secureStorage.write(key: 'email', value: email);
                  } else if (state is AuthInitial) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    });
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return TabHeader(
                        firstName: state.user.firstName ?? '',
                        lastName: state.user.lastName ?? '',
                      );
                    }
                    return Container();
                  },
                ),
              ),
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
                  icon: const Icon(Icons.menu, color: Colors.black),
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
        Navigator.of(context).pushNamed(
          '/profile',
          arguments: {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
          },
        );
        break;
      case '/cryptoTransaction':
        Navigator.of(context).pushNamed('/cryptoTransaction');
        break;
      case 'settings':
        Navigator.of(context).pushNamed('/settings');
        break;
      case 'logout':
        context.read<AuthBloc>().add(LogoutEvent());
        break;
      default:
        return null;
    }
  }
}
