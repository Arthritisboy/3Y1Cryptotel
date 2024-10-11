import 'package:hotel_flutter/data/data_provider/auth/restaurant_data_provider.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

class RestaurantRepository {
  final RestaurantDataProvider dataProvider;
  List<RestaurantModel>? _cachedRestaurants;

  RestaurantRepository(this.dataProvider);

  //! Fetch All Restaurants
  Future<List<RestaurantModel>> fetchRestaurants() async {
    if (_cachedRestaurants != null) {
      return _cachedRestaurants!;
    }
    try {
      final restaurants = await dataProvider.fetchRestaurants();
      _cachedRestaurants = restaurants;
      return restaurants;
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  //! Fetch Single Restaurant by ID
  Future<RestaurantModel> fetchRestaurantById(String restaurantId) async {
    try {
      return await dataProvider.fetchRestaurantById(restaurantId);
    } catch (e) {
      throw Exception('Failed to load restaurant by ID: $e');
    }
  }

  //! Clear Restaurant Cache
  void clearRestaurantCache() {
    _cachedRestaurants = null;
  }
}
