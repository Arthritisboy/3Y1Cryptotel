class RatingModel {
  final String id;
  final int rating;
  final String message;

  RatingModel({
    required this.id,
    required this.rating,
    required this.message,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'],
      rating: json['rating'],
      message: json['message'],
    );
  }
}
