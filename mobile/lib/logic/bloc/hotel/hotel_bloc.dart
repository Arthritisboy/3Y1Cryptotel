import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';
import 'package:hotel_flutter/data/repositories/hotel_repository.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository hotelRepository;
  List<HotelModel> allHotels =
      []; // Store the full list of hotels for filtering

  HotelBloc(this.hotelRepository) : super(HotelInitial()) {
    //! Event: Fetch all hotels
    on<FetchHotelsEvent>(_onFetchHotels);

    //! Event: Fetch single hotel details by ID
    on<FetchHotelDetailsEvent>(_onFetchHotelDetails);

    //! Event: Search hotels by query
    on<SearchHotelsEvent>(_onSearchHotels);
  }

  //! Fetch all hotels from repository
  Future<void> _onFetchHotels(
      FetchHotelsEvent event, Emitter<HotelState> emit) async {
    emit(HotelLoading());
    try {
      final hotels = await hotelRepository.fetchHotels();
      allHotels = hotels; // Cache the hotels list for search

      // Fetch coordinates for all hotels asynchronously
      await Future.wait(allHotels.map((hotel) => hotel.getCoordinates()));

      emit(HotelLoaded(hotels));
    } catch (e) {
      emit(HotelError('Failed to load hotels: ${e.toString()}'));
    }
  }

  //! Fetch single hotel details by ID
  Future<void> _onFetchHotelDetails(
      FetchHotelDetailsEvent event, Emitter<HotelState> emit) async {
    emit(HotelLoading());
    try {
      final hotel = await hotelRepository.fetchHotelById(event.hotelId);
      emit(HotelDetailsLoaded(hotel));
    } catch (e) {
      emit(HotelError('Failed to load hotel details: ${e.toString()}'));
    }
  }

  //! Search hotels based on query
  void _onSearchHotels(SearchHotelsEvent event, Emitter<HotelState> emit) {
    final query = event.query.trim().toLowerCase();

    // Filter hotels matching the search query
    final filteredHotels = allHotels.where((hotel) {
      final name = hotel.name.toLowerCase();
      final location = hotel.location.toLowerCase();
      return name.contains(query) || location.contains(query);
    }).toList();

    emit(HotelLoaded(filteredHotels)); // Emit the filtered hotels list
  }
}
