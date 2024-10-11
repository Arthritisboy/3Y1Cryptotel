class BookingModel {
  final String? id;
  final String bookingType;
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
  final int adult;
  final int children;
  final int? totalPrice;

  BookingModel({
    this.id,
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
    required this.timeOfArrival,
    required this.timeOfDeparture,
    required this.adult,
    required this.children,
    this.totalPrice,
  });

  // Convert JSON to BookingModel object
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
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
      adult: json['adult'],
      children: json['children'],
      totalPrice: json['totalPrice'],
    );
  }

  // Convert BookingModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingType': bookingType,
      'hotelId': hotelId,
      'roomId': roomId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'checkInDate': checkInDate.toUtc().toIso8601String(),
      'checkOutDate': checkOutDate.toUtc().toIso8601String(),
      'timeOfArrival': timeOfArrival?.toUtc().toIso8601String(),
      'timeOfDeparture': timeOfDeparture?.toUtc().toIso8601String(),
      'adult': adult,
      'children': children,
    };
  }
}
