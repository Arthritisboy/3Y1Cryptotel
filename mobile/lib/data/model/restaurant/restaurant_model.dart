import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hotel_flutter/data/model/hotel/rating_model.dart';
import 'package:logging/logging.dart';

class RestaurantModel extends Equatable {
  final Logger _logger = Logger('RestaurantModel');
  final String id;
  final String name;
  final String location;
  final String openingHours;
  final String restaurantImage;
  final double price;
  final int capacity;
  final bool availability;
  final List<RatingModel> ratings;

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
    this.ratings = const [],
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    var ratingsList = (json['ratings'] is List)
        ? (json['ratings'] as List<dynamic>)
            .map((rating) => RatingModel.fromJson(rating))
            .toList()
        : <RatingModel>[]; // Default to an empty list if not a list

    return RestaurantModel(
      id: json['_id'] ?? 'Unknown ID',
      name: json['name'] ?? 'Unknown Restaurant',
      openingHours: json['openingHours'] ?? 'Unknown Hours',
      location: json['location'] ?? 'Unknown Location',
      restaurantImage:
          json['restaurantImage'] ?? 'https://via.placeholder.com/150',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double),
      capacity: json['capacity'] ?? 0,
      availability: json['availability'] ?? false,
      ratings: ratingsList,
    );
  }

  // Convert RestaurantModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'openingHours': openingHours,
      'restaurantImage': restaurantImage,
      'price': price,
      'capacity': capacity,
      'availability': availability,
      'ratings': ratings.map((rating) => rating.toJson()).toList(),
    };
  }

  // Calculate the average rating from the list of ratings
  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    double total = ratings.fold(0.0, (sum, rating) => sum + rating.rating);
    double average = total / ratings.length;

    // Format to 1 decimal place
    return double.parse(average.toStringAsFixed(1));
  }

  // Fetch coordinates based on the location string
  Future<List<double>> getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(location);
      return [locations.first.latitude, locations.first.longitude];
    } catch (e) {
      _logger.severe("Error fetching coordinates for $location: $e");
      return [0.0, 0.0]; // Return [0.0, 0.0] if there is an error
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        openingHours,
        restaurantImage,
        price,
        capacity,
        availability,
        ratings,
      ];
}
