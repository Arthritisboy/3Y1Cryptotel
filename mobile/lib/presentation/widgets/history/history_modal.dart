import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/logic/bloc/rating/rating_bloc.dart';
import 'package:hotel_flutter/logic/bloc/rating/rating_event.dart'; // Ensure you have this import

class HistoryModal extends StatefulWidget {
  final String bookingId;
  final String checkInDate;
  final String checkoutDate;
  final String hotelOrResto;
  final String bookingType; // New property for booking type

  const HistoryModal({
    super.key,
    required this.bookingId,
    required this.checkInDate,
    required this.checkoutDate,
    required this.hotelOrResto,
    required this.bookingType, // Accept booking type in the constructor
  });

  @override
  State<StatefulWidget> createState() {
    return _HistoryModalState();
  }
}

class _HistoryModalState extends State<HistoryModal> {
  final TextEditingController _commentController = TextEditingController();
  int _currentLength = 0;
  final int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        _currentLength = _commentController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int rating = 0;

    return Dialog(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hotel/Restaurant Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hotelOrResto,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          widget.checkInDate,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          widget.checkoutDate,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 20.0, thickness: 1.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Please rate the service:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
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
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (newRating) {
        setState(() {
          rating = newRating.toInt(); // Convert to int
        });
      },
    ),
  ),
),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
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
                            child: SingleChildScrollView(
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
                              color: _currentLength >= 400
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 5.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Dispatch the appropriate event based on booking type
                          if (widget.bookingType == 'HotelBooking') {
                            BlocProvider.of<RatingBloc>(context).add(
                              CreateRoomRatingEvent(
                                roomId: widget.bookingId,
                                rating: rating,
                                message: _commentController.text,
                              ),
                            );
                          } else if (widget.bookingType == 'RestaurantBooking') {
                            BlocProvider.of<RatingBloc>(context).add(
                              CreateRestaurantRatingEvent(
                                restaurantId: widget.bookingId,
                                rating: rating,
                                message: _commentController.text,
                              ),
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Rating: $rating stars submitted for the service'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C3473),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
