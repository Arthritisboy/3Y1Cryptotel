import 'package:hotel_flutter/data/data_provider/auth/rating_data_provider.dart';
import 'package:hotel_flutter/data/model/rating/hotel_and_restaurant_rating.dart';

class RatingRepository {
  final RatingDataProvider ratingDataProvider;

  RatingRepository({required this.ratingDataProvider});

  //! Create Room Rating
  Future<HotelAndRestaurantRating> createRoomRating({
    required String roomId,
    required int rating,
    required String message,
  }) async {
    try {
      return await ratingDataProvider.createRoomRating(
        roomId: roomId,
        rating: rating,
        message: message,
      );
    } catch (e) {
      throw Exception('Failed to create room rating: $e');
    }
  }

  //! Create Restaurant Rating
  Future<HotelAndRestaurantRating> createRestaurantRating({
    required String restaurantId,
    required int rating,
    required String message,
  }) async {
    try {
      return await ratingDataProvider.createRestaurantRating(
        restaurantId: restaurantId,
        rating: rating,
        message: message,
      );
    } catch (e) {
      throw Exception('Failed to create restaurant rating: $e');
    }
  }
}
