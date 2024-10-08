import 'package:hotel_flutter/data/model/hotel/room_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logging/logging.dart';

class HotelModel {
  final Logger _logger = Logger('HotelModel');
  final String id;
  final String name;
  final String location;
  final String openingHours;
  final String hotelImage;
  final double averageRating;
  final double averagePrice;
  final List<RoomModel> rooms;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.averageRating,
    required this.openingHours,
    required this.hotelImage,
    required this.rooms,
    required this.averagePrice,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      openingHours: json['openingHours'],
      averageRating: (json['averageRating'] is int)
          ? (json['averageRating'] as int).toDouble()
          : (json['averageRating'] as double),
      hotelImage: json['hotelImage'],
      averagePrice: (json['averagePrice'] is int)
          ? (json['averagePrice'] as int).toDouble()
          : (json['averagePrice'] as double),
      rooms: (json['rooms'] as List)
          .map((roomJson) => RoomModel.fromJson(roomJson))
          .toList(),
    );
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
