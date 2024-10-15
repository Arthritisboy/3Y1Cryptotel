import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:logging/logging.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/user_storage_helper.dart';

import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_home_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_bottom_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_card_widget.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final Logger _logger = Logger('TabScreen');
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _searchQuery = ""; // Add a search query state

  String? firstName;
  String? lastName;
  String? email;
  String? profile;
  String? gender;
  String? phoneNumber;
  String? userId;
  List<UserModel> allUsers = [];

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _fetchAllUsers();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query; // Update the search query
    });
  }

  Future<void> _initializeUserData() async {
    try {
      await _getUserData();
    } catch (e) {
      _logger.severe('Error initializing user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getUserData() async {
    final userId = await _secureStorage.read(key: 'userId');
    _logger.info('Retrieved userId: $userId');
    if (userId != null) {
      context.read<AuthBloc>().add(GetUserEvent(userId));
    }
  }

  Future<void> _fetchAllUsers() async {
    final token = await _secureStorage.read(key: 'jwt');
    _logger.info('Retrieved token: $token');
    if (token != null) {
      context.read<AuthBloc>().add(FetchAllUsersEvent());
    } else {
      _logger.warning('Token is missing. Skipping user fetch.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitConfirmationDialog(context),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          _handleBlocState(context, state);
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.lightGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              endDrawer: MainDrawer(
                onSelectScreen: _setScreen,
                firstName: firstName ?? 'Guest',
                lastName: lastName ?? '',
                email: email ?? '',
                profile: profile ?? '',
              ),
              body: _isLoading ? _buildShimmerLoading() : _buildContent(),
            );
          },
        ),
      ),
    );
  }

  void _handleBlocState(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      _storeUserData(state.user);
    } else if (state is UsersFetched) {
      allUsers = state.users;
      _storeFetchedUsers(allUsers);
    } else if (state is AuthInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else if (state is AuthError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
      });
    }
  }

  Future<void> _storeFetchedUsers(List<UserModel> users) async {
    await UserStorageHelper.clearUsers();
    await UserStorageHelper.storeUsers(users);
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: const [
        ShimmerTabHeader(),
        SizedBox(height: 10),
        ShimmerBottomNavigation(),
        SizedBox(height: 10),
        Expanded(child: ShimmerCardWidget()),
      ],
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabHeader(
              firstName: firstName ?? 'Guest',
              lastName: lastName ?? '',
              onSearchChanged: _onSearchChanged, // Pass the callback
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BottomTabIconNavigation(
                selectedIndex: _selectedIndex,
                onIconTapped: _onIconTapped,
              ),
            ),
            Expanded(
              child: _buildTabContent(), // Extract Tab Content Logic
            ),
          ],
        ),
        if (_searchQuery.isNotEmpty)
          _buildSearchSuggestions(), // Show suggestions

        Positioned(
          top: 40.0,
          right: 10.0,
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    List<String> suggestions = [
      'The Monarch Hotel',
      'Star Plaze Hotel',
      'Matutina’s',
      'Dagupeña',
      'Lenox Hotel',
    ];

    List<String> filteredSuggestions = suggestions
        .where(
            (hotel) => hotel.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Positioned(
      top: 235, // Adjust the top position to align correctly
      left: 16,
      right: 16,
      child: Material(
        elevation: 5,
        color: Colors.transparent, // Make Material background transparent
        borderRadius: BorderRadius.circular(10), // Apply border radius
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // White background for dropdown
            borderRadius: BorderRadius.circular(10), // Smooth rounded corners
            border: Border.all(
              color: Colors.grey, // Light gray border
              width: 1.0,
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredSuggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  filteredSuggestions[index],
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                onTap: () {
                  setState(() {
                    _searchQuery = filteredSuggestions[index];
                    filteredSuggestions = []; // Clear the list on selection
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedIndex == 0) ...[
            BlocProvider<HotelBloc>(
              create: (context) =>
                  HotelBloc(context.read())..add(FetchHotelsEvent()),
              child: HomeScreen(
                searchQuery: _searchQuery,
                scrollDirection: Axis.horizontal,
                rowOrColumn: 'row',
                width: 320,
              ),
            ),
            BlocProvider<RestaurantBloc>(
              create: (context) =>
                  RestaurantBloc(context.read())..add(FetchRestaurantsEvent()),
              child: RestaurantScreen(
                searchQuery: _searchQuery,
                scrollDirection: Axis.horizontal,
                rowOrColumn: 'row',
                width: 320,
              ),
            ),
          ],
          if (_selectedIndex == 1)
            RestaurantScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.vertical,
              rowOrColumn: 'column',
              width: 400,
            ),
          if (_selectedIndex == 2)
            HomeScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.vertical,
              rowOrColumn: 'column',
              width: 400,
            ),
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you really want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Exit'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String screen) {
    Navigator.of(context).pop();
    switch (screen) {
      case 'homescreen':
        Navigator.of(context).pushNamed('/homescreen');
        break;
      case 'profile':
        if (firstName != null && lastName != null) {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to access profile')),
          );
        }
        break;
      case 'help':
        Navigator.of(context).pushNamed('/help');
        break;
      case '/cryptoTransaction':
        Navigator.of(context).pushNamed('/cryptoTransaction');
        break;
      case 'history':
        Navigator.of(context).pushNamed('/history');
        break;
      case 'favorite':
        if (userId != null) {
          Navigator.of(context).pushNamed(
            '/favorite',
            arguments: {'userId': userId}, // Pass userId here
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User ID is missing.')),
          );
        }
        break;
      case 'logout':
        _showLogoutConfirmationDialog();
        break;
      default:
        Navigator.of(context).pushNamed('/$screen');
    }
  }

  Future<void> _storeUserData(UserModel user) async {
    setState(() {
      firstName = user.firstName;
      lastName = user.lastName;
      email = user.email;
      profile = user.profilePicture;
      gender = user.gender;
      phoneNumber = user.phoneNumber;
      userId = user.id;
    });

    await _secureStorage.write(key: 'userId', value: userId);
    await _secureStorage.write(key: 'firstName', value: firstName);
    await _secureStorage.write(key: 'lastName', value: lastName);
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'gender', value: gender);
    await _secureStorage.write(key: 'phoneNumber', value: phoneNumber);
    await _secureStorage.write(key: 'profile', value: profile);
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Logout Confirmation',
          description: 'Are you sure you want to logout?',
          buttonText: 'Yes',
          onButtonPressed: () async {
            await _handleLogout();
            Navigator.of(context).pop();
          },
          secondButtonText: 'No',
          onSecondButtonPressed: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    context.read<AuthBloc>().add(LogoutEvent());
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
