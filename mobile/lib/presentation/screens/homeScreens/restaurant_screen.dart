import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RestaurantBloc(context.read())..add(FetchRestaurantsEvent()),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Rated Restaurants',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 270.0, // Constraint height for the horizontal scroll
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    if (state is RestaurantLoading) {
                      return _buildShimmerLoadingEffect(); // Shimmer Effect
                    } else if (state is RestaurantLoaded) {
                      return _buildRestaurantList(context, state.restaurants);
                    } else if (state is RestaurantError) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return _buildShimmerLoadingEffect(); // Shimmer Effect
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantList(
      BuildContext context, List<RestaurantModel> restaurants) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: restaurants.map((RestaurantModel restaurant) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () async {
                List<double> coordinates = await restaurant.getCoordinates();
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => Restaurant(
                      restaurantId: restaurant.id,
                      restaurantImage: restaurant.restaurantImage,
                      restaurantName: restaurant.name,
                      rating: restaurant.rating,
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
                  rating: restaurant.rating),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Shimmer Loading Effect for Cards
  Widget _buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SizedBox(
                width: 250.0,
                height: 240.0,
                child: Card(
                  elevation: 4.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Container(
                          height: 130.0,
                          width: double.infinity,
                          color: Colors.white, // Placeholder for the image
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140.0,
                              height: 20.0,
                              color: Colors
                                  .white, // Placeholder for restaurant name
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Container(
                                  width: 15.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for the place icon
                                ),
                                const SizedBox(width: 4.0),
                                Container(
                                  width: 100.0,
                                  height: 15.0,
                                  color: Colors
                                      .white, // Placeholder for location text
                                ),
                                const Spacer(),
                                Container(
                                  width: 60.0,
                                  height: 25.0,
                                  color: Colors.white, // Placeholder for rating
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
