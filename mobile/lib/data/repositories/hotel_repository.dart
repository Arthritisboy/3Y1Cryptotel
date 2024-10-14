import 'package:hotel_flutter/data/data_provider/auth/hotel_data_provider.dart';
import 'package:hotel_flutter/data/model/hotel/hotel_model.dart';

class HotelRepository {
  final HotelDataProvider dataProvider;
  List<HotelModel>? _cachedHotels;

  HotelRepository(this.dataProvider);

  //! Fetch All Hotels
  Future<List<HotelModel>> fetchHotels() async {
    if (_cachedHotels != null) {
      return _cachedHotels!;
    }
    try {
      final hotels = await dataProvider.fetchHotels();
      _cachedHotels = hotels;
      return hotels;
    } catch (e) {
      throw Exception('Failed to load hotels: $e');
    }
  }

  //! Fetch Single Hotel by ID
  Future<HotelModel> fetchHotelById(String hotelId) async {
    try {
      return await dataProvider.fetchHotelById(hotelId);
    } catch (e) {
      throw Exception('Failed to load hotel by ID: $e');
    }
  }

  //! Fetch Multiple Hotels by IDs
  Future<List<HotelModel>> fetchHotelsByIds(List<String> hotelIds) async {
    try {
      final List<HotelModel> hotels = [];
      for (var id in hotelIds) {
        final hotel =
            await fetchHotelById(id); // Fetch hotel by ID using existing method
        hotels.add(hotel);
      }
      return hotels;
    } catch (e) {
      throw Exception('Failed to load hotels by IDs: $e');
    }
  }

  //! Clear Hotel Cache
  void clearHotelCache() {
    _cachedHotels = null;
  }
}
