import 'package:geocoding/geocoding.dart';
import 'package:logging/logging.dart';

class RestaurantModel {
  final Logger _logger = Logger('RestaurantModel');
  final String id;
  final String name;
  final String location;
  final String openingHours;
  final String restaurantImage;
  final double averageRating;
  final double averagePrice;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.openingHours,
    required this.location,
    required this.restaurantImage,
    required this.averageRating,
    required this.averagePrice,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> data) {
    return RestaurantModel(
      id: data['id'] as String,
      name: data['name'] as String,
      openingHours: data['openingHours'] as String,
      location: data['location'] as String,
      restaurantImage: data['restaurantImage'] as String,
      averageRating: data['averageRating'] is int
          ? (data['averageRating'] as int).toDouble()
          : data['averageRating'] as double,
      averagePrice: data['averagePrice'] is int
          ? (data['averagePrice'] as int).toDouble()
          : data['averagePrice'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'openingHours': openingHours,
      'location': location,
      'restaurantImage': restaurantImage,
      'averageRating': averageRating,
      'averagePrice': averagePrice,
    };
  }

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
