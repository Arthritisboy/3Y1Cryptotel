import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/repositories/rating_repository.dart';
import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository;

  RatingBloc({required this.ratingRepository}) : super(RatingInitial());

  @override
  Stream<RatingState> mapEventToState(RatingEvent event) async* {
    if (event is CreateRoomRatingEvent) {
      yield RatingLoading();
      try {
        final rating = await ratingRepository.createRoomRating(
          roomId: event.roomId,
          rating: event.rating,
          message: event.message,
        );
        yield RatingSuccess(rating);
      } catch (e) {
        yield RatingFailure(e.toString());
      }
    }

    if (event is CreateRestaurantRatingEvent) {
      yield RatingLoading();
      try {
        final rating = await ratingRepository.createRestaurantRating(
          restaurantId: event.restaurantId,
          rating: event.rating,
          message: event.message,
        );
        yield RatingSuccess(rating);
      } catch (e) {
        yield RatingFailure(e.toString());
      }
    }
  }
}
