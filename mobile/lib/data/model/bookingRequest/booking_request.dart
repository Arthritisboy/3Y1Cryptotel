class BookingRequest {
  final String id;
  final String userName;
  final String bookingDetails;
  bool isAccepted;

  BookingRequest({
    required this.id,
    required this.userName,
    required this.bookingDetails,
    this.isAccepted = false,
  });
}
