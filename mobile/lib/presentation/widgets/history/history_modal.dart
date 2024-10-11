import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoryModal extends StatefulWidget {
  const HistoryModal({super.key});

  @override
  _HistoryModalState createState() => _HistoryModalState();
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
    double rating = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hotel Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the modal
                },
                child: const Icon(
                  Icons.close,
                  size: 20.0, // Smaller size for minimalistic look
                  color: Colors.black, // More subtle color
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deluxe Suite',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text('Check-in: 12th Jan, 2024'),
              const Text('Check-out: 15th Jan, 2024'),
              const SizedBox(height: 4.0),
              const Text('Pangasinan'),
              const Divider(
                height: 20.0,
                thickness: 1.0,
              ),
              const Text(
                'Please rate the service:',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              RatingBar.builder(
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
                onRatingUpdate: (rating) {
                  setState(() {
                    rating = rating;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _commentController,
                  maxLength: _maxLength,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Leave your comment...',
                    border: InputBorder.none,
                    counterText: "",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_currentLength >= 400)
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 16.0,
                          ),
                        ),
                      Text(
                        '$_currentLength/$_maxLength',
                        style: TextStyle(
                          fontSize: 12.0,
                          color:
                              _currentLength >= 400 ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Rating: $rating stars submitted for the service'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3473),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
