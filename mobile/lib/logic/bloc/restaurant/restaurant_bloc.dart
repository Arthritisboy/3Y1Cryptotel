import 'package:bloc/bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';
import 'package:hotel_flutter/data/repositories/restaurant_repository.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository restaurantRepository;

  RestaurantBloc(this.restaurantRepository) : super(RestaurantInitial()) {
    // Fetch all restaurants
    on<FetchRestaurantsEvent>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurants = await restaurantRepository.fetchRestaurants();
        emit(RestaurantLoaded(restaurants));
      } catch (e) {
        emit(RestaurantError('Failed to load restaurants: ${e.toString()}'));
      }
    });

    // Fetch single restaurant by ID
    on<FetchRestaurantDetailsEvent>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurant =
            await restaurantRepository.fetchRestaurantById(event.restaurantId);
        emit(RestaurantDetailsLoaded(restaurant));
      } catch (e) {
        emit(RestaurantError(
            'Failed to load restaurant details: ${e.toString()}'));
      }
    });
  }
}
