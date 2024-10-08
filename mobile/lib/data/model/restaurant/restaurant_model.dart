class RestaurantModel {
  final String imagePath;
  final String restaurantName;
  final double rating;
  final String location;

  RestaurantModel({
    required this.imagePath,
    required this.restaurantName,
    required this.rating,
    required this.location,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> data) {
    return RestaurantModel(
      imagePath: data['imagePath'] as String,
      restaurantName: data['restaurantName'] as String,
      rating: data['rating'] as double,
      location: data['location'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'restaurantName': restaurantName,
      'rating': rating,
      'location': location,
    };
  }
}
