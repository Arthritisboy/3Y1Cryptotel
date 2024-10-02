class RoomModel {
  final String roomType;
  final int price;
  final bool isAvailable;
  final String imageUrl;
  final String hotelName;
  final int numberofGuest;

  RoomModel({
    required this.roomType,
    required this.price,
    required this.isAvailable,
    required this.imageUrl,
    required this.hotelName,
    required this.numberofGuest,
  });
}
