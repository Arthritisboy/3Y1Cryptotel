import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}

class FetchRestaurantsEvent extends RestaurantEvent {}

class FetchRestaurantDetailsEvent extends RestaurantEvent {
  final String restaurantId;

  const FetchRestaurantDetailsEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}
