import 'package:flutter/material.dart';
import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
import 'package:hotel_flutter/data/model/restaurant_model.dart';
import 'package:hotel_flutter/data/dummydata/restaurant_data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Rated Restaurants',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildRestaurantList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRestaurantList() {
    return restaurantData.map((RestaurantModel restaurant) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: CardWidget(
          imagePath: restaurant.imagePath,
          hotelName: restaurant.restaurantName,
          location: restaurant.location,
          rating: restaurant.rating,
        ),
      );
    }).toList();
  }
}
