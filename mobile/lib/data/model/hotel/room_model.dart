import 'package:hotel_flutter/data/model/hotel/rating_model.dart';

class RoomModel {
  final String id;
  final String roomNumber;
  final String roomImage;
  final String type;
  final int price;
  final int capacity;
  final bool availability;
  final List<RatingModel> ratings;

  RoomModel({
    required this.id,
    required this.roomNumber,
    required this.roomImage,
    required this.type,
    required this.price,
    required this.capacity,
    required this.availability,
    required this.ratings,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'] ?? 'Unknown ID',
      roomNumber: json['roomNumber'] ?? 'Unknown Room',
      roomImage: json['roomImage'] ?? 'https://via.placeholder.com/150',
      type: json['type'] ?? 'Unknown Type',
      price: json['price'] ?? 0,
      capacity: json['capacity'] ?? 1,
      availability: json['availability'] ?? false,
      ratings: (json['ratings'] != null && json['ratings'] is List)
          ? (json['ratings'] as List)
              .map((ratingJson) => RatingModel.fromJson(ratingJson))
              .toList()
          : <RatingModel>[], // Default to an empty list if ratings is null or not a List
    );
  }

  // Method to convert RoomModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'roomNumber': roomNumber,
      'roomImage': roomImage,
      'type': type,
      'price': price,
      'capacity': capacity,
      'availability': availability,
      'ratings': ratings
          .map((rating) => rating.toJson())
          .toList(), // Assuming RatingModel has a toJson() method
    };
  }
}
