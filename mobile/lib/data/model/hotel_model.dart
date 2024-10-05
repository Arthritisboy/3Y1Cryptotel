import 'package:geocoding/geocoding.dart';

class Hotel {
  final String imagePath;
  final String hotelName;
  final double rating;
  final int price;
  final String location;
  final String time;
  final int contactNumber;
  final String email;

  Hotel({
    required this.imagePath,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.contactNumber,
    required this.email,
  });

  factory Hotel.fromMap(Map<String, dynamic> data) {
    return Hotel(
      imagePath: data['imagePath'] as String,
      hotelName: data['hotelName'] as String,
      rating: data['rating'] as double,
      price: data['price'] as int,
      location: data['location'] as String,
      time: data['time'] as String,
      contactNumber: data['contactNumber'] as int,
      email: data['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'hotelName': hotelName,
      'rating': rating,
      'price': price,
      'location': location,
      'time': time,
      'contactNumber': contactNumber,
      'email': email, // Added email to the map
    };
  }

  Future<List<double>> getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(location);
      return [locations.first.latitude, locations.first.longitude];
    } catch (e) {
      // Handle exceptions, e.g., if the address is not found
      return [0.0, 0.0]; // Return a default value or handle it differently
    }
  }
}
