class RoomModel {
  final String roomType;
  final int price;
  final double rating;
  final bool isAvailable;
  final String imageUrl;
  final String hotelName;
  final String location;
  final int numberofGuest;

  RoomModel({
    required this.roomType,
    required this.price,
    required this.rating,
    required this.isAvailable,
    required this.imageUrl,
    required this.hotelName,
    required this.location,
    required this.numberofGuest,
  });
}
