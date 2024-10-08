import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

final List<RestaurantModel> restaurantData = [
  RestaurantModel(
    id: '1',
    name: 'Matutinas',
    openingHours: '8:00 AM - 10:00 PM',
    location:
        'De Venecia Road, Extention, Brgy. Pantal, Dagupan City, Pangasinan',
    restaurantImage: 'assets/images/restaurant/matutinas.png',
    averageRating: 9.5,
    averagePrice:
        500.0, // Assuming you have average price data, adjust as needed
  ),
  RestaurantModel(
    id: '2',
    name: 'Dagupenas',
    openingHours: '9:00 AM - 9:00 PM',
    location:
        'De Venecia Road, Extention, Brgy. Pantal, Dagupan City, Pangasinan',
    restaurantImage: 'assets/images/restaurant/dagupenas.png',
    averageRating: 9.1,
    averagePrice:
        450.0, // Assuming you have average price data, adjust as needed
  ),
];
