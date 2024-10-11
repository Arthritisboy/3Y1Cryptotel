import 'package:hotel_flutter/data/data_provider/booking_data_provider.dart';
import 'package:hotel_flutter/data/model/booking/booking_model.dart';

class BookingRepository {
  final BookingDataProvider dataProvider;

  BookingRepository({required this.dataProvider});

  Future<List<BookingModel>> fetchBookings(String userId) async {
    return await dataProvider.fetchBookings(userId);
  }

  Future<BookingModel> createBooking(
      BookingModel booking, String userId) async {
    return await dataProvider.createBooking(booking, userId);
  }

  Future<void> updateBooking(BookingModel booking, String bookingId) async {
    return await dataProvider.updateBooking(booking, bookingId);
  }

  Future<void> deleteBooking(String bookingId) async {
    return await dataProvider.deleteBooking(bookingId);
  }
}
