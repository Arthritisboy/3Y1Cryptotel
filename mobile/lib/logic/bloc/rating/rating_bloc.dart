import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/repositories/rating_repository.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc({required this.ratingRepository}) : super(RatingInitial()) {
    on<CreateRoomRatingEvent>((event, emit) async {
      emit(RatingLoading());
      try {
        final rating = await ratingRepository.createRoomRating(
          roomId: event.roomId,
          rating: event.rating,
          message: event.message,
          userId: event.userId,
        );
        emit(RatingSuccess(rating));
      } catch (e) {
        emit(RatingFailure('Failed to submit room rating: ${e.toString()}'));
      }
    });

    on<CreateRestaurantRatingEvent>((event, emit) async {
      emit(RatingLoading());
      try {
        final rating = await ratingRepository.createRestaurantRating(
          restaurantId: event.restaurantId,
          rating: event.rating,
          message: event.message,
          userId: event.userId,
        );
        emit(RatingSuccess(rating));
      } catch (e) {
        emit(RatingFailure(
            'Failed to submit restaurant rating: ${e.toString()}'));
      }
    });
  }
}
