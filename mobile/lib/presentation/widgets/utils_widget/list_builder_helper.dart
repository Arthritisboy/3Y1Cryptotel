// import 'package:flutter/material.dart';
// import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
// import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';
// import 'package:hotel_flutter/presentation/widgets/home/card_widget.dart';
// import 'package:hotel_flutter/presentation/screens/homeScreens/hotel_screen.dart';
// import 'package:hotel_flutter/presentation/screens/homeScreens/restaurant.dart';

// class ListBuilderHelper {
//   static Widget buildHotelList(
//       BuildContext context, List<HotelModel> hotels, Axis scrollDirection) {
//     final uniqueHotels = hotels.toSet().toList(); // Remove duplicates

//     return SingleChildScrollView(
//       scrollDirection: scrollDirection,
//       child: Row(
//         children: uniqueHotels.map((hotel) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16, right: 20.0, bottom: 20),
//             child: InkWell(
//               onTap: () async {
//                 List<double> coordinates = await hotel.getCoordinates();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HotelScreen(
//                       hotelId: hotel.id,
//                       hotelImage: hotel.hotelImage,
//                       hotelName: hotel.name,
//                       rating: hotel.averageRating,
//                       price: hotel.averagePrice,
//                       location: hotel.location,
//                       time: hotel.openingHours,
//                       latitude: coordinates[0],
//                       longitude: coordinates[1],
//                     ),
//                   ),
//                 );
//               },
//               child: CardWidget(
//                 imagePath: hotel.hotelImage,
//                 hotelName: hotel.name,
//                 location: hotel.location,
//                 rating: hotel.averageRating,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   static Widget buildRestaurantList(BuildContext context,
//       List<RestaurantModel> restaurants, Axis scrollDirection) {
//     final uniqueRestaurants = restaurants.toSet().toList(); // Remove duplicates

//     return SingleChildScrollView(
//       scrollDirection: scrollDirection,
//       child: Row(
//         children: uniqueRestaurants.map((restaurant) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16, right: 20.0, bottom: 20),
//             child: InkWell(
//               onTap: () async {
//                 List<double> coordinates = await restaurant.getCoordinates();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Restaurant(
//                       capacity: restaurant.capacity,
//                       restaurantId: restaurant.id,
//                       restaurantImage: restaurant.restaurantImage,
//                       restaurantName: restaurant.name,
//                       rating: restaurant.averageRating,
//                       price: restaurant.price,
//                       location: restaurant.location,
//                       time: restaurant.openingHours,
//                       latitude: coordinates[0],
//                       longitude: coordinates[1],
//                     ),
//                   ),
//                 );
//               },
//               child: CardWidget(
//                 imagePath: restaurant.restaurantImage,
//                 hotelName: restaurant.name,
//                 location: restaurant.location,
//                 rating: restaurant.averageRating,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
