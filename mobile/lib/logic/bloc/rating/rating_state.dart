import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/rating/hotel_and_restaurant_rating.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final HotelAndRestaurantRating rating;

  const RatingSuccess(this.rating);

  @override
  List<Object> get props => [rating];
}

class RatingFailure extends RatingState {
  final String error;

  const RatingFailure(this.error);

  @override
  List<Object> get props => [error];
}
