import 'package:hotel_flutter/data/data_provider/auth/favorite_data_provider.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_model.dart'; // Make sure to have the correct path

class FavoriteRepository {
  final FavoriteDataProvider dataProvider;

  FavoriteRepository(this.dataProvider);

  Future<FavoriteModel> getFavorites(String userId) async {
    try {
      // Fetch the favorites from the data provider
      final response = await dataProvider.getFavorites(userId);

      // Check if response is of expected type
      return response; // Return the FavoriteModel directly
    } catch (e) {
      // Log or handle errors accordingly
      throw Exception('Failed to fetch favorites: ${e.toString()}');
    }
  }
}
