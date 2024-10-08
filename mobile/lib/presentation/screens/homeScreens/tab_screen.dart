import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';

Future<void> _storeUsers(List<UserModel> users) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
  await prefs.setString('allUsers', usersJson);
}

Future<List<UserModel>> _getStoredUsers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? usersJson = prefs.getString('allUsers');

  if (usersJson != null) {
    List<dynamic> decodedUsers = jsonDecode(usersJson);
    return decodedUsers.map((user) => UserModel.fromJson(user)).toList();
  }

  return [];
}

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;
  String? firstName;
  String? lastName;
  String? email;
  String? profile;
  List<UserModel> allUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  Future<void> _fetchAllUsers() async {
    context.read<AuthBloc>().add(FetchAllUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        firstName = state.user.firstName ?? '';
        lastName = state.user.lastName ?? '';
        email = state.user.email ?? '';
        profile = state.user.profilePicture ?? '';
      } else if (state is UsersFetched) {
        allUsers = state.users;

        // Store the users in shared preferences
        _storeUsers(allUsers);

        // Print users for confirmation
        for (var user in allUsers) {
          print(
              'User: ${user.firstName} ${user.lastName}, Email: ${user.email}');
        }
      }

      return Scaffold(
        endDrawer: MainDrawer(
          onSelectScreen: _setScreen,
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          email: email ?? '',
          profile: profile ?? '', // Pass profile to the drawer
        ),
        body: Column(
          children: [
            if (firstName != null && lastName != null)
              TabHeader(
                firstName: firstName!,
                lastName: lastName!,
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                child: _selectedIndex == 0
                    ? const HomeScreen()
                    : const RestaurantScreen(),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String screen) {
    Navigator.of(context).pop();
    // Handle navigation
  }
}
