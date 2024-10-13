// favorite_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/repositories/favorite_repository.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_event.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_state.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_item_model.dart'; // Adjust based on your model's location

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;

  FavoriteBloc(this.favoriteRepository) : super(FavoriteInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favoriteModel = await favoriteRepository.getFavorites(event.userId);

      // Convert FavoriteModel to List<FavoriteItem>
      final List<FavoriteItem> favorites = [
        ...favoriteModel.hotels.map((hotel) => FavoriteItem(
              id: hotel.id,
              name: hotel.name,
              location: hotel.location,
              imageUrl: hotel.hotelImage,
            )),
        ...favoriteModel.restaurants.map((restaurant) => FavoriteItem(
              id: restaurant.id,
              name: restaurant.name,
              location: restaurant.location,
              imageUrl: restaurant.restaurantImage,
            )),
      ];

      emit(FavoritesFetched(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to fetch favorites: ${e.toString()}'));
    }
  }
}
