class HotelAndRestaurantRating {
  final String id; // Unique identifier for the rating
  final String userId; // ID of the user who created the rating
  final int rating; // Rating value (e.g., from 1 to 5)
  final String message; // Optional message or review
  final DateTime createdAt; // Timestamp of when the rating was created

  HotelAndRestaurantRating({
    required this.id,
    required this.userId,
    required this.rating,
    required this.message,
    required this.createdAt,
  });

  // Factory method to create a Rating instance from JSON
  factory HotelAndRestaurantRating.fromJson(Map<String, dynamic> json) {
    return HotelAndRestaurantRating(
      id: json['_id'] as String, // Assuming the ID field from your backend is '_id'
      userId: json['userId'] as String,
      rating: json['rating'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Method to convert a Rating instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'rating': rating,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
