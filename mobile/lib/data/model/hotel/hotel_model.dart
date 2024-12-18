import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hotel_flutter/data/model/hotel/room_model.dart';

class HotelModel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String openingHours;
  final String hotelImage;
  final double averageRating;
  final double averagePrice;
  final List<RoomModel> rooms;
  List<double>? coordinates;

  HotelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.openingHours,
    required this.hotelImage,
    required this.averageRating,
    required this.rooms,
    required this.averagePrice,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['_id'] ?? 'Unknown ID',
      name: json['name'] ?? 'Unknown Hotel',
      location: json['location'] ?? 'Unknown Location',
      openingHours: json['openingHours'] ?? 'Unknown Hours',
      hotelImage: json['hotelImage'] ?? 'https://via.placeholder.com/150',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      averagePrice: (json['averagePrice'] ?? 0).toDouble(),
      rooms: (json['rooms'] is List)
          ? (json['rooms'] as List<dynamic>)
              .map((roomJson) => RoomModel.fromJson(roomJson))
              .toList()
          : <RoomModel>[], // Default to an empty list if not a list
    );
  }

  // Convert HotelModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'openingHours': openingHours,
      'hotelImage': hotelImage,
      'averageRating': averageRating,
      'averagePrice': averagePrice,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  // Fetch coordinates based on the location string
  Future<List<double>> getCoordinates() async {
    if (coordinates != null) return coordinates!; // Return if already fetched

    try {
      List<Location> locations = await locationFromAddress(location);
      coordinates = [locations.first.latitude, locations.first.longitude];
      return coordinates!;
    } catch (e) {
      return [0.0, 0.0]; // Return [0.0, 0.0] if there is an error
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        openingHours,
        hotelImage,
        averageRating,
        averagePrice,
        rooms,
      ];
}
