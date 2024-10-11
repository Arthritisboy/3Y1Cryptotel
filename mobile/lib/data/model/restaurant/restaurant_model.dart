import 'package:geocoding/geocoding.dart';
import 'package:logging/logging.dart';

class RestaurantModel {
  final Logger _logger = Logger('RestaurantModel');
  final String id;
  final String name;
  final String location;
  final String openingHours;
  final String restaurantImage;
  final double price;
  final int capacity;
  final bool availability;
  final double rating; // Changed from nullable to non-nullable

  RestaurantModel({
    required this.id,
    required this.name,
    required this.openingHours,
    required this.location,
    required this.restaurantImage,
    required this.price,
    required this.capacity,
    required this.availability,
    this.rating = 0.0, // Default rating set to 0.0
  });

  // Factory method to create RestaurantModel from a map (API response)
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      openingHours: json['openingHours'] as String,
      location: json['location'] as String,
      restaurantImage: json['restaurantImage'] as String,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double),
      capacity: json['capacity'] as int,
      availability: json['availability'] as bool,
      rating: json['rating'] != null
          ? (json['rating'] is int
              ? (json['rating'] as int).toDouble()
              : (json['rating'] as double))
          : 0.0, // Default to 0.0 if rating is null
    );
  }

  // Fetch coordinates based on the location string
  Future<List<double>> getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(location);
      return [locations.first.latitude, locations.first.longitude];
    } catch (e) {
      _logger.info("Error fetching coordinates for $location: $e");
      return [0.0, 0.0];
    }
  }
}
