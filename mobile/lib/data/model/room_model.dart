class Hotel {
  final String imagePath;
  final String hotelName;
  final String typeOfRoom;
  final double rating;
  final int price;
  final String location;
  final String time;

  Hotel(
      {required this.imagePath,
      required this.hotelName,
      required this.typeOfRoom,
      required this.rating,
      required this.price,
      required this.location,
      required this.time});

  factory Hotel.fromMap(Map<String, dynamic> data) {
    return Hotel(
      imagePath: data['imagePath'] as String,
      hotelName: data['hotelName'] as String,
      typeOfRoom: data['typeOfRoom'] as String,
      rating: data['rating'] as double,
      price: data['price'] as int,
      location: data['location'] as String,
      time: data['time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'hotelName': hotelName,
      'typeOfRoom': typeOfRoom,
      'rating': rating,
      'price': price,
      'location': location,
      'time': time
    };
  }
}
