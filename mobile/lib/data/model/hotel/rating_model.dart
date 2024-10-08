class RatingModel {
  final String id;
  final int rating;
  final String message;
  final String userId;

  RatingModel({
    required this.id,
    required this.rating,
    required this.message,
    required this.userId,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'],
      userId: json['userId'],
      rating: json['rating'],
      message: json['message'],
    );
  }
}
