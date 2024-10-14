class FavoriteItem {
  final String id; // Unique identifier for the favorite item
  final String name; // Name of the hotel or restaurant
  final String location; // Location of the hotel or restaurant
  final String imageUrl; // URL of the image for the hotel or restaurant

  // Constructor for FavoriteItem
  FavoriteItem({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
  });

  // Factory method to create FavoriteItem from a JSON map
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Method to convert FavoriteItem to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
