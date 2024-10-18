import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_bloc.dart';
import 'package:hotel_flutter/logic/bloc/booking/booking_event.dart';
import 'package:hotel_flutter/logic/bloc/rating/rating_bloc.dart';
import 'package:hotel_flutter/logic/bloc/rating/rating_event.dart';
import 'package:hotel_flutter/logic/bloc/rating/rating_state.dart';

class HistoryModal extends StatefulWidget {
  final String bookingId;
  final String checkInDate;
  final String checkoutDate;
  final String hotelOrResto;
  final String bookingType;
  final String restaurantId;
  final String bookingDeleteId;

  const HistoryModal({
    super.key,
    required this.restaurantId,
    required this.bookingDeleteId,
    required this.bookingId,
    required this.checkInDate,
    required this.checkoutDate,
    required this.hotelOrResto,
    required this.bookingType,
  });

  @override
  State<HistoryModal> createState() => _HistoryModalState();
}

class _HistoryModalState extends State<HistoryModal> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _textFieldScrollController = ScrollController();
  final FlutterSecureStorage _storage =
      const FlutterSecureStorage(); // Storage instance

  int _currentLength = 0;
  final int _maxLength = 500;
  int rating = 0;
  String? _userId; // Store the userId

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch userId on initialization
    _commentController.addListener(() {
      setState(() {
        _currentLength = _commentController.text.length;
      });
    });
  }

  // Fetch the userId from secure storage
  Future<void> _fetchUserId() async {
    final userId = await _storage.read(key: 'userId');
    setState(() {
      _userId = userId;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _textFieldScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingBloc, RatingState>(
      listener: (context, state) {
        if (state is RatingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rating submitted successfully!'),
              duration: Duration(seconds: 3),
            ),
          );
        } else if (state is RatingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit rating: ${state.error}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 500,
                maxWidth: 350,
                minHeight: 500,
                minWidth: 350,
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildDetails(),
                    const Divider(height: 20.0, thickness: 1.0),
                    _buildRatingSection(),
                    _buildCommentSection(),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hotel/Restaurant Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 20.0, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.hotelOrResto, style: const TextStyle(fontSize: 16.0)),
          Text(widget.checkInDate, style: const TextStyle(fontSize: 16.0)),
          Text(widget.checkoutDate, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please rate the service:',
              style: TextStyle(fontSize: 16.0)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) =>
                    setState(() => rating = newRating.toInt()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comments',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Scrollbar(
              thumbVisibility: true,
              controller: _textFieldScrollController,
              child: SingleChildScrollView(
                controller: _textFieldScrollController,
                child: TextField(
                  controller: _commentController,
                  maxLength: _maxLength,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Leave your comment...',
                    border: InputBorder.none,
                    counterText: "",
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_currentLength/$_maxLength',
              style: TextStyle(
                fontSize: 12.0,
                color: _currentLength >= 400 ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (widget.bookingType == 'HotelBooking') {
              context.read<RatingBloc>().add(
                    CreateRoomRatingEvent(
                      roomId: widget.bookingId,
                      rating: rating,
                      message: _commentController.text,
                      userId: _userId!, // Ensure _userId is fetched
                    ),
                  );

              // Wait for the rating submission to complete
              final ratingState =
                  await context.read<RatingBloc>().stream.firstWhere(
                        (state) =>
                            state is RatingSuccess || state is RatingFailure,
                      );

              if (ratingState is RatingSuccess) {
                // Proceed to delete the booking if rating submission succeeds
                context.read<BookingBloc>().add(
                      DeleteBooking(
                        bookingId: widget.bookingDeleteId,
                        userId: _userId!, // Ensure userId is passed here
                      ),
                    );
              }
            } else if (widget.bookingType == 'RestaurantBooking') {
              print('test: ${widget.restaurantId}');
              context.read<RatingBloc>().add(
                    CreateRestaurantRatingEvent(
                      restaurantId: widget.restaurantId,
                      rating: rating,
                      message: _commentController.text,
                      userId: _userId!, // Ensure _userId is fetched
                    ),
                  );

              // Wait for the rating submission to complete
              final ratingState =
                  await context.read<RatingBloc>().stream.firstWhere(
                        (state) =>
                            state is RatingSuccess || state is RatingFailure,
                      );

              if (ratingState is RatingSuccess) {
                // Proceed to delete the booking if rating submission succeeds
                context.read<BookingBloc>().add(
                      DeleteBooking(
                          bookingId: widget.bookingDeleteId, userId: _userId!),
                    );
              }
            }

            // Close the dialog
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3473),
          ),
          child: const Text('Submit'),
        ),
      ),
    );
  }
}
