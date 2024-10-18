import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_bloc.dart';
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

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Center(
                    child: const Text(
                      'Favorites',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(), // Empty space to keep layout symmetrical
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoading) {
                  return _buildShimmerLoadingEffect();
                } else if (state is FavoritesFetched) {
                  return _buildFavoriteList(context, state.favorites);
                } else if (state is FavoriteError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return Container(); // For initial state
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList(
      BuildContext context, List<FavoriteItem> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Card(
          child: ListTile(
            leading: Image.network(favorite.imageUrl),
            title: Text(
              favorite.name,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              favorite.location,
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () {
              _navigateToFavorite(context, favorite); // Handle navigation
            },
          ),
        );
      },
    );
  }

  // Method to handle navigation based on favorite type
  void _navigateToFavorite(BuildContext context, FavoriteItem favorite) {
    if (favorite.type == 'hotel') {
      // Assuming FavoriteItem has a type property to distinguish hotel and restaurant
      // Fetch the hotel data (you might want to adjust based on your implementation)
      final hotelBloc = context.read<HotelBloc>();
      hotelBloc.add(FetchHotelsEvent()); // Ensure the list is updated

      Future.delayed(Duration.zero, () {
        final state = hotelBloc.state; // Get the current state

        if (state is HotelLoaded) {
          // Find the index of the favorite hotel
          int index = state.hotels.indexWhere((h) => h.id == favorite.id);
          if (index != -1) {
            // Get the hotel model
            HotelModel selectedHotel = state.hotels[index];

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
        }
      });
    } else if (favorite.type == 'restaurant') {
      // Assuming FavoriteItem has a type property to distinguish hotel and restaurant
      // Fetch the restaurant data (you might want to adjust based on your implementation)
      final restaurantBloc = context.read<RestaurantBloc>();
      restaurantBloc.add(FetchRestaurantsEvent()); // Ensure the list is updated

      Future.delayed(Duration.zero, () {
        final state = restaurantBloc.state; // Get the current state

        if (state is RestaurantLoaded) {
          // Find the index of the favorite restaurant
          int index = state.restaurants.indexWhere((r) => r.id == favorite.id);
          if (index != -1) {
            // Get the restaurant model
            RestaurantModel selectedRestaurant = state.restaurants[index];

            // Get coordinates for the selected restaurant
            selectedRestaurant.getCoordinates().then((coordinates) {
              // Navigate to the RestaurantScreen with the selected restaurant data
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Restaurant(
                    restaurantId: selectedRestaurant.id,
                    restaurantName: selectedRestaurant.name,
                    capacity: selectedRestaurant
                        .capacity, // Assuming capacity is part of the model
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
        }
      });
    }
  }

  // Shimmer Loading Effect for Cards
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Placeholder for loading items
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
