class BookingModel {
  final String? id;
  final String bookingType;
  final String? hotelId;
  final String? restaurantName;
  final String? hotelName;
  final String? roomName;
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
  final int? tableNumber;
  final String? status;

  BookingModel({
    this.roomName,
    this.hotelName,
    this.restaurantName,
    this.id,
    this.tableNumber,
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
    required this.adult,
    required this.children,
    this.status,
  });

  // Convert JSON to BookingModel object
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      // id: json['_id'],
      bookingType: json['bookingType'],
      tableNumber: json['tableNumber'],
      restaurantName: json['restaurantName'],
      hotelName: json['hotelName'],
      roomName: json['roomName'],
      // hotelId: json['hotelId'],
      status: json['status'],
      // roomId: json['roomId'],
      // restaurantId:
      //     json['restaurantId'],
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
    );
  }

  // Convert BookingModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      // '_id': id, // Use "_id" when converting back to JSON
      'bookingType': bookingType,
      'hotelId': hotelId,
      'roomId': roomId,
      'restaurantId': restaurantId,
      'tableNumber': tableNumber,
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
      'status': status,
    };
  }
}
