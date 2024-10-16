import 'package:bloc/bloc.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';
import 'package:hotel_flutter/data/repositories/restaurant_repository.dart';
import 'package:hotel_flutter/data/model/restaurant/restaurant_model.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository restaurantRepository;
  List<RestaurantModel> allRestaurants =
      []; // Cache the full list for filtering

  RestaurantBloc(this.restaurantRepository) : super(RestaurantInitial()) {
    // Fetch all restaurants
    on<FetchRestaurantsEvent>(_onFetchRestaurants);

    // Fetch single restaurant by ID
    on<FetchRestaurantDetailsEvent>(_onFetchRestaurantDetails);

    // Search restaurants by query
    on<SearchRestaurantsEvent>(_onSearchRestaurants);
  }

  //! Fetch all restaurants from repository
  Future<void> _onFetchRestaurants(
      FetchRestaurantsEvent event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      allRestaurants = restaurants; // Cache the list for search

      // Fetch coordinates for all hotels asynchronously
      await Future.wait(allRestaurants.map((hotel) => hotel.getCoordinates()));
      emit(RestaurantLoaded(restaurants));
    } catch (e) {
      emit(RestaurantError('Failed to load restaurants: ${e.toString()}'));
    }
  }

  //! Fetch single restaurant details by ID
  Future<void> _onFetchRestaurantDetails(
      FetchRestaurantDetailsEvent event, Emitter<RestaurantState> emit) async {
    emit(RestaurantLoading());
    try {
      final restaurant =
          await restaurantRepository.fetchRestaurantById(event.restaurantId);
      emit(RestaurantDetailsLoaded(restaurant));
    } catch (e) {
      emit(RestaurantError(
          'Failed to load restaurant details: ${e.toString()}'));
    }
  }

  //! Search restaurants based on query
  void _onSearchRestaurants(
      SearchRestaurantsEvent event, Emitter<RestaurantState> emit) {
    final query = event.query.trim().toLowerCase();

    // Filter restaurants matching the search query
    final filteredRestaurants = allRestaurants.where((restaurant) {
      final name = restaurant.name.toLowerCase();
      final location = restaurant.location.toLowerCase();
      return name.contains(query) || location.contains(query);
    }).toList();

    emit(RestaurantLoaded(filteredRestaurants)); // Emit the filtered list
  }
}
