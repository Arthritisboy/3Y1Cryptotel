import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_card_widget.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/user_storage_helper.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/home_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_bottom_navigation.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _selectedIndex = 0;
  bool _isLoading = true;
  String? firstName;
  String? lastName;
  String? email;
  String? profile;
  String? gender;
  String? phoneNumber;
  List<UserModel> allUsers = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchAllUsers();
  }

  Future<void> _getUserData() async {
    final userId = await _secureStorage.read(key: 'userId');
    if (userId != null) {
      context.read<AuthBloc>().add(GetUserEvent(userId));
    }
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
        gender = state.user.gender ?? '';
        phoneNumber = state.user.phoneNumber ?? '';
        profile = state.user.profilePicture ?? '';
        _isLoading = false;

        // Write user data to secure storage
        _secureStorage.write(key: 'firstName', value: firstName);
        _secureStorage.write(key: 'lastName', value: lastName);
        _secureStorage.write(key: 'email', value: email);
        _secureStorage.write(key: 'gender', value: gender);
        _secureStorage.write(key: 'phoneNumber', value: phoneNumber);
        _secureStorage.write(key: 'profile', value: profile);

        // Store users using the helper
        UserStorageHelper.storeUsers(allUsers);
      } else if (state is AuthInitial) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      } else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      } else if (state is UsersFetched) {
        allUsers = state.users;

        // Store the users in shared preferences
        UserStorageHelper.storeUsers(allUsers);

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
          profile: profile ?? '',
        ),
        body: _isLoading
            ? Column(
                children: const [
                  ShimmerTabHeader(),
                  SizedBox(height: 10),
                  ShimmerBottomNavigation(),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(child: ShimmerCardWidget()),
                ],
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      TabHeader(
                        firstName: firstName ?? 'Guest',
                        lastName: lastName ?? '',
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
    });
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
            'profile': profile,
            'gender': gender,
            'phoneNumber': phoneNumber,
          },
        );
        break;
      case 'help':
        Navigator.of(context).pushNamed('/help');
        break;
      case '/cryptoTransaction':
        Navigator.of(context).pushNamed('/cryptoTransaction');
        break;
      case 'settings':
        Navigator.of(context).pushNamed('/settings');
        break;
      case 'favorite':
        Navigator.of(context).pushNamed('/favorite');
        break;
      case 'logout':
        _showLogoutConfirmationDialog();
        break;
      default:
        return;
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Logout Confirmation',
          description: 'Are you sure you want to logout?',
          buttonText: 'Yes',
          onButtonPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
            Navigator.of(context).pop(); // Close dialog
          },
          secondButtonText: 'No',
          onSecondButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
        );
      },
    );
  }
}
