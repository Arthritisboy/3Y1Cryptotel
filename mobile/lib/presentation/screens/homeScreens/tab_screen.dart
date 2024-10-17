import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/hotel_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/map_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/search_suggestion.dart';
import 'package:hotel_flutter/data/model/auth/user_model.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_bloc.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/user_storage_helper.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/home_screen.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant_screen.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/tabscreen/bottom_tab_icon_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/drawer/main_drawer.dart';
import 'package:hotel_flutter/presentation/widgets/utils_widget/custom_dialog.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_tab_header.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_bottom_navigation.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/tab/shimmer_card_widget.dart';

class TabScreen extends StatefulWidget {
  TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();


}

class _TabScreenState extends State<TabScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _searchQuery = "";

  String? firstName;
  String? lastName;
  String? email;
  String? profile;
  String? gender;
  String? phoneNumber;
  String? userId;
  List<UserModel> allUsers = [];
  List<String> hotelSuggestion = [
    'River Palm Hotel',
    'Monarch Hotel',
    'Star Plaza Hotel',
    'Puerto Del Sol',
    'The Manaog Hotel',
    'Lenox Hotel',
    'Hotel Monde',
    'Hotel Le Duc',
    'Bergamu Hotel'
    'Bedbox',
  ];
    List<String> restaurantSuggestion = [
    'Matutina’s Gerry’s Seafood House', 
    'Cabalen' 
    'City De Luxe', 
    'Hardin sa Paraiso', 
    'Sungayan Grill', 
    'Pedritos', 
    'Grumpy Joe', 
    'Dampa',
    'Kabsat', 
    'Masa Bakehouse', 
  ];
    late List<String> suggestions;



  List<String> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _initializeUserData(); // Load user data on initialization
    _fetchAllUsers();
    suggestions = [...restaurantSuggestion, ...hotelSuggestion]; // Fixed concatenation

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      filteredSuggestions = _filterSuggestions(query);

    });
  }
  List<String> _filterSuggestions(String query) {
  if (query.isEmpty) {
    return []; // Return empty if no query is present
  }
  
  // Filter suggestions based on the query
  return suggestions.where((suggestion) {
    return suggestion.toLowerCase().contains(query.toLowerCase());
  }).toList();
}

  Future<void> _initializeUserData() async {
    userId = await _secureStorage.read(key: 'userId'); // This can be null

    if (userId != null && userId!.isNotEmpty) {
      // Check if userId is not null and not empty
      await _getUserData(); // Fetch user data only if userId is valid
    } else {
      print('User ID is not set. Unable to fetch user data.');
    }

    setState(() {
      _isLoading =
          false; // Set loading to false once initialization is complete
    });
  }

  Future<void> _getUserData() async {
    if (userId != null && userId!.isNotEmpty) {
      // Check if userId is not null and not empty
      print('Fetching user data from AuthBloc');
      context
          .read<AuthBloc>()
          .add(GetUserEvent(userId!)); // Use the non-null userId
    } else {
      print('No valid user ID to fetch user data.');
    }
  }

  Future<void> _fetchAllUsers() async {
    print('Fetching all users');
    context
        .read<AuthBloc>()
        .add(FetchAllUsersEvent()); // Trigger an event to fetch all users
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    // Check if userId is not null before dispatching
    if (userId != null) {
      context.read<AuthBloc>().add(GetUserEvent(userId!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is null. Please log in again.')),
      );
    }

    // Optionally fetch all users, but make sure it doesn't conflict
    await _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _showExitConfirmationDialog(context),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Current state: $state');
          _handleBlocState(context, state);
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
              body: RefreshIndicator(
                onRefresh: _onRefresh, // Call your fetch method
                child: _isLoading ? _buildShimmerLoading() : _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleBlocState(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      // Store the updated user data
      _storeUserData(state.user);
      setState(() {
        _isLoading = false; // Stop loading once authenticated
      });
    } else if (state is UsersFetched) {
      setState(() {
        allUsers = state.users; // Update the list with the new users
        _isLoading = false; // Stop loading after users are fetched
      });
    } else if (state is AuthInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else if (state is AuthError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
        setState(() {
          _isLoading = false; // Stop loading if there's an error
        });
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
              onSearchChanged: _onSearchChanged,
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
              child: _buildTabContent(),
            ),
          ],
        ),
        if (_searchQuery.isNotEmpty)
          SearchSuggestions(
            suggestions: suggestions,
            searchQuery: _searchQuery,
            onSelect: _onSelectSuggestion,
            onRemove: _onRemoveSuggestion,
          ),
        Positioned(
          top: 40.0,
          right: 10.0,
          child: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            );
          }),
        ),
      ],
    );
  }

void _onSelectSuggestion(String suggestion) {
  setState(() {
    _searchQuery = suggestion;
  });

  // Check if the suggestion is a hotel or a restaurant
  if (hotelSuggestion.contains(suggestion)) {
    // Fetch the list of hotels using BLoC
    final hotelBloc = context.read<HotelBloc>();
    hotelBloc.add(FetchHotelsEvent()); // Ensure the list is updated

    // Use a delayed Future to wait for state update
    Future.delayed(Duration.zero, () {
      final state = hotelBloc.state; // Get the current state

      if (state is HotelLoaded) {
        // Find the index of the hotel suggestion
        int index = hotelSuggestion.indexOf(suggestion);
        HotelModel selectedHotel = state.hotels[index]; // Get the hotel model

        // Get coordinates for the selected hotel
        selectedHotel.getCoordinates().then((coordinates) {
          // Navigate to the HotelScreen with the selected hotel data
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HotelScreen(
                hotelId: selectedHotel.id,
                hotelImage: selectedHotel.hotelImage,
                hotelName: selectedHotel.name,
                rating: selectedHotel.averageRating,
                price: selectedHotel.averagePrice,
                location: selectedHotel.location,
                time: selectedHotel.openingHours,
                latitude: coordinates[0], // Use the retrieved coordinates
                longitude: coordinates[1], // Use the retrieved coordinates
              ),
            ),
          );
        });
      }
    });
  } else if (restaurantSuggestion.contains(suggestion)) {
    // Fetch the list of restaurants using BLoC
    final restaurantBloc = context.read<RestaurantBloc>();
    restaurantBloc.add(FetchRestaurantsEvent()); // Ensure the list is updated

    // Use a delayed Future to wait for state update
    Future.delayed(Duration.zero, () {
      final state = restaurantBloc.state; // Get the current state

      if (state is RestaurantLoaded) {
        // Find the index of the restaurant suggestion
        int index = restaurantSuggestion.indexOf(suggestion);
        RestaurantModel selectedRestaurant = state.restaurants[index]; // Get the restaurant model

        // Get coordinates for the selected restaurant
        selectedRestaurant.getCoordinates().then((coordinates) {
          // Navigate to the RestaurantScreen with the selected restaurant data
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Restaurant(
                restaurantId: selectedRestaurant.id,
                restaurantName: selectedRestaurant.name,
                capacity: selectedRestaurant.capacity, // Assuming capacity is part of the model
                restaurantImage: selectedRestaurant.restaurantImage,
                rating: selectedRestaurant.averageRating,
                price: selectedRestaurant.price,
                location: selectedRestaurant.location,
                time: selectedRestaurant.openingHours,
                latitude: coordinates[0], // Use the retrieved coordinates
                longitude: coordinates[1], // Use the retrieved coordinates
              ),
            ),
          );
        });
      }
    });
  }
}



  void _onRemoveSuggestion(String suggestion) {
    setState(() {
      suggestions.remove(suggestion);
    });
  }

  Widget _buildTabContent() {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedIndex == 0) ...[
          // Section for Hotels (Horizontal Scroll)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Top Rated Hotels',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocProvider<HotelBloc>(
            create: (context) =>
                HotelBloc(context.read())..add(FetchHotelsEvent()),
            child: HomeScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.horizontal,
              rowOrColumn: 'row',  // Set to 'row' for horizontal layout
              width: 320,
            ),
          ),
          const SizedBox(height: 20),

          // Section for Restaurants (Horizontal Scroll)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Top Rated Restaurants',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) =>
                RestaurantBloc(context.read())..add(FetchRestaurantsEvent()),
            child: RestaurantScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.horizontal,
              rowOrColumn: 'row', // Set to 'row' for horizontal layout
              width: 320,
            ),
          ),
        ],
        if (_selectedIndex == 1) ...[
          // Separate Restaurants Tab (Vertical Scroll)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 20),
            child: Text(
              'All Available Restaurants',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocProvider<RestaurantBloc>(
            create: (context) =>
                RestaurantBloc(context.read())..add(FetchRestaurantsEvent()),
            child: RestaurantScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.vertical,  // Set to 'column' for vertical layout
              rowOrColumn: 'column',
              width: 400,
            ),
          ),
        ],
        if (_selectedIndex == 2) ...[
          // Separate Hotels Tab (Vertical Scroll)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'All Available Hotels',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocProvider<HotelBloc>(
            create: (context) =>
                HotelBloc(context.read())..add(FetchHotelsEvent()),
            child: HomeScreen(
              searchQuery: _searchQuery,
              scrollDirection: Axis.vertical,  // Set to 'column' for vertical layout
              rowOrColumn: 'column',
              width: 400,
            ),
          ),
        ],
        if (_selectedIndex == 3) 
        ...[
                  Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Map of Hotel and Restaurants',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) =>
          HotelBloc(context.read())..add(FetchHotelsEvent()),
    ),
    BlocProvider(
      create: (context) => RestaurantBloc(context.read())
        ..add(FetchRestaurantsEvent()), // Fetch restaurants event
    ),
  ],
  child: MapScreen(),
)
        ],
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
              'userId': userId,
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
    // Update UI immediately
    setState(() {
      firstName = user.firstName;
      lastName = user.lastName;
      email = user.email;
      profile = user.profilePicture;
      userId = user.id;
    });

    // Log the stored user data for debugging
    print('User data stored: $firstName $lastName $email');
  }

  // You no longer need to store this data in secure storage or shared prefs
  // Your AuthBloc will manage the user state and your UI will react to those changes

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
