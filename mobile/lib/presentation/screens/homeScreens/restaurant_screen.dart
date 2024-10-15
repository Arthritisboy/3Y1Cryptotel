import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
import 'package:hotel_flutter/presentation/widgets/shimmer_loading/card/shimmer_card.dart';

class RestaurantScreen extends StatelessWidget {
  final String searchQuery;
  final Axis scrollDirection;
  final String rowOrColumn;
  final double width;

  const RestaurantScreen(
      {super.key,
      required this.searchQuery,
      required this.scrollDirection,
      required this.rowOrColumn,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RestaurantBloc(context.read())..add(FetchRestaurantsEvent()),
      child: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return ShimmerCard(scrollDirection: scrollDirection);
          } else if (state is RestaurantLoaded) {
            final filteredRestaurants = state.restaurants
                .where((restaurant) => restaurant.name
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                .toList();
            return _buildRestaurantList(context, filteredRestaurants);
          } else if (state is RestaurantError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return ShimmerCard(scrollDirection: scrollDirection);
        },
      ),
    );
  }

  Widget _buildRestaurantList(
      BuildContext context, List<RestaurantModel> restaurants) {
    final uniqueRestaurants = restaurants.toSet().toList(); // Remove duplicates

    final children = uniqueRestaurants.map((restaurant) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 20.0, bottom: 20),
        child: InkWell(
          onTap: () async {
            List<double> coordinates = await restaurant.getCoordinates();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Restaurant(
                  capacity: restaurant.capacity,
                  restaurantId: restaurant.id,
                  restaurantImage: restaurant.restaurantImage,
                  restaurantName: restaurant.name,
                  rating: restaurant.averageRating,
                  price: restaurant.price,
                  location: restaurant.location,
                  time: restaurant.openingHours,
                  latitude: coordinates[0],
                  longitude: coordinates[1],
                ),
              ),
            );
          },
          child: CardWidget(
            imagePath: restaurant.restaurantImage,
            hotelName: restaurant.name,
            location: restaurant.location,
            rating: restaurant.averageRating,
            width: width,
          ),
        ),
      );
    }).toList();

    if (rowOrColumn == 'row') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    } else {
      return Column(children: children);
    }
  }
}
