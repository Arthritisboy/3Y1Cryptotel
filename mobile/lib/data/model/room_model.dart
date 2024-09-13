class Room {
  final String imagePath;
  final String roomName;
  final String typeOfRoom;
  final double star;
  final int price;

  Room({
    required this.imagePath,
    required this.roomName,
    required this.typeOfRoom,
    required this.star,
    required this.price,
  });

  factory Room.fromMap(Map<String, dynamic> data) {
    return Room(
      imagePath: data['imagePath'] as String,
      roomName: data['roomName'] as String,
      typeOfRoom: data['typeOfRoom'] as String,
      star: data['star'] as double,
      price: data['price'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'roomName': roomName,
      'typeOfRoom': typeOfRoom,
      'star': star,
      'price': price,
    };
  }
}
