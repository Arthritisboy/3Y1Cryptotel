import 'package:bloc/bloc.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';
import 'package:hotel_flutter/data/repositories/hotel_repository.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository hotelRepository;

  HotelBloc(this.hotelRepository) : super(HotelInitial()) {
    //! Fetch all hotels
    on<FetchHotelsEvent>((event, emit) async {
      emit(HotelLoading());
      try {
        final hotels = await hotelRepository.fetchHotels();
        emit(HotelLoaded(hotels));
      } catch (e) {
        emit(HotelError('Failed to load hotels: ${e.toString()}'));
      }
    });

    //! Fetch single hotel by ID
    on<FetchHotelDetailsEvent>((event, emit) async {
      emit(HotelLoading());
      try {
        final hotel = await hotelRepository.fetchHotelById(event.hotelId);
        emit(HotelDetailsLoaded(hotel));
      } catch (e) {
        emit(HotelError('Failed to load hotel details: ${e.toString()}'));
      }
    });
  }
}
