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
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomImage: json['roomImage'],
      type: json['type'],
      price: json['price'],
      capacity: json['capacity'],
      availability: json['availability'],
      ratings: (json['ratings'] as List)
          .map((ratingJson) => RatingModel.fromJson(ratingJson))
          .toList(),
    );//hello
  }
}
