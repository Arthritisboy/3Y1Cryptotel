import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/map/map_widget.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/map/full_map.dart';

class HotelDetails extends StatelessWidget {
  final String hotelName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final double latitude;
  final double longitude;

  const HotelDetails({
    super.key,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Color.fromARGB(255, 142, 142, 147), size: 26),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Location: $location',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          Center(
            child: MapWidget(latitude: latitude, longitude: longitude),
          ),
          const SizedBox(height: 10),

          // Updated TextButton with Icon to the left
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenMap(
                    latitude: latitude,
                    longitude: longitude,
                    hotelName: hotelName,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.map, // Icon moved to the left
                  color: Color.fromARGB(255, 142, 142, 147),
                  size: 18,
                ),
                SizedBox(width: 5), // Add spacing between the icon and text
                Text(
                  'View Map',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.money,
                  color: Color.fromARGB(255, 142, 142, 147), size: 26),
              const SizedBox(width: 8.0),
              Text(
                'Price: ₱$price and over',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time,
                  color: Color.fromARGB(255, 142, 142, 147), size: 26),
              const SizedBox(width: 8.0),
              Text(
                'Open Hours: $time',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
