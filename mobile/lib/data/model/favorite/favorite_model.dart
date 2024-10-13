import 'package:hotel_flutter/data/model/hotel/hotel_model.dart'; // Import your hotel model
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart'; // Import your restaurant model

class FavoriteModel {
  final List<String> hotelIds; // List of favorite hotel IDs
  final List<String> restaurantIds; // List of favorite restaurant IDs

  FavoriteModel({
    required this.hotelIds,
    required this.restaurantIds,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      hotelIds: (json['hotels'] as List<dynamic>?)
              ?.map((item) => item as String) // Directly map to String IDs
              .toList() ??
          [],
      restaurantIds: (json['restaurants'] as List<dynamic>?)
              ?.map((item) => item as String) // Directly map to String IDs
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotels': hotelIds,
      'restaurants': restaurantIds,
    };
  }
}
