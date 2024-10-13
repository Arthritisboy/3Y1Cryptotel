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

  //! Fetch Multiple Restaurants by IDs
  Future<List<RestaurantModel>> fetchRestaurantsByIds(
      List<String> restaurantIds) async {
    try {
      final List<RestaurantModel> restaurants = [];
      for (var id in restaurantIds) {
        final restaurant =
            await fetchRestaurantById(id); // Fetch by ID using existing method
        restaurants.add(restaurant);
      }
      return restaurants;
    } catch (e) {
      throw Exception('Failed to load restaurants by IDs: $e');
    }
  }

  //! Clear Restaurant Cache
  void clearRestaurantCache() {
    _cachedRestaurants = null;
  }
}
