class RatingModel {
  final String id;
  final int rating;
  final String message;
  final String userId;

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
}
