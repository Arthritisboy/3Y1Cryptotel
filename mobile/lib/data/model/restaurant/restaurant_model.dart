import 'package:geocoding/geocoding.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
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
  final List<RatingModel> ratings; // List of ratings

  // Constructor with default values
  RestaurantModel({
    required this.id,
    required this.name,
    required this.openingHours,
    required this.location,
    required this.restaurantImage,
    required this.price,
    required this.capacity,
    required this.availability,
    this.ratings = const [], // Default to an empty list
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    print("Parsing restaurant: ${json['name']}");

    var ratingsList = (json['ratings'] as List<dynamic>)
        .map((rating) => RatingModel.fromJson(rating))
        .toList();

    print("Ratings for ${json['name']}: ${ratingsList.length}");

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
      ratings: ratingsList,
    );
  }

  // Calculate the average rating from the list of ratings
  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    double total = ratings.fold(0.0, (sum, rating) => sum + rating.rating);
    return total / ratings.length;
  }

  // Fetch coordinates based on the location string
  Future<List<double>> getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(location);
      return [locations.first.latitude, locations.first.longitude];
    } catch (e) {
      _logger.severe("Error fetching coordinates for $location: $e");
      return [0.0, 0.0];
    }
  }
}
