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

  // Add the copyWith method
  BookingModel copyWith({
    String? id,
    String? bookingType,
    String? hotelId,
    String? restaurantName,
    String? hotelName,
    String? roomName,
    String? roomId,
    String? restaurantId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    DateTime? timeOfArrival,
    DateTime? timeOfDeparture,
    int? adult,
    int? children,
    int? tableNumber,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingType: bookingType ?? this.bookingType,
      hotelId: hotelId ?? this.hotelId,
      restaurantName: restaurantName ?? this.restaurantName,
      hotelName: hotelName ?? this.hotelName,
      roomName: roomName ?? this.roomName,
      roomId: roomId ?? this.roomId,
      restaurantId: restaurantId ?? this.restaurantId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      timeOfArrival: timeOfArrival ?? this.timeOfArrival,
      timeOfDeparture: timeOfDeparture ?? this.timeOfDeparture,
      adult: adult ?? this.adult,
      children: children ?? this.children,
      tableNumber: tableNumber ?? this.tableNumber,
      status: status ?? this.status,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingType: json['bookingType'],
      tableNumber: json['tableNumber'],
      restaurantName: json['restaurantName'],
      hotelName: json['hotelName'],
      roomName: json['roomName'],
      status: json['status'],
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

  Map<String, dynamic> toJson() {
    return {
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
