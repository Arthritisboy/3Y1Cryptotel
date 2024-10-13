import 'package:hotel_flutter/data/data_provider/auth/favorite_data_provider.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_model.dart'; // Make sure to have the correct path

class FavoriteRepository {
  final FavoriteDataProvider dataProvider;

  FavoriteRepository(this.dataProvider);

  Future<FavoriteModel> getFavorites(String userId) {
    return dataProvider.getFavorites(userId);
  }
}
