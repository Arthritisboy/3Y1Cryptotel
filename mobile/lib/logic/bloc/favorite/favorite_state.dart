import 'package:equatable/equatable.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_item_model.dart'; // Adjust based on your model's location

abstract class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoritesFetched extends FavoriteState {
  final List<FavoriteItem> favorites;

  FavoritesFetched(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String error;

  FavoriteError(this.error);

  @override
  List<Object> get props => [error];
}
