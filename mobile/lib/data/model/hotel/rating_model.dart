class RatingModel {
  final String id; // Unique identifier for the rating
  final int rating; // Rating value (1-5, etc.)
  final String message; // Optional message from the user
  final String userId; // Identifier for the user who made the rating

  // Constructor for RatingModel
  RatingModel({
    required this.id,
    required this.rating,
    required this.message,
    required this.userId,
  });

  // Factory method to create RatingModel from a JSON map
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      rating: json['rating'] as int,
      message: json['message'] as String,
    );
  }

  // Method to convert RatingModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'rating': rating,
      'message': message,
    };
  }
}
