import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {
  final String userId;

  FetchFavoritesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
