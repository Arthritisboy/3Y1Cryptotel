import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_event.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_item_model.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/hotel_screen.dart'; // Import Hotel screen
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant.dart'; // Import Restaurant screen
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart'; // Import Restaurant BLoC
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart'; // Import Hotel BLoC
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoading) {
                  return _buildShimmerLoadingEffect();
                } else if (state is FavoritesFetched) {
                  return _buildFavoriteList(context, state.favorites);
                } else if (state is FavoriteError) {
                  return _buildNoFavoritesMessage();
                }
                return _buildNoFavoritesMessage(); // Show message when there's no initial state
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: const Text(
                'Favorites',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFavoritesMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.0,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No favorites yet!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add some hotels or restaurants to your favorites. \n \n If you think this is an error, Scroll down to refresh',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList(
      BuildContext context, List<FavoriteItem> favorites) {
    if (favorites.isEmpty) {
      return _buildNoFavoritesMessage(); // Return message if the list is empty
    }

    return RefreshIndicator(
      onRefresh: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        context.read<FavoriteBloc>().add(FetchFavoritesEvent(
            prefs.getString('userId') ?? '')); // Trigger fetch event
      },
      child: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                    8.0), // Optional: adds rounded corners
                child: Image.network(
                  favorite.imageUrl,
                  width: 60.0, // Set a fixed width for the image
                  height: 60.0, // Set a fixed height for the image
                  fit: BoxFit
                      .cover, // Ensures the image covers the designated area
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60.0,
                      height: 60.0,
                      color: Colors
                          .grey, // Fallback color in case of image load failure
                      child: const Icon(
                          Icons.error), // Optional: shows an error icon
                    );
                  },
                ),
              ),
              title: Text(
                favorite.name,
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                favorite.location,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: () {
                _navigateToFavorite(context, favorite);
              },
            ),
          );
        },
      ),
    );
  }

  void _navigateToFavorite(BuildContext context, FavoriteItem favorite) {
    if (favorite.type == 'hotel') {
      _navigateToHotel(context, favorite);
    } else if (favorite.type == 'restaurant') {
      _navigateToRestaurant(context, favorite);
    }
  }

  void _navigateToHotel(BuildContext context, FavoriteItem favorite) async {
    final hotelBloc = context.read<HotelBloc>();

    // Dispatch the event to fetch hotels if not already loaded
    if (hotelBloc.state is! HotelLoaded) {
      hotelBloc.add(FetchHotelsEvent());
    }

    // Wait for the HotelLoaded state before proceeding
    final state = await hotelBloc.stream
        .firstWhere((state) => state is HotelLoaded || state is HotelError);

    if (state is HotelLoaded) {
      int index = state.hotels.indexWhere((h) => h.id == favorite.id);
      if (index != -1) {
        HotelModel selectedHotel = state.hotels[index];
        final coordinates = await selectedHotel.getCoordinates();

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
              latitude: coordinates[0],
              longitude: coordinates[1],
            ),
          ),
        );
      } else {
        debugPrint('Hotel not found.');
      }
    } else if (state is HotelError) {
      debugPrint('Failed to load hotels. Please try again.');
    }
  }

  void _navigateToRestaurant(
      BuildContext context, FavoriteItem favorite) async {
    final restaurantBloc = context.read<RestaurantBloc>();

    // Dispatch the event to fetch restaurants if not already loaded
    if (restaurantBloc.state is! RestaurantLoaded) {
      restaurantBloc.add(FetchRestaurantsEvent());
    }

    // Wait for the RestaurantLoaded state before proceeding
    final state = await restaurantBloc.stream.firstWhere(
        (state) => state is RestaurantLoaded || state is RestaurantError);

    if (state is RestaurantLoaded) {
      int index = state.restaurants.indexWhere((r) => r.id == favorite.id);
      if (index != -1) {
        RestaurantModel selectedRestaurant = state.restaurants[index];
        final coordinates = await selectedRestaurant.getCoordinates();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Restaurant(
              restaurantId: selectedRestaurant.id,
              restaurantName: selectedRestaurant.name,
              capacity: selectedRestaurant.capacity,
              restaurantImage: selectedRestaurant.restaurantImage,
              rating: selectedRestaurant.averageRating,
              price: selectedRestaurant.price,
              location: selectedRestaurant.location,
              time: selectedRestaurant.openingHours,
              latitude: coordinates[0],
              longitude: coordinates[1],
            ),
          ),
        );
      } else {
        debugPrint('Restaurant not found.');
      }
    } else if (state is RestaurantError) {
      debugPrint('Failed to load restaurants, please try again.');
    }
  }

  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              height: 100.0,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
