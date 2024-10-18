class BookingModel {
  final String? id;
  final String bookingType;
  final String? hotelId;
  final String? restaurantName;
  final String? hotelImage;
  final String? restaurantImage;
  final String? hotelName;
  final String? roomName;
  final String? roomId;
  final String? userId;
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
  final int? totalPrice;

  BookingModel({
    this.hotelImage,
    this.restaurantImage,
    this.id,
    required this.bookingType,
    this.hotelId,
    this.restaurantName,
    this.hotelName,
    this.roomName,
    this.roomId,
    this.userId,
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
    this.tableNumber,
    this.status,
    this.totalPrice,
  });

  // Add the copyWith method
  BookingModel copyWith({
    String? id,
    String? userId,
    String? hotelImage,
    String? restaurantImage,
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
    int? totalPrice,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hotelImage: hotelImage ?? this.hotelImage,
      restaurantImage: userId ?? this.restaurantImage,
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
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  String toString() {
    return 'BookingModel{id: $id, bookingType: $bookingType, restaurantName: $restaurantName, hotelName: $hotelName, roomName: $roomName}';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      bookingType: json['bookingType'] ?? '',
      hotelImage: json['hotelImage'] ?? '',
      restaurantImage: json['restaurantImage'] ?? '',
      restaurantName: json['restaurantName'],
      hotelName: json['hotelName'],
      roomName: json['roomName'],
      hotelId:
          json['hotelId'] is Map ? json['hotelId']['_id'] : json['hotelId'],
      roomId: json['roomId'] is Map ? json['roomId']['_id'] : json['roomId'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      timeOfArrival: json['timeOfArrival'] != null
          ? DateTime.parse(json['timeOfArrival'])
          : null,
      timeOfDeparture: json['timeOfDeparture'] != null
          ? DateTime.parse(json['timeOfDeparture'])
          : null,
      adult: int.tryParse(json['adult'].toString()) ?? 1,
      children: int.tryParse(json['children'].toString()) ?? 0,
      tableNumber: json['tableNumber'] != null
          ? int.tryParse(json['tableNumber'].toString())
          : null,
      status: json['status'],
      totalPrice: json['totalPrice'] != null
          ? int.tryParse(json['totalPrice'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingType': bookingType,
      'userId': userId,
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
      'totalPrice': totalPrice,
    };
  }
}
