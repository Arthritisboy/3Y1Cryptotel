import 'package:hotel_flutter/data/data_provider/auth/rating_data_provider.dart';
import 'package:hotel_flutter/data/model/rating/hotel_and_restaurant_rating.dart';

class RatingRepository {
  final RatingDataProvider ratingDataProvider;

  RatingRepository({required this.ratingDataProvider});

  //! Create a new rating for a room
  Future<HotelAndRestaurantRating> createRoomRating({
    required String roomId,
    required int rating,
    required String message,
    required String userId,
  }) async {
    try {
      return await ratingDataProvider.createRoomRating(
        roomId: roomId,
        rating: rating,
        message: message,
        userId: userId,
      );
    } catch (error) {
      print('Error in RatingRepository (createRoomRating): $error');
      rethrow;
    }
  }

  //! Create a new rating for a restaurant
  Future<HotelAndRestaurantRating> createRestaurantRating({
    required String restaurantId,
    required int rating,
    required String message,
    required String userId,
  }) async {
    try {
      return await ratingDataProvider.createRestaurantRating(
        restaurantId: restaurantId,
        rating: rating,
        message: message,
        userId: userId,
      );
    } catch (error) {
      print('Error in RatingRepository (createRestaurantRating): $error');
      rethrow;
    }
  }
}
