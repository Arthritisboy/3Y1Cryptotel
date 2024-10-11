import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/restaurant/details/restaurant_clicked.dart';

class Restaurant extends StatefulWidget {
  final String restaurantImage;
  final String restaurantName;
  final double rating;
  final double price;
  final String location;
  final String time;
  final double latitude;
  final double longitude;
  final String restaurantId;

  const Restaurant({
    super.key,
    required this.restaurantId,
    required this.restaurantImage,
    required this.restaurantName,
    required this.rating,
    required this.price,
    required this.location,
    required this.time,
    required this.latitude,
    required this.longitude, // Updated typo
  });

  @override
  State<StatefulWidget> createState() {
    return _RestaurantState();
  }
}

class _RestaurantState extends State<Restaurant> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
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
            RestaurantClicked(
              restaurantId: widget.restaurantId,
              restaurantImage: widget.restaurantImage,
              restaurantName: widget.restaurantName,
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
