import 'package:equatable/equatable.dart';

abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object> get props => [];
}

class CreateRoomRatingEvent extends RatingEvent {
  final String roomId;
  final int rating;
  final String message;
  final String userId;
  const CreateRoomRatingEvent({
    required this.userId,
    required this.roomId,
    required this.rating,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, rating, message];
}

class CreateRestaurantRatingEvent extends RatingEvent {
  final String restaurantId;
  final int rating;
  final String message;
  final String userId;

  const CreateRestaurantRatingEvent({
    required this.userId,
    required this.restaurantId,
    required this.rating,
    required this.message,
  });

  @override
  List<Object> get props => [restaurantId, rating, message];
}
