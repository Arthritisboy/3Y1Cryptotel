import 'dart:io';

class CreateRoomModel {
  final String roomNumber;
  final String type;
  final int price;
  final int capacity;
  final List<String> ratingIds;
  final File image; // Required image file

  CreateRoomModel({
    required this.roomNumber,
    required this.type,
    required this.price,
    required this.capacity,
    this.ratingIds = const [],
    required this.image,
  });

  // Convert CreateRoomModel to a map for HTTP requests (without the image)
  Map<String, String> toMap() {
    final data = {
      'roomNumber': roomNumber,
      'type': type,
      'price': price.toString(),
      'capacity': capacity.toString(),
    };

    if (ratingIds.isNotEmpty) {
      data['ratings'] =
          ratingIds.join(','); // Convert list to comma-separated string
    }

    return data;
  }

  // Factory method to create CreateRoomModel from JSON
  factory CreateRoomModel.fromJson(Map<String, dynamic> json) {
    return CreateRoomModel(
      roomNumber: json['roomNumber'] as String,
      type: json['type'] as String,
      price: json['price'] as int,
      capacity: json['capacity'] as int,
      ratingIds: List<String>.from(json['ratings'] ?? []),
      image: File(''), // Image needs to be handled separately
    );
  }
}
