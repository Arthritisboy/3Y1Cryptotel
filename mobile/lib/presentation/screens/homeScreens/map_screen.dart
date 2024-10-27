import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_bloc.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_event.dart';
import 'package:hotel_flutter/logic/bloc/hotel/hotel_state.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_bloc.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_event.dart';
import 'package:hotel_flutter/logic/bloc/restaurant/restaurant_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
      child: BlocBuilder<HotelBloc, HotelState>(
        builder: (context, hotelState) {
          return BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, restaurantState) {
              if (hotelState is HotelLoading ||
                  restaurantState is RestaurantLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (hotelState is HotelLoaded &&
                  restaurantState is RestaurantLoaded) {
                return _buildHotelAndRestaurantMap(
                    context, hotelState.hotels, restaurantState.restaurants);
              } else if (hotelState is HotelError) {
                return Center(child: Text('Hotel Error: ${hotelState.error}'));
              } else if (restaurantState is RestaurantError) {
                return Center(
                    child: Text('Restaurant Error: ${restaurantState.error}'));
              }
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget _buildHotelAndRestaurantMap(BuildContext context,
      List<HotelModel> hotels, List<RestaurantModel> restaurants) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(16.05, 120.3333), // Center over Dagupan
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              // Hotel markers
              ...hotels.map((hotel) {
                final coordinates = hotel.coordinates ?? [0.0, 0.0];
                return Marker(
                  point: LatLng(coordinates[0], coordinates[1]),
                  width: 150,
                  height: 150,
                  child: _buildMarkerContent(
                    imageUrl: hotel.hotelImage,
                    name: hotel.name,
                    averagePrice: hotel.averagePrice,
                  ),
                );
              }),
              // Restaurant markers
              ...restaurants.map((restaurant) {
                final coordinates = restaurant.coordinates ?? [0.0, 0.0];
                return Marker(
                  point: LatLng(coordinates[0], coordinates[1]),
                  width: 150,
                  height: 150,
                  child: _buildMarkerContent(
                    imageUrl: restaurant.restaurantImage,
                    name: restaurant.name,
                    averagePrice: restaurant.price,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerContent({
    required String imageUrl,
    required String name,
    required double averagePrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular image with a placeholder in case of error
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 40, // Slightly smaller size
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    size: 20,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8), // Add space between image and text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80, // Max width to prevent overflow
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C3473),
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 4), // Space between texts
              Text(
                '\u20B1${averagePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1C3473),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
