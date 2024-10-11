import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantModel> restaurants;

  const RestaurantLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantDetailsLoaded extends RestaurantState {
  final RestaurantModel restaurant;

  const RestaurantDetailsLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String error;

  const RestaurantError(this.error);

  @override
  List<Object?> get props => [error];
}
