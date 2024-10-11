class BookingRequest {
  final String id;
  final String bookingType; // HotelBooking or RestaurantBooking
  final String? hotelId;
  final String? roomId;
  final String? restaurantId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final DateTime? timeOfArrival;
  final DateTime? timeOfDeparture;
  final int adults;
  final int children;
  final double totalPrice;
  bool isAccepted;

  BookingRequest({
    required this.id,
    required this.bookingType,
    this.hotelId,
    this.roomId,
    this.restaurantId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.checkInDate,
    required this.checkOutDate,
    this.timeOfArrival,
    this.timeOfDeparture,
    required this.adults,
    required this.children,
    required this.totalPrice,
    this.isAccepted = false,
  });

  // Convert JSON to BookingRequest object
  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      id: json['id'],
      bookingType: json['bookingType'],
      hotelId: json['hotelId'],
      roomId: json['roomId'],
      restaurantId: json['restaurantId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      timeOfArrival: json['timeOfArrival'] != null
          ? DateTime.parse(json['timeOfArrival'])
          : null,
      timeOfDeparture: json['timeOfDeparture'] != null
          ? DateTime.parse(json['timeOfDeparture'])
          : null,
      adults: json['adults'],
      children: json['children'],
      totalPrice: json['totalPrice'].toDouble(),
      isAccepted: json['isAccepted'] ?? false,
    );
  }

  // Convert BookingRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingType': bookingType,
      'hotelId': hotelId,
      'roomId': roomId,
      'restaurantId': restaurantId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'timeOfArrival': timeOfArrival?.toIso8601String(),
      'timeOfDeparture': timeOfDeparture?.toIso8601String(),
      'adults': adults,
      'children': children,
      'totalPrice': totalPrice,
      'isAccepted': isAccepted,
    };
  }
}
