import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/hotel/hotelClicked.dart';

class HotelScreen extends StatefulWidget {
  final String hotelImage;
  final String hotelName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final double latitude;
  final double longitude;
  final String hotelId;

  const HotelScreen({
    super.key,
    required this.hotelId,
    required this.hotelImage,
    required this.hotelName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.latitude,
    required this.longitude, // Updated typo
  });

  @override
  State<StatefulWidget> createState() {
    return _HotelScreenState();
  }
}

class _HotelScreenState extends State<HotelScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotelName),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            color: const Color.fromARGB(255, 52, 46, 46),
            onPressed: () {
              // Add favorite functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            HotelClicked(
              hotelId: widget.hotelId,
              hotelImage: widget.hotelImage,
              hotelName: widget.hotelName,
              rating: widget.rating,
              price: widget.price,
              location: widget.location,
              time: widget.time,
              activeIndex: _activeIndex,
              latitude: widget.latitude,
              longitude: widget.longitude,
              onNavTap: (index) {
                setState(() {
                  _activeIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
