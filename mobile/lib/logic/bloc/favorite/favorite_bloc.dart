import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/repositories/favorite_repository.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_event.dart';
import 'package:hotel_flutter/logic/bloc/favorite/favorite_state.dart';
import 'package:hotel_flutter/data/model/favorite/favorite_item_model.dart';
import 'package:hotel_flutter/data/repositories/hotel_repository.dart';
import 'package:hotel_flutter/data/repositories/restaurant_repository.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository favoriteRepository;
  final HotelRepository hotelRepository;
  final RestaurantRepository restaurantRepository;

  FavoriteBloc(
    this.favoriteRepository,
    this.hotelRepository,
    this.restaurantRepository,
  ) : super(FavoriteInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
  }

  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());

    try {
      // Fetch favorite data (contains a list of hotel and restaurant IDs)
      final favoriteModel = await favoriteRepository.getFavorites(event.userId);

      // Fetch hotel details for each hotel ID using fetchHotelById
      final List<HotelModel> hotels = await Future.wait(
        favoriteModel.hotelIds
            .map((hotelId) => hotelRepository.fetchHotelById(hotelId)),
      );

      // Fetch restaurant details for each restaurant ID using fetchRestaurantById
      final List<RestaurantModel> restaurants = await Future.wait(
        favoriteModel.restaurantIds.map((restaurantId) =>
            restaurantRepository.fetchRestaurantById(restaurantId)),
      );

      // Create a list of FavoriteItem by mapping the fetched hotel and restaurant models
      final List<FavoriteItem> favorites = [
        ...hotels.map((hotel) => FavoriteItem(
              id: hotel.id,
              name: hotel.name,
              location: hotel.location,
              imageUrl: hotel.hotelImage,
            )),
        ...restaurants.map((restaurant) => FavoriteItem(
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
