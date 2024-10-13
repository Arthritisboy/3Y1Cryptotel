import 'package:hotel_flutter/data/model/hotel/hotel_model.dart'; // Import your hotel model
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart'; // Import your restaurant model

class FavoriteModel {
  final List<HotelModel> hotels; // List of favorite Hotel objects
  final List<RestaurantModel>
      restaurants; // List of favorite Restaurant objects

  FavoriteModel({required this.hotels, required this.restaurants});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      hotels: (json['hotels'] as List<dynamic>?)
              ?.map((item) => HotelModel.fromJson(
                  item)) // Assuming you have a fromJson method in Hotel model
              .toList() ??
          [],
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((item) => RestaurantModel.fromJson(
                  item)) // Assuming you have a fromJson method in Restaurant model
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotels': hotels.map((hotel) => hotel.toJson()).toList(),
      'restaurants':
          restaurants.map((restaurant) => restaurant.toJson()).toList(),
    };
  }
}
