class RoomModel {
  final String roomType;
  final int price;
  final double rating;
  final bool isAvailable;
  final String hotelName;
  final String location;
  final int numberofGuest;
  final List<String> imageUrls;

  RoomModel({
    required this.roomType,
    required this.price,
    required this.rating,
    required this.isAvailable,
    required this.imageUrls, // Ensure this is never null
    required this.hotelName,
    required this.location,
    required this.numberofGuest,
  });
}
