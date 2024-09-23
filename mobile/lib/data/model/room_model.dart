class Room {
  final String imagePath;
  final String roomName;
  final String typeOfRoom;
  final double rating;
  final int price;
  final String location;
  final String time;

  Room(
      {required this.imagePath,
      required this.roomName,
      required this.typeOfRoom,
      required this.rating,
      required this.price,
      required this.location,
      required this.time});

  factory Room.fromMap(Map<String, dynamic> data) {
    return Room(
      imagePath: data['imagePath'] as String,
      roomName: data['roomName'] as String,
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
      'roomName': roomName,
      'typeOfRoom': typeOfRoom,
      'rating': rating,
      'price': price,
      'location': location,
      'time': time
    };
  }
}
